import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fontend/screens/Cooking_step/recipe_run_provider.dart';
import 'package:fontend/screens/Cooking_step/recipe_run_widgets.dart';
import 'package:fontend/screens/Cooking_step/recipe_step_model.dart';




// 2. MÀN HÌNH CHÍNH
class RecipeRunScreen extends ConsumerStatefulWidget {
  const RecipeRunScreen({super.key});

  @override
  ConsumerState<RecipeRunScreen> createState() => _RecipeRunScreenState();
}

class _RecipeRunScreenState extends ConsumerState<RecipeRunScreen> {
  final PageController _pageController = PageController();

  void _nextPage() {
    _pageController.nextPage(duration: const Duration(milliseconds: 400), curve: Curves.easeInOut);
  }

  void _prevPage() {
    _pageController.previousPage(duration: const Duration(milliseconds: 400), curve: Curves.easeInOut);
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
            physics: const NeverScrollableScrollPhysics(), // Chặn user tự vuốt, bắt buộc dùng nút
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
                    onNextPage: () {
                      if (nextStep != null) {
                        _nextPage();
                      } else {
                        // Xử lý khi hoàn thành món ăn
                        Navigator.pop(context);
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