import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:fontend/screens/Cooking_step/recipe_run_screen.dart';
import '../../Cooking_step/recipe_run_provider.dart';
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

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    // Màu sắc theo theme
    final titleColor = isDark ? Colors.white : Colors.black;
    final stepNumberColor = isDark ? Colors.white : Colors.black;
    final stepLineColor = isDark ? Colors.green[600]! : Colors.green;
    final stepTextColor = isDark ? Colors.white70 : Colors.black.withOpacity(0.75);
    final emptyTextColor = isDark ? Colors.white60 : Colors.black54;
    final buttonBgColor = isDark ? const Color(0xFFFFD54F).withOpacity(0.9) : const Color(0xFFFFD54F);
    final buttonTextColor = Colors.black;

    final recipeSteps = recipe.steps;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Text(
            "Cách làm :".tr(),
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: titleColor,
            ),
          ),
        ),
        const SizedBox(height: 20),

        if (recipeSteps.isEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Text(
              "Chưa có hướng dẫn các bước thực hiện.",
              style: TextStyle(
                fontSize: 16,
                color: emptyTextColor,
              ),
            ),
          )
        else
          ...recipeSteps.asMap().entries.map((entry) {
            int index = entry.key;
            String text = entry.value;
            String? imageUrl;
            // Kiểm tra xem có ảnh tại index này không
            if (recipe.stepImages.isNotEmpty &&
                index < recipe.stepImages.length &&
                recipe.stepImages[index].isNotEmpty) {
              imageUrl = recipe.stepImages[index];
            }

            return _StepItem(
              number: index + 1,
              text: text,
              imageUrl: imageUrl,
              numberColor: stepNumberColor,
              lineColor: stepLineColor,
              textColor: stepTextColor,
            );
          }),

        const SizedBox(height: 20),

        // Nút Thực hiện món ăn
        Center(
          child: GestureDetector(
            onTap: () {
              // 1. Logic ánh xạ dữ liệu
              final List<run_model.RecipeStep> mappedSteps = recipe.steps.asMap().entries.map((entry) {
                int index = entry.key;
                String content = entry.value;

                String durationStr = (recipe.durations.length > index)
                    ? recipe.durations[index]
                    : "0 phút";

                int minutes = int.tryParse(durationStr.split(' ')[0]) ?? 0;
                int cookSeconds = minutes * 60;

                String stepImage = "image/p1.png"; // Ảnh mặc định

                // Kiểm tra xem mảng stepImages có dữ liệu tại index này không
                if (recipe.stepImages.isNotEmpty &&
                    index < recipe.stepImages.length &&
                    recipe.stepImages[index].isNotEmpty) {
                  stepImage = recipe.stepImages[index]; // Lấy URL ảnh thật
                }
                // ------------------------------------------

                return run_model.RecipeStep(
                  title: "Bước ${index + 1}",
                  description: content,
                  imagePath: stepImage, // Truyền ảnh thật vào đây
                  prepTime: 5,
                  cookingTime: cookSeconds,
                );
              }).toList();

              // 2. Cập nhật provider (Giữ nguyên)
              ref.read(recipeStepsProvider.notifier).state = mappedSteps;
              ref.read(currentStepIndexProvider.notifier).state = 0;

              // 3. Điều hướng (Giữ nguyên)
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const RecipeRunScreen()),
              );
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 60, vertical: 20),
              decoration: BoxDecoration(
                color: buttonBgColor,
                borderRadius: BorderRadius.circular(32),
                
              ),
              child: Text(
                "Thực hiện món ăn".tr(),
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: buttonTextColor,
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

// Widget con hiển thị từng bước
class _StepItem extends StatelessWidget {
  final int number;
  final String text;
  final String? imageUrl;
  final Color numberColor;
  final Color lineColor;
  final Color textColor;

  const _StepItem({
    required this.number,
    required this.text,
    this.imageUrl,
    required this.numberColor,
    required this.lineColor,
    required this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 20, bottom: 28, right: 20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Cột bên trái: Số và đường kẻ
          Column(
            children: [
              Text(
                '$number',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: numberColor,
                ),
              ),
              const SizedBox(height: 4),
              Container(width: 3, height: 60, color: lineColor),
            ],
          ),
          const SizedBox(width: 16),

          // Cột bên phải: Text mô tả + Ảnh
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  text,
                  style: TextStyle(
                    fontSize: 16,
                    color: textColor,
                    height: 1.35,
                  ),
                ),
                // Nếu có ảnh thì hiển thị bên dưới text
                if (imageUrl != null && imageUrl!.isNotEmpty) ...[
                  const SizedBox(height: 12),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.network(
                      imageUrl!,
                      //width: 250,
                      height: 100,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          height: 150,
                          width: double.infinity,
                          color: Colors.grey[200],
                          child: const Icon(Icons.image_not_supported, color: Colors.grey),
                        );
                      },
                      loadingBuilder: (context, child, loadingProgress) {
                        if (loadingProgress == null) return child;
                        return Container(
                          height: 200,
                          width: double.infinity,
                          color: Colors.grey.withOpacity(0.1),
                          child: const Center(child: CircularProgressIndicator()),
                        );
                      },
                    ),
                  ),
                ],
              ],
            ),
          )
        ],
      ),
    );
  }
}