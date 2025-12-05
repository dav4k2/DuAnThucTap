// lib/screens/survey/survey_flow_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../Service/user_service.dart';
import 'logic/survey_provider.dart';
import 'survey_1.dart';
import 'survey_2.dart';
import 'survey_3.dart';

final surveyPageProvider = StateProvider<int>((ref) => 0);

class SurveyFlowScreen extends ConsumerWidget {
  SurveyFlowScreen({super.key});

  final PageController _pageController = PageController();

  bool _canProceed(int currentPage, SurveyState survey) {
    switch (currentPage) {
      case 0:
        return survey.cookingTitle != null && survey.cookingTitle!.isNotEmpty;
      case 1:
        return survey.favoriteCategories.isNotEmpty;
      case 2:
        final name = survey.displayName?.trim();
        final country = survey.country?.trim();
        return name != null &&
            name.isNotEmpty &&
            country != null &&
            country.isNotEmpty;
      default:
        return true;
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentPage = ref.watch(surveyPageProvider);
    final survey = ref.watch(surveyProvider);
    final bool canProceed = _canProceed(currentPage, survey);

    return Scaffold(
      backgroundColor: Colors.white,
      body: ScreenUtilInit(
        designSize: const Size(402, 874),
        builder: (context, _) => Stack(
          children: [
            // PageView (không cho vuốt tay)
            PageView(
              controller: _pageController,
              physics: const NeverScrollableScrollPhysics(),
              children: const [
                Survey1(),
                Survey2(),
                Survey3(),
              ],
            ),

            // Nút Back + Thanh tiến độ + Text X/3
            Positioned(
              top: 60.h,
              left: 37.w,
              right: 80.w,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Nút Back
                  GestureDetector(
                    onTap: currentPage > 0
                        ? () {
                      _pageController.previousPage(
                        duration: const Duration(milliseconds: 600),
                        curve: Curves.easeInOut,
                      );
                      ref.read(surveyPageProvider.notifier).state =
                          currentPage - 1;
                    }
                        : null,
                    child: Opacity(
                      opacity: currentPage > 0 ? 1.0 : 0.5,
                      child: Row(
                        children: [
                          Icon(Icons.arrow_back_ios_new_rounded,
                              size: 24.sp, color: Colors.black),
                          SizedBox(width: 4.w),
                        ],
                      ),
                    ),
                  ),

                  SizedBox(width: 20.w),

                  // Thanh tiến độ ĐÃ SỬA – chạy đúng 33% → 66% → 100%
                  Expanded(
                    child: Stack(
                      children: [
                        // Nền xám
                        Container(
                          height: 5.h,
                          decoration: BoxDecoration(
                            color: const Color(0xFFDADADA),
                            borderRadius: BorderRadius.circular(60.r),
                          ),
                        ),
                        // Thanh vàng tiến độ (đẹp, chính xác, responsive)
                        AnimatedFractionallySizedBox(
                          duration: const Duration(milliseconds: 700),
                          curve: Curves.easeInOutCubic,
                          alignment: Alignment.centerLeft,
                          widthFactor: (currentPage + 1) / 3, // Đây là điểm quan trọng
                          child: Container(
                            height: 5.h,
                            decoration: BoxDecoration(
                              color: const Color(0xFFFFC735),
                              borderRadius: BorderRadius.circular(60.r),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Text 1/3, 2/3, 3/3
            Positioned(
              top: 63.h,
              right: 50.w,
              child: Text(
                '${currentPage + 1}/3',
                style: TextStyle(
                  fontSize: 12.sp,
                  color: Colors.black.withOpacity(0.6),
                  fontFamily: 'SF Pro',
                ),
              ),
            ),

            // Nút Tiếp theo / Hoàn thành
            Positioned(
              bottom: 30.h,
              left: 17.w,
              right: 17.w,
              child: GestureDetector(
                onTap: () async {
                  if (!canProceed) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        backgroundColor: Colors.redAccent,
                        content: Text(
                          currentPage == 0
                              ? "Vui lòng chọn trình độ nấu ăn của bạn"
                              : currentPage == 1
                              ? "Vui lòng chọn ít nhất 1 sở thích món ăn"
                              : "Vui lòng nhập tên và chọn quốc gia",
                          style: const TextStyle(fontFamily: 'SF Pro Rounded'),
                        ),
                        duration: const Duration(seconds: 2),
                      ),
                    );
                    return;
                  }

                  if (currentPage < 2) {
                    _pageController.nextPage(
                      duration: const Duration(milliseconds: 600),
                      curve: Curves.easeInOut,
                    );
                    ref.read(surveyPageProvider.notifier).state =
                        currentPage + 1;
                  } else {
                    showDialog(
                      context: context,
                      barrierDismissible: false,
                      builder: (c) => const Center(child: CircularProgressIndicator()),
                    );

                    // 2. Lấy data từ Provider
                    final survey = ref.read(surveyProvider);
                    final userService = UserService();

                    // 3. Gọi API
                    bool success = await userService.updateProfile(
                      displayName: survey.displayName!,
                      bio: survey.bio,
                      country: survey.country,
                      cookingLevel: survey.cookingTitle, // Từ Survey 1
                      categories: survey.favoriteCategories, // Từ Survey 2
                      avatarFile: survey.avatarFile, // Từ Survey 3
                      coverFile: survey.coverFile,   // Từ Survey 3
                    );

                    // 4. Ẩn loading
                    Navigator.of(context).pop();

                    if (success) {
                      // Chuyển sang trang Home/Profile
                      Navigator.pushReplacementNamed(context, '/mainlayout');
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Lỗi cập nhật hồ sơ. Vui lòng thử lại!")),
                      );
                    }
                  }
                },
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  width: double.infinity,
                  height: 65.h,
                  decoration: BoxDecoration(
                    color: canProceed
                        ? const Color(0xFFFFB901)
                        : Colors.grey.withOpacity(0.5),
                    borderRadius: BorderRadius.circular(30.r),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    currentPage == 2 ? "Hoàn thành" : "Tiếp theo",
                    style: TextStyle(
                      fontSize: 24.sp,
                      fontWeight: FontWeight.w700,
                      fontFamily: 'SF Pro Rounded',
                      color: canProceed ? Colors.black : Colors.white70,
                    ),
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