import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:fontend/screens/Crete_recipe/logic/publish_recipe.dart';

class DescriptionSection extends StatelessWidget {
  final double width;
  final PublishRecipe recipe;

  const DescriptionSection({super.key, required this.width, required this.recipe});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    // Màu sắc theo theme
    final descriptionColor = isDark ? Colors.white.withOpacity(0.7) : Colors.black.withOpacity(0.6);
    final moreTextColor = isDark ? Colors.white : Colors.black;
    final tagBackgroundColor = isDark ? Colors.grey[800]! : Colors.white;
    final tagBorderColor = isDark ? Colors.grey[700]! : Colors.grey.shade300;
    final tagTextColor = isDark ? Colors.white70 : const Color(0xFF4A5568);

    final List<String> recipeTags = recipe.tags;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // --- PHẦN MÔ TẢ ---
          Text.rich(
            TextSpan(
              children: [
                TextSpan(
                  text: recipe.description.isNotEmpty
                      ? (recipe.description.length > 100
                      ? "${recipe.description.substring(0, 100)}..."
                      : recipe.description)
                      : "Chưa có mô tả cho món ăn này.".tr(),
                  style: TextStyle(
                    color: descriptionColor,
                    fontSize: 14,
                    height: 1.6,
                  ),
                ),
                if (recipe.description.length > 100)
                  TextSpan(
                    text: " Xem thêm".tr(),
                    style: TextStyle(
                      color: moreTextColor,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          if (recipeTags.isNotEmpty) ...[
            const SizedBox(height: 16),

            Wrap(
              spacing: 8.0,
              runSpacing: 8.0,
              children: recipeTags.map((tag) => _buildTagItem(tag, tagBackgroundColor, tagBorderColor, tagTextColor)).toList(),
            ),
          ],
        ],
      ),
    );
  }

  // Widget tạo từng ô tag
  Widget _buildTagItem(String label, Color backgroundColor, Color borderColor, Color textColor) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(25),
        border: Border.all(
          color: borderColor,
          width: 1,
        ),
      ),
      child: Text(
        label.tr(),
        style: TextStyle(
          color: textColor,
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}