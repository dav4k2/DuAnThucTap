// lib/widgets/my_bio_tab.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../theme/theme_provider.dart'; // thêm import theme
import '../logic/my_profile_provider.dart';

class MyBioTab extends ConsumerWidget {
  const MyBioTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final chef = ref.watch(myChefProvider);
    final isDarkMode = ref.watch(themeProvider);

    // Màu nền & chữ theo light/dark mode
    final bgColor = isDarkMode ? const Color(0xFF1F1F1F) : Colors.white;
    final textColor = isDarkMode ? Colors.white : Colors.black;
    final subTextColor = isDarkMode ? Colors.white.withOpacity(0.8) : Colors.black.withOpacity(0.8);

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionTitle('Giới thiệu', textColor),
          SizedBox(height: 8.h),
          _buildExpandableBio(chef.bio ?? _defaultBio, subTextColor),
          SizedBox(height: 24.h),

          _buildSectionTitle('Liên hệ', textColor),
          SizedBox(height: 8.h),
          _buildContactInfo(chef.email ?? 'kongfuongchef@gmail.com', subTextColor),
          SizedBox(height: 16.h),

          _buildJoinedDate(chef.joinedDate ?? '10/09/2024', subTextColor),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title, Color color) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 16.sp,
        fontWeight: FontWeight.w400,
        color: color,
        height: 1.31,
      ),
    );
  }

  Widget _buildExpandableBio(String fullText, Color color) {
    const int maxLines = 3;
    const String viewMore = 'Xem thêm';

    return LayoutBuilder(
      builder: (context, constraints) {
        final span = TextSpan(
          text: fullText,
          style: TextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.w300,
            color: color,
            height: 1.31,
          ),
        );
        final tp = TextPainter(
          text: span,
          maxLines: maxLines,
          textDirection: TextDirection.ltr,
        );
        tp.layout(maxWidth: constraints.maxWidth);

        if (tp.didExceedMaxLines) {
          return Text.rich(
            TextSpan(
              children: [
                TextSpan(
                  text: fullText,
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w300,
                    color: color,
                    height: 1.31,
                  ),
                ),
                TextSpan(
                  text: ' $viewMore',
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w300,
                    color: const Color(0xFFFFB901), // vàng nổi bật
                    height: 1.31,
                  ),
                ),
              ],
            ),
            maxLines: maxLines,
            overflow: TextOverflow.ellipsis,
          );
        }

        return Text(
          fullText,
          style: TextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.w300,
            color: color,
            height: 1.31,
          ),
        );
      },
    );
  }

  Widget _buildContactInfo(String email, Color color) {
    return Text(
      'Email: $email',
      style: TextStyle(
        fontSize: 15.sp,
        fontWeight: FontWeight.w300,
        color: color,
        height: 1.40,
      ),
    );
  }

  Widget _buildJoinedDate(String date, Color color) {
    return Text(
      'Đã tham gia vào $date',
      style: TextStyle(
        fontSize: 13.sp,
        fontWeight: FontWeight.w300,
        color: color,
        height: 1.62,
      ),
    );
  }

  static const String _defaultBio =
      "Một đầu bếp xuất thân từ đường phố, không trải qua đào tạo bài bản, chỉ có niềm tin vào câu nói “Ai cũng có thể nấu” của Auguste Gusteau. Tôi đã thành công và thậm chí còn khiến cho Arsene Wenger phải khen món ăn của mình.";
}
