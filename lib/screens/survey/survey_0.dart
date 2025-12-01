// lib/screens/survey/survey_0.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'widgets/survey_title.dart';
import 'widgets/survey_image.dart';
import 'widgets/start_button_text.dart';
import 'survey_flow_screen.dart'; // Đây là trang flow có 3 bước + thanh tiến độ

class SurveyStartScreen extends StatelessWidget {
  const SurveyStartScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(402, 874),
      builder: (context, child) => Container(
        width: 402.w,
        height: 874.h,
        decoration: const ShapeDecoration(
          color: Colors.white,
          shape: RoundedRectangleBorder(),
        ),
        child: Stack(
          children: [
            // Tiêu đề lớn ở trên
            const SurveyTitle(),

            // Hình ảnh chính giữa
            const SurveyImage(),

            // Nút "Bắt đầu ngay" ở dưới cùng
            Positioned(
              bottom: 80.h, // Cách đáy vừa đẹp
              left: 17.w,
              right: 17.w,
              child: GestureDetector(
                onTap: () {
                  // Chuyển sang trang Survey Flow (có thanh tiến độ 3 bước)
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => SurveyFlowScreen(),
                    ),
                  );
                },
                child: StartButtonText(
                  text: "Bắt đầu ngay",
                  width: 368, // Giống nút "Tiếp theo" trong flow
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}