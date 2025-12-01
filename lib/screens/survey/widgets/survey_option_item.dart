// lib/screens/survey/widgets/survey_option_item.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../logic/survey_provider.dart';

class SurveyOptionItem extends ConsumerWidget {
  final String text;

  const SurveyOptionItem({
    super.key,
    required this.text,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedTitle = ref.watch(surveyProvider).cookingTitle;
    final isSelected = selectedTitle == text;

    return GestureDetector(
      onTap: () {
        ref.read(surveyProvider.notifier).setCookingTitle(text);
      },
      child: Container(
        width: 320.w,
        height: 43.h,
        margin: EdgeInsets.only(bottom: 16.h),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15.r),
          border: Border.all(
            color: isSelected ? const Color(0xFFFFB901) : Colors.grey.withOpacity(0.3),
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.25),
              blurRadius: 4,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Stack(
          children: [
            // Vòng ngoài
            Positioned(
              left: 10.w,
              top: 7.h,
              child: Container(
                width: 29.w,
                height: 29.h,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: isSelected ? const Color(0xFFFFB901) : Colors.grey.withOpacity(0.3),
                    width: 1,
                  ),
                ),
              ),
            ),
            // Vòng trong khi chọn
            if (isSelected)
              Positioned(
                left: 15.w,
                top: 12.h,
                child: Container(
                  width: 19.w,
                  height: 19.h,
                  decoration: const BoxDecoration(
                    color: Color(0xFFFFB901),
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            // Text
            Positioned(
              left: 55.w,
              top: 0,
              bottom: 0,
              child: Center(
                child: Text(
                  text,
                  style: TextStyle(
                    color: isSelected ? const Color(0xFFFFB901) : Colors.black,
                    fontSize: 20.sp,
                    fontFamily: 'SF Pro Rounded',
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}