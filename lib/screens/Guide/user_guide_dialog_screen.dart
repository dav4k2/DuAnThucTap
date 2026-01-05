// lib/features/user_guide/user_guide_dialog.dart
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'model/guide_model.dart';
import 'logic/guide_provider.dart';
import 'widgets/guide_widgets.dart';

class UserGuideDialog extends ConsumerStatefulWidget {
  final List<GuideStep> steps;

  const UserGuideDialog({Key? key, required this.steps}) : super(key: key);

  @override
  ConsumerState<UserGuideDialog> createState() => _UserGuideDialogState();
}

class _UserGuideDialogState extends ConsumerState<UserGuideDialog> {
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();

    // Reset index về 0 khi mở dialog để đảm bảo đồng bộ
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(guideProvider.notifier).setIndex(0);
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  // Xử lý nút Next
  void _handleNext(int currentIndex) {
    if (currentIndex < widget.steps.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      Navigator.of(context).pop();
    }
  }

  // Xử lý nút Back
  void _handleBack() {
    if (_pageController.page != null && _pageController.page! > 0) {
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    // LƯU Ý QUAN TRỌNG: Không watch currentIndex ở đây nữa để tránh rebuild toàn bộ Dialog
    // final currentIndex = ref.watch(guideProvider); -> Đã xóa dòng này

    final bgColor = isDark ? const Color(0xFF1E1E1E) : Colors.white;
    final textColor = isDark ? Colors.white : Colors.black87;

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Container(
        width: double.infinity,
        height: 720.h,
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(24.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.25),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Column(
          children: [
            // --- Header: Nút đóng ---
            Align(
              alignment: Alignment.centerRight,
              child: Padding(
                padding: EdgeInsets.only(top: 8.h, right: 8.w),
                child: IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: Icon(Icons.close, color: Colors.grey, size: 28.sp),
                ),
              ),
            ),

            // --- Body: Slide nội dung ---
            // PageView nằm ngoài Consumer của Footer nên nó KHÔNG bị rebuild khi lướt -> Fix lỗi buffer
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                itemCount: widget.steps.length,
                onPageChanged: (index) {
                  // Chỉ update state, không gây rebuild widget cha vì ta đã bỏ ref.watch ở trên
                  ref.read(guideProvider.notifier).setIndex(index);
                },
                itemBuilder: (context, index) {
                  final step = widget.steps[index];
                  return Padding(
                    padding: EdgeInsets.symmetric(horizontal: 24.w),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Widget Ảnh/Video
                        GuideMediaBox(
                          index: index,
                          path: step.mediaPath,
                          type: step.mediaType,
                          isDark: isDark,
                        ),

                        SizedBox(height: 30.h),

                        // Tiêu đề
                        Text(
                          step.title,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 24.sp,
                            fontWeight: FontWeight.bold,
                            color: textColor,
                          ),
                        ),

                        SizedBox(height: 12.h),

                        // Nội dung text
                        Text(
                          step.content,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 16.sp,
                            color: textColor.withOpacity(0.7),
                            height: 1.5,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),

            // --- Footer: Back - Dots - Next ---
            // Bọc riêng phần này trong Consumer để chỉ rebuild các nút bấm/dots
            Consumer(
              builder: (context, ref, child) {
                // Chỉ watch ở phạm vi nhỏ này
                final currentIndex = ref.watch(guideProvider);

                return Padding(
                  padding: EdgeInsets.fromLTRB(16.w, 0, 16.w, 32.h),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // 1. Nút Back (Bên trái)
                      Expanded(
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: currentIndex > 0
                              ? FittedBox(
                            fit: BoxFit.scaleDown,
                            child: TextButton.icon(
                              onPressed: _handleBack,
                              style: TextButton.styleFrom(
                                padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 8.h),
                                foregroundColor: isDark ? Colors.white70 : Colors.grey[700],
                                minimumSize: Size.zero,
                                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                              ),
                              icon: Icon(Icons.arrow_back_ios_rounded, size: 16.sp),
                              label: Text("Trước".tr(), style: TextStyle(fontSize: 14.sp)),
                            ),
                          )
                              : const SizedBox.shrink(),
                        ),
                      ),

                      // 2. Dots (Ở giữa)
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 8.w),
                        child: GuidePageIndicator(
                          count: widget.steps.length,
                          currentIndex: currentIndex,
                          isDark: isDark,
                        ),
                      ),

                      // 3. Nút Next (Bên phải)
                      Expanded(
                        child: Align(
                          alignment: Alignment.centerRight,
                          child: FittedBox(
                            fit: BoxFit.scaleDown,
                            child: GuideActionButton(
                              isLastPage: currentIndex == widget.steps.length - 1,
                              onPressed: () => _handleNext(currentIndex),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}