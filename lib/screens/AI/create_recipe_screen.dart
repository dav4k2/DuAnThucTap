// lib/screens/create_recipe_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fontend/screens/AI/widgets/draft_recipe_item.dart';
import 'package:fontend/screens/AI/widgets/responsive_button_card.dart';
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

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light.copyWith(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
      ),
      child: Scaffold(
        backgroundColor: const Color(0xFFF9FAFB),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: MediaQuery.of(context).padding.top + 21.h),

            Padding(
              padding: EdgeInsets.symmetric(horizontal: 25.w),
              child: Text(
                'Thêm công thức mới',
                style: TextStyle(
                  color: Colors.black,
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
                        color: Colors.black,
                        fontSize: 28.sp,
                        fontStyle: FontStyle.italic,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    TextSpan(
                      text: 'căn bếp của bạn',
                      style: TextStyle(
                        color: Colors.black,
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
                    color: Colors.black,
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
                    titleColor: const Color(0xFF1F2937),
                    subtitleColor: const Color(0xFF9CA3AF),
                    backgroundColor: Colors.white,
                    icon: Icon(Icons.edit_note, size: 40.w, color: Colors.blueGrey),
                  ),
                  SizedBox(width: 10.w),
                  ResponsiveButtonCard(
                    title: 'Tạo với AI',
                    subtitle: 'Gợi ý thông minh',
                    onTap: () => _navigateToScreen(context, const AddRecipeScreen()),
                    titleColor: const Color(0xFF78350F),
                    subtitleColor: const Color(0xFF92400E),
                    backgroundColor: const Color(0xFFFEF3C7),
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
                  color: const Color(0xFF111827),
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
                    return DraftRecipeItem(draft: draft); // Không cần truyền onTap nữa
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
