import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:fontend/screens/Crete_recipe/logic/publish_recipe.dart';

class DescriptionSection extends StatelessWidget {
  final double width;
  final PublishRecipe recipe;

  const DescriptionSection({super.key, required this.width, required this.recipe});

  @override
  Widget build(BuildContext context) {
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
                      color: Colors.black.withOpacity(0.6),
                      fontSize: 14,
                      height: 1.6),
                ),
                if (recipe.description.length > 100)
                  TextSpan(
                    text: " Xem thêm".tr(),
                    style: const TextStyle(
                        color: Colors.black,
                        fontSize: 14,
                        fontWeight: FontWeight.bold),
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
              children: recipeTags.map((tag) => _buildTagItem(tag)).toList(),
            ),
          ],
        ],
      ),
    );
  }

  // Widget tạo từng ô tag
  Widget _buildTagItem(String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(25), // Độ bo tròn lớn tạo hình viên thuốc
        border: Border.all(
          color: Colors.grey.shade300, // Màu viền xám nhạt
          width: 1,
        ),
      ),
      child: Text(
        label.tr(), // Dùng tr() để hỗ trợ đa ngôn ngữ nếu cần
        style: const TextStyle(
          color: Color(0xFF4A5568), // Màu chữ xanh xám đậm
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}