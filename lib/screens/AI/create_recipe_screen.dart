// lib/screens/create_recipe_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fontend/screens/AI/widgets/draft_recipe_item.dart';
import 'package:fontend/screens/AI/widgets/responsive_button_card.dart';
import '../../../../theme/theme_provider.dart'; // dark mode
import '../NewRecipes/add_recipe_screen.dart';
import 'logic/draft_provider.dart';

class CreateRecipeScreen extends ConsumerWidget {
  const CreateRecipeScreen({super.key});

  void _navigateToScreen(BuildContext context, Widget screen) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => screen),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final recipeDraftNotifier = ref.watch(recipeDraftProvider);
    final isDarkMode = ref.watch(themeProvider);

    final textColor = isDarkMode ? Colors.white : Colors.black;
    final subTextColor = isDarkMode ? Colors.grey[400]! : Colors.black;
    final draftTextColor = isDarkMode ? Colors.white : Colors.black;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: isDarkMode
          ? SystemUiOverlayStyle.light.copyWith(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
      )
          : SystemUiOverlayStyle.light.copyWith(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
      ),
      child: Scaffold(
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: MediaQuery.of(context).padding.top + 21.h),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 25.w),
              child: Text(
                'Thêm công thức mới',
                style: TextStyle(
                  color: textColor,
                  fontSize: 24.sp,
                  fontFamily: 'SF Pro',
                  fontWeight: FontWeight.w500,
                  height: 0.92,
                ),
              ),
            ),
            SizedBox(height: 42.h),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 25.w),
              child: Text.rich(
                TextSpan(
                  children: [
                    TextSpan(
                      text: 'Khám phá sự sáng tạo trong \n',
                      style: TextStyle(
                        color: textColor,
                        fontSize: 28.sp,
                        fontStyle: FontStyle.italic,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    TextSpan(
                      text: 'căn bếp của bạn',
                      style: TextStyle(
                        color: textColor,
                        fontSize: 28.sp,
                        fontStyle: FontStyle.italic,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 10.h),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 25.w),
              child: SizedBox(
                width: 356.w,
                child: Text(
                  'Đóng góp công thức nấu ăn của bạn vào cộng đồng Cookhub, với sự giúp đỡ từ trợ lý của chúng tôi. Ngay cả khi bạn không nhớ hết chi tiết, trợ lý của chúng tôi sẽ giúp bạn tạo công thức.',
                  style: TextStyle(
                    color: subTextColor,
                    fontSize: 15.sp,
                    fontFamily: 'SF Pro',
                    fontWeight: FontWeight.w500,
                    height: 1.47,
                  ),
                ),
              ),
            ),
            SizedBox(height: 30.h),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  ResponsiveButtonCard(
                    title: 'Tự tạo',
                    subtitle: 'Nhập thủ công',
                    onTap: () => _navigateToScreen(context, const AddRecipeScreen()),
                    titleColorLight: const Color(0xFF1F2937),
                    subtitleColorLight: const Color(0xFF9CA3AF),
                    backgroundColorLight: Colors.white,
                    titleColorDark: Colors.white,
                    subtitleColorDark: Colors.grey[300]!,
                    backgroundColorDark: const Color(0xFF2C2C2E),
                    icon: Icon(Icons.edit_note, size: 40.w, color: Colors.blueGrey),
                  ),
                  SizedBox(width: 10.w),
                  ResponsiveButtonCard(
                    title: 'Tạo với AI',
                    subtitle: 'Gợi ý thông minh',
                    onTap: () => _navigateToScreen(context, const AddRecipeScreen()),
                    titleColorLight: const Color(0xFF78350F),
                    subtitleColorLight: const Color(0xFF92400E),
                    backgroundColorLight: const Color(0xFFFEF3C7),
                    titleColorDark: Colors.white,
                    subtitleColorDark: Colors.grey[300]!,
                    backgroundColorDark: const Color(0xFFFFC836),
                    icon: Icon(Icons.auto_fix_high, size: 40.w, color: const Color(0xFFD97706)),
                  ),
                ],
              ),
            ),
            SizedBox(height: 30.h),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 25.w),
              child: Text(
                'Bản nháp gần đây',
                style: TextStyle(
                  color: textColor,
                  fontSize: 18.sp,
                  fontStyle: FontStyle.italic,
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 25.w),
                child: Consumer(
                  builder: (context, ref, child) {
                    final drafts = ref.watch(recipeDraftProvider);

                    if (drafts.isEmpty) {
                      return Center(
                        child: Text(
                          'Chưa có bản nháp nào',
                          style: TextStyle(fontSize: 16.sp, color: Colors.grey[600]),
                        ),
                      );
                    }

                    return ListView.builder(
                      padding: EdgeInsets.zero,
                      itemCount: drafts.length,
                      itemBuilder: (context, index) {
                        final draft = drafts[index];
                        return DraftRecipeItem(draft: draft);
                      },
                    );
                  },
                ),
              ),
            ),
            SizedBox(height: 20.h),
          ],
        ),
      ),
    );
  }
}
