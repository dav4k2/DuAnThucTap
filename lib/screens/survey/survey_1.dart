// lib/screens/survey/survey_step1_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fontend/screens/survey/survey_2.dart';
import 'package:fontend/screens/survey/widgets/survey_title_1.dart';
import 'widgets/survey_progress_bar.dart';
import 'widgets/survey_description.dart';
import 'widgets/survey_option_item.dart';
import 'widgets/start_button_text.dart';

class Survey1 extends StatelessWidget {
  const Survey1({super.key});

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


          const SurveyTitle1(text: 'Trình độ nấu ăn của \nbạn thế nào ?'),

          const SurveyDescription(
            text: 'Chúng tôi sẽ đề xuất công thức nấu ăn dựa theo trình độ của bạn.',
          ),

          // ===== DANH SÁCH LỰA CHỌN =====
          Positioned(
            top: 317.h,
            left: 41.w,
            child: Consumer(
              builder: (context, ref, child) {
                return Column(
                  children: const [
                    SurveyOptionItem(text: "Mới tập nấu"),
                    SurveyOptionItem(text: "Nghiệp dư"),
                    SurveyOptionItem(text: "Đầu bếp tại gia"),
                    SurveyOptionItem(text: "Đầu bếp chuyên nghiệp"),
                    SurveyOptionItem(text: "Không chắc chắn"),
                  ],
                );
              },
            ),
          ),



        ],
      ),
    );
  }
}