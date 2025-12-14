// lib/screens/survey/survey_step1_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'widgets/survey_title_1.dart';
import 'widgets/survey_description.dart';
import 'logic/survey_provider.dart'; // Import Provider

class Survey1 extends ConsumerWidget { // Đổi thành ConsumerWidget
  const Survey1({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Lấy giá trị đang được chọn để highlight (nếu muốn)
    final selectedTitle = ref.watch(surveyProvider).cookingTitle;

    return Container(
      width: 402.w, height: 874.h, color: Colors.white,
      child: Stack(
        children: [
          const SurveyTitle1(text: 'Trình độ nấu ăn của \nbạn thế nào ?'),
          const SurveyDescription(text: 'Chúng tôi sẽ đề xuất công thức nấu ăn dựa theo trình độ của bạn.'),

          Positioned(
            top: 317.h, left: 41.w, right: 41.w,
            child: Column(
              children: [
                _buildOption(ref, "Mới tập nấu", selectedTitle),
                _buildOption(ref, "Nghiệp dư", selectedTitle),
                _buildOption(ref, "Đầu bếp tại gia", selectedTitle),
                _buildOption(ref, "Đầu bếp chuyên nghiệp", selectedTitle),
                _buildOption(ref, "Không chắc chắn", selectedTitle),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Widget con để xử lý chọn
  Widget _buildOption(WidgetRef ref, String title, String? currentSelected) {
    final isSelected = title == currentSelected;
    return GestureDetector(
      onTap: () {
        ref.read(surveyProvider.notifier).setCookingTitle(title);
      },
      child: Container(
        margin: EdgeInsets.only(bottom: 15.h),
        padding: EdgeInsets.symmetric(vertical: 15.h, horizontal: 20.w),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFFFB901).withOpacity(0.2) : Colors.white,
          border: Border.all(color: isSelected ? const Color(0xFFFFB901) : Colors.grey.shade300),
          borderRadius: BorderRadius.circular(30.r),
        ),
        child: Row(
          children: [
            Text(
              title,
              style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                  fontFamily: 'SF Pro Rounded'
              ),
            ),
            const Spacer(),
            if (isSelected)
              Icon(Icons.check_circle, color: const Color(0xFFFFB901), size: 20.sp)
          ],
        ),
      ),
    );
  }
}