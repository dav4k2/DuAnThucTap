import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:fontend/screens/Cooking_step/recipe_run_screen.dart';
import '../../Cooking_step/recipe_run_provider.dart';
import '../../Cooking_step/recipe_step_model.dart';
import '../../Cooking_step/recipe_step_model.dart' as run_model;
import '../../Crete_recipe/logic/publish_recipe.dart';

class StepsSection extends ConsumerWidget {
  final PublishRecipe recipe;
  final double width;

  const StepsSection({
    super.key,
    required this.width,
    required this.recipe,
  });

  Widget build(BuildContext context, WidgetRef ref) {
    final recipeSteps = recipe.steps;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Text(
            "Cách làm :".tr(),
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
        ),
        const SizedBox(height: 20),

        if (recipeSteps.isEmpty)
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Text("Chưa có hướng dẫn các bước thực hiện."),
          )
        else
          ...recipeSteps.asMap().entries.map((entry) {
            int index = entry.key;
            String text = entry.value;
            return _StepItem(number: index + 1, text: text);
          }),

        const SizedBox(height: 20),

        // Nút Thực hiện món ăn
        Center(
          child: GestureDetector(
            onTap: () {
              // 1. Logic ánh xạ dữ liệu bao gồm cả thời gian nấu
              final List<run_model.RecipeStep> mappedSteps = recipe.steps.asMap().entries.map((entry) {
                int index = entry.key;

                // Kiểm tra kỹ mảng durations
                String durationStr = (recipe.durations.length > index)
                    ? recipe.durations[index]
                    : "0 phút";

                // Debug để kiểm tra chuỗi lấy được
                print("Step $index duration: $durationStr");

                int minutes = int.tryParse(durationStr.split(' ')[0]) ?? 0;
                int cookSeconds = minutes * 60;

                return run_model.RecipeStep(
                  title: "Bước ${index + 1}",
                  description: entry.value,
                  imagePath: (recipe.images.isNotEmpty) ? recipe.images[0] : "image/p1.png",
                  prepTime: 5,
                  cookingTime: cookSeconds,
                );
              }).toList();

              // 2. Cập nhật trạng thái (Chỉ gọi 1 lần duy nhất)
              ref.read(recipeStepsProvider.notifier).state = mappedSteps;
              ref.read(currentStepIndexProvider.notifier).state = 0;

              // 3. Điều hướng
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const RecipeRunScreen()),
              );
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 60, vertical: 20),
              decoration: BoxDecoration(
                color: const Color(0xFFFFD54F),
                borderRadius: BorderRadius.circular(32),
              ),
              child: Text(
                "Thực hiện món ăn".tr(),
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 20),
      ],
    );
  }
}

// Widget con hiển thị từng bước (đã đơn giản hóa để khớp với List<String>)
class _StepItem extends StatelessWidget {
  final int number;
  final String text;

  const _StepItem({
    required this.number,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 20, bottom: 28, right: 20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                '$number',
                style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
              ),
              const SizedBox(width: 8),
              Container(width: 3, height: 50, color: Colors.green),
            ],
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                fontSize: 16,
                color: Colors.black.withOpacity(0.75),
                height: 1.35,
              ),
            ),
          )
        ],
      ),
    );
  }
}