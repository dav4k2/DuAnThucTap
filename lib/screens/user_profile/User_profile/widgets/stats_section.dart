import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class StatsSection extends StatelessWidget {
  final int recipes;
  final String followers;
  final int following;

  const StatsSection({
    super.key,
    required this.recipes,
    required this.followers,
    required this.following,
  });

  @override
  Widget build(BuildContext context) {
    // LẤY MÀU TỪ THEME
    final textColor = Theme.of(context).textTheme.bodyMedium?.color ?? Colors.black;
    final secondaryColor = textColor.withOpacity(0.6);
    final dividerColor = textColor.withOpacity(0.15);

    return Container(
      // Dùng margin hoặc padding thay vì Positioned top nếu có thể
      margin: EdgeInsets.only(top: 370.h),
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildStatItem('$recipes', 'Số công thức', textColor, secondaryColor),
          _buildDivider(dividerColor),
          _buildStatItem(followers, 'Follower', textColor, secondaryColor),
          _buildDivider(dividerColor),
          _buildStatItem('$following', 'Đã follow', textColor, secondaryColor),
        ],
      ),
    );
  }

  // Widget con để hiển thị từng cột chỉ số
  Widget _buildStatItem(String value, String label, Color textColor, Color secondaryColor) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          value,
          style: TextStyle(
            fontSize: 24.sp, // Giảm nhẹ sp để fit với designSize 402
            fontWeight: FontWeight.w600,
            color: textColor,
          ),
        ),
        SizedBox(height: 4.h),
        Text(
          label,
          style: TextStyle(
            color: secondaryColor,
            fontSize: 14.sp,
          ),
        ),
      ],
    );
  }

  // Widget vạch ngăn dọc chuyên nghiệp hơn Transform.rotate
  Widget _buildDivider(Color color) {
    return Container(
      height: 30.h,
      width: 1.w,
      color: color,
    );
  }
}