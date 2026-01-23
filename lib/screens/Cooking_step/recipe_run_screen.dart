import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fontend/screens/Cooking_step/recipe_run_provider.dart';
import 'package:fontend/screens/Cooking_step/recipe_run_widgets.dart';


import 'cooking_timer_service.dart';
import 'finish.dart';

// 2. MÀN HÌNH CHÍNH
class RecipeRunScreen extends ConsumerStatefulWidget {
  const RecipeRunScreen({super.key});

  @override
  ConsumerState<RecipeRunScreen> createState() => _RecipeRunScreenState();
}

class _RecipeRunScreenState extends ConsumerState<RecipeRunScreen> with WidgetsBindingObserver {
  final PageController _pageController = PageController();
  final _timerService = CookingTimerService();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    // App đang ở foreground khi màn hình này mở
    _timerService.setAppInForeground(true);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _pageController.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);

    if (state == AppLifecycleState.resumed) {
      // App vào foreground - ẩn notification
      _timerService.setAppInForeground(true);
    } else if (state == AppLifecycleState.paused ||
        state == AppLifecycleState.inactive) {
      // App vào background - hiện notification
      _timerService.setAppInForeground(false);
    }
  }

  void _nextPage() {
    _pageController.nextPage(
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeInOut,
    );
  }

  void _prevPage() {
    _pageController.previousPage(
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    final steps = ref.watch(recipeStepsProvider);

    return Scaffold(
      backgroundColor: Colors.white,
      body: ClipRRect(
        borderRadius: BorderRadius.circular(0),
        child: Container(
          color: Colors.white,
          child: PageView.builder(
            controller: _pageController,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: steps.length,
            itemBuilder: (context, index) {
              final step = steps[index];
              final nextStep = (index < steps.length - 1) ? steps[index + 1] : null;

              return Stack(
                children: [
                  // Các thành phần UI cố định
                  RecipeRunHeader(onTapBack: () => Navigator.pop(context)),
                  RecipeRunTitle(stepIndex: index),
                  RecipeRunDescription(text: step.description),
                  RecipeRunImage(imagePath: step.imagePath),

                  // Bottom Card thông minh (Tự chuyển từ đếm ngược -> nấu)
                  RecipeSmartBottomCard(
                    stepData: step,
                    nextStepData: nextStep,
                    stepNumber: index + 1,
                    onNextPage: () {
                      if (nextStep != null) {
                        _nextPage();
                      } else {
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(builder: (context) => RecipeCompletionScreen())
                        );
                      }
                    },
                    onPrevPage: () {
                      if (index > 0) _prevPage();
                    },
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}