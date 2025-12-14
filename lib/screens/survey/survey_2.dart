// lib/screens/survey/survey_step2_screen.dart  ← FILE HOÀN CHỈNH
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fontend/screens/survey/survey_3.dart';
import 'package:fontend/screens/survey/widgets/SurveyCategoryChip.dart';
import 'package:fontend/screens/survey/widgets/survey_title_1.dart';

import 'logic/survey_provider.dart';
import 'widgets/survey_progress_bar.dart';
import 'widgets/survey_description.dart';
import 'widgets/start_button_text.dart';


class Survey2 extends ConsumerWidget { // Đổi thành ConsumerWidget
  const Survey2({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      // ... giữ nguyên decoration ...
      child: Stack(
        children: [
          const SurveyTitle1(text: 'Bạn quan tâm tới\nnhững công thức nào'),
          const SurveyDescription(text: 'Chọn một hoặc nhiều công thức...'),

          Positioned(
            top: 310.h, left: 30.w, right: 30.w,
            child: Wrap(
              spacing: 12.w,
              runSpacing: 12.h,
              children: ref.read(surveyProvider.notifier).categories.map((cat) {
                // Kiểm tra xem category này có đang được chọn không
                final isSelected = ref.watch(surveyProvider).favoriteCategories.contains(cat);

                return GestureDetector(
                  onTap: () => ref.read(surveyProvider.notifier).toggleCategory(cat),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
                    decoration: BoxDecoration(
                      color: isSelected ? const Color(0xFFFFB901) : Colors.grey[100],
                      borderRadius: BorderRadius.circular(20.r),
                    ),
                    child: Text(
                      cat,
                      style: TextStyle(
                        color: isSelected ? Colors.black : Colors.grey[600],
                        fontWeight: FontWeight.w600,
                        fontFamily: 'SF Pro Rounded',
                        fontSize: 15.sp,
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}