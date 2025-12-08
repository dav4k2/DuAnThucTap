// lib/screens/chat/widgets/recipe_preview_card.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class RecipePreviewCard extends StatelessWidget {
  final Map<String, dynamic> data;
  final bool isDark;
  final Function(Map<String, dynamic>) onCookNow;
  final VoidCallback onRequestAnother;

  const RecipePreviewCard({
    Key? key,
    required this.data,
    required this.isDark,
    required this.onCookNow,
    required this.onRequestAnother,
  }) : super(key: key);

  Widget _buildIconText(IconData icon, String? text, Color? color) {
    if (text == null || text.isEmpty) return const SizedBox.shrink();
    return Row(children: [
      Icon(icon, size: 16.sp, color: color),
      SizedBox(width: 4.w),
      Text(text, style: TextStyle(fontSize: 13.sp, color: color))
    ]);
  }

  @override
  Widget build(BuildContext context) {
    final cardBg = isDark ? const Color(0xFF1E1E1E) : Colors.white;
    final borderColor = isDark ? Colors.grey[700]! : Colors.grey[300]!;
    final textColor = isDark ? Colors.white : Colors.black87;
    final subColor = isDark ? Colors.grey[400] : Colors.grey[600];

    return Container(
      width: 0.9.sw,
      margin: EdgeInsets.only(top: 4.h, bottom: 16.h),
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: cardBg,
        border: Border.all(color: borderColor),
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 4))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(data['title'] ?? 'Món ăn', style: TextStyle(fontSize: 19.sp, fontWeight: FontWeight.bold, color: textColor)),
          SizedBox(height: 12.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildIconText(Icons.timer_outlined, data['cookingTime'], subColor),
              _buildIconText(Icons.people_outline, data['servings'], subColor),
              _buildIconText(Icons.bar_chart_rounded, data['difficulty'], subColor),
            ],
          ),
          Divider(height: 24.h, color: borderColor),
          Text("Mô tả món ăn:", style: TextStyle(fontWeight: FontWeight.w600, color: textColor, fontSize: 14.sp)),
          SizedBox(height: 6.h),
          Text(data['description'] ?? '', style: TextStyle(fontSize: 15.sp, color: subColor, height: 1.5)),
          SizedBox(height: 20.h),
          Row(
            children: [
              Expanded(
                child: SizedBox(
                  height: 44.h,
                  child: OutlinedButton(
                    onPressed: onRequestAnother,
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(color: isDark ? Colors.white54 : Colors.grey),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                    child: Text("Đổi món khác", style: TextStyle(color: textColor, fontWeight: FontWeight.w500)),
                  ),
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: SizedBox(
                  height: 44.h,
                  child: ElevatedButton(
                    onPressed: () => onCookNow(data),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFFFB901),
                      foregroundColor: Colors.black,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                    child: const Text("Nấu ngay", style: TextStyle(fontWeight: FontWeight.bold)),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}