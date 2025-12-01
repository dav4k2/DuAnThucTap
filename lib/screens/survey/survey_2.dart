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


class Survey2 extends StatelessWidget {
  const Survey2({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 402.w,
      height: 874.h,
      clipBehavior: Clip.antiAlias,
      decoration: ShapeDecoration(
        color: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(0.r)),
      ),
      child: Stack(
        children: [
          // Thanh tiến độ


          // Tiêu đề + mô tả
          const SurveyTitle1(text: 'Bạn quan tâm tới\nnhững công thức nào'),
          const SurveyDescription(
            text:
            'Chọn một hoặc nhiều công thức bạn quan tâm\nđể nhận được các đề xuất món ăn phù hợp\nvới bạn',
          ),

          // ===== 3 CHIP 1 DÒNG – TỰ ĐỘNG, ĐẸP LUNG LINH =====
          Positioned(
            top: 310.h,
            left: 30.w,
            right: 30.w,
            child: Consumer(
              builder: (context, ref, child) {
                final categories = ref.watch(surveyCategoriesProvider);

                return Wrap(
                  spacing: 18.w,
                  runSpacing: 18.h,
                  children: categories
                      .map((cat) => SurveyCategoryChip(label: cat))
                      .toList(),
                );
              },
            ),
          ),


        ],
      ),
    );
  }
}