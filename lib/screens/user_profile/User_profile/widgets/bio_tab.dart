// lib/widgets/bio_tab.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../logic/chef_provider.dart';

class BioTab extends ConsumerWidget {
  final String? bioText;
  final String? email;
  final String? joinedDate;

  const BioTab({super.key, this.bioText, this.email, this.joinedDate});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final chef = ref.watch(chefProvider);

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionTitle('Giới thiệu'),
          SizedBox(height: 8.h),
          // 2. Sử dụng bioText truyền vào, nếu null thì mới dùng provider hoặc mặc định
          _buildExpandableBio(bioText ?? chef.bio ?? _defaultBio),
          SizedBox(height: 24.h),

          _buildSectionTitle('Liên hệ'),
          SizedBox(height: 8.h),
          // 3. Sử dụng email truyền vào
          _buildContactInfo(email ?? chef.email ?? 'chưa cập nhật'),
          SizedBox(height: 16.h),

          // 4. Sử dụng joinedDate truyền vào
          _buildJoinedDate(joinedDate ?? chef.joinedDate ?? 'chưa rõ'),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 16.sp,
        fontWeight: FontWeight.w400,
        color: Colors.black,
        height: 1.31,
      ),
    );
  }

  Widget _buildExpandableBio(String fullText) {
    const int maxLines = 3;
    const String viewMore = 'Xem thêm';

    return LayoutBuilder(
      builder: (context, constraints) {
        final span = TextSpan(
          text: fullText,
          style: TextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.w300,
            color: Colors.black.withOpacity(0.8),
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
                    color: Colors.black.withOpacity(0.8),
                    height: 1.31,
                  ),
                ),
                TextSpan(
                  text: ' $viewMore',
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w300,
                    color: const Color(0xFFFFB901),
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
            color: Colors.black.withOpacity(0.8),
            height: 1.31,
          ),
        );
      },
    );
  }

  Widget _buildContactInfo(String email) {
    return Text(
      'Email: $email',
      style: TextStyle(
        fontSize: 15.sp,
        fontWeight: FontWeight.w300,
        color: Colors.black.withOpacity(0.8),
        height: 1.40,
      ),
    );
  }

  Widget _buildJoinedDate(String date) {
    return Text(
      'Đã tham gia vào $date',
      style: TextStyle(
        fontSize: 13.sp,
        fontWeight: FontWeight.w300,
        color: Colors.black.withOpacity(0.8),
        height: 1.62,
      ),
    );
  }

  static const String _defaultBio =
      "Một đầu bếp xuất thân từ đường phố, không trải qua đào tạo bài bản, chỉ có niềm tin vào câu nói “Ai cũng có thể nấu” của Auguste Gusteau. Tôi đã thành công và thậm chí còn khiến cho Arsene Wenger phải khen món ăn của mình.";
}