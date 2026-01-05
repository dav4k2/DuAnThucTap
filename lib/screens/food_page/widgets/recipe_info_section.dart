import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../Crete_recipe/logic/publish_recipe.dart';

class RecipeInfoSection extends StatelessWidget {
  final double width;
  final PublishRecipe recipe;

  const RecipeInfoSection({super.key, required this.width, required this.recipe});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    // Màu sắc theo theme
    final containerBg = isDark ? Colors.grey[850]! : Colors.white;
    final shadowColor = isDark ? Colors.black.withOpacity(0.4) : Colors.grey.withOpacity(0.3);
    final titleColor = isDark ? Colors.white : Colors.black87;
    final subtitleColor = isDark ? Colors.white70 : Colors.black54;
    final tagBgColor = const Color(0xFFFFC107); // Giữ vàng nổi bật
    final tagTextColor = isDark ? Colors.black87 : Colors.black87;
    final ratingBgColor = isDark ? Colors.grey[700]! : Colors.grey.shade200;

    return Transform.translate(
      offset: const Offset(0, -40),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: containerBg,
          borderRadius: BorderRadius.circular(30),
          boxShadow: [
            BoxShadow(
              color: shadowColor,
              spreadRadius: 1,
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          children: [
            // Header: tag - tên món - rating
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Công thức nổi bật tag
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: tagBgColor,
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.star,
                        color: Colors.white,
                        size: 14,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        "Công thức nổi bật".tr(),
                        style: TextStyle(
                          color: tagTextColor,
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 10),
                // Tên món ở giữa
                Expanded(
                  child: Text(
                    recipe.title.toUpperCase().tr(),
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: titleColor,
                    ),
                    textAlign: TextAlign.center,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                // Rating
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: ratingBgColor,
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        // Hiển thị điểm trung bình thực tế, mặc định 0.0 nếu chưa có
                        recipe.averageRating?.toStringAsFixed(1) ?? "0.0",
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: titleColor,
                        ),
                      ),
                      const SizedBox(width: 4),
                      const Icon(Icons.star, color: Color(0xFFFFC107), size: 18),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            // Số nguyên liệu
            Text(
              "${recipe.ingredients.length} nguyên liệu".tr(),
              style: TextStyle(
                fontSize: 14,
                color: subtitleColor,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            // Thông tin thời gian, độ khó, số người
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _InfoItem(
                  icon: Icons.access_time,
                  label: recipe.cookingTime ?? "30 phút",
                  color: const Color(0xFF00D242),
                  textColor: isDark ? Colors.white : null,
                ),
                _InfoItem(
                  icon: Icons.emoji_emotions,
                  label: "Dễ",
                  color: const Color(0xFF00D242),
                  textColor: isDark ? Colors.white : null,
                ),
                _InfoItem(
                  icon: Icons.person,
                  label: "2 người",
                  color: const Color(0xFF33ADBB),
                  textColor: isDark ? Colors.white : null,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _InfoItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final Color? textColor; // Cho phép override màu chữ ở dark mode

  const _InfoItem({
    required this.icon,
    required this.label,
    required this.color,
    this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final displayTextColor = textColor ?? (isDark ? Colors.white : color);

    return Row(
      children: [
        Text(
          label,
          style: TextStyle(
            color: displayTextColor,
            fontSize: 15,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(width: 6),
        Container(
          padding: const EdgeInsets.all(7),
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
          child: Icon(
            icon,
            color: Colors.white,
            size: 18,
          ),
        ),
      ],
    );
  }
}