import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:fontend/screens/Crete_recipe/logic/publish_recipe.dart';

class DescriptionSection extends StatelessWidget {
  final double width;
  final PublishRecipe recipe; // ✅ Nhận dữ liệu thực tế

  const DescriptionSection({super.key, required this.width, required this.recipe});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Text.rich(
        TextSpan(
          children: [
            TextSpan(
              // ✅ Hiển thị mô tả từ Firebase
              text: recipe.description.isNotEmpty
                  ? recipe.description
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
    );
  }
}