import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../survey_2/cook_level2_screen.dart';
import '../logic/cook_level_provider.dart';

class CookingNextButton extends ConsumerWidget {
  final VoidCallback onNext;
  const CookingNextButton({super.key, required this.onNext});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selected = ref.watch(cookingLevelProvider);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
      child: SizedBox(
        width: double.infinity,
        height: 60,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            elevation: 0,
            backgroundColor: const Color(0xFFFFB901), // màu vàng đậm
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20), // bo góc lớn hơn
            ),
          ),

          onPressed: selected != null
              ? () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const InterestScreen(),
              ),
            );
          } :
           null,

          child: const Text(
            'tiếp theo',
            style: TextStyle(
              color: Colors.black, // tím như trong hình
              fontSize: 20,
              fontWeight: FontWeight.w700,
              fontFamily: 'SF Pro Rounded',
              letterSpacing: 0.2,
            ),
          ),
        ),
      ),
    );
  }
}
