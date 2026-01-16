import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../Crete_recipe/logic/publish_recipe.dart';

class IngredientsSection2 extends StatelessWidget {
  final PublishRecipe recipe;
  final double width;

  const IngredientsSection2({super.key, required this.width, required this.recipe});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    // Màu sắc theo theme
    final titleColor = isDark ? Colors.white : Colors.black;
    final textColor = isDark ? Colors.white70 : Colors.black87;
    final dotColor = const Color(0xFFFFB901); // Giữ nguyên màu vàng nổi bật

    final ingredients = recipe.ingredients;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Text(
            "Nguyên liệu:".tr(),
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: titleColor,
            ),
          ),
        ),
        const SizedBox(height: 8),
        ...ingredients.map((item) => Padding(
          padding: const EdgeInsets.only(left: 20, bottom: 8),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 8,
                height: 8,
                margin: const EdgeInsets.only(top: 6), // Căn chỉnh đẹp hơn với text
                decoration: BoxDecoration(
                  color: dotColor,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  item,
                  style: TextStyle(
                    fontSize: 16,
                    color: textColor,
                    height: 1.4, // Tăng khoảng cách dòng cho dễ đọc
                  ),
                ),
              ),
            ],
          ),
        )),
      ],
    );
  }
}