// lib/screens/create_recipe_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fontend/screens/Crete_recipe/widgets/draft_recipe_item.dart';
import 'package:fontend/screens/Crete_recipe/widgets/responsive_button_card.dart';
import '../../../../theme/theme_provider.dart';
import '../AI/chat_screen.dart';
import '../Guide/data/ai_guide_data.dart';
import '../Guide/data/manual_guide_data.dart';
import '../Guide/model/guide_model.dart';
import '../Guide/user_guide_dialog_screen.dart';
import '../NewRecipes/add_recipe_screen.dart';
import '../NewRecipes/logic/add_recipe_provider.dart';
import 'logic/draft_provider.dart';

class CreateRecipeScreen extends ConsumerWidget {
  const CreateRecipeScreen({super.key});

  void _navigateToScreen(BuildContext context, Widget screen) {
    Navigator.push(context, MaterialPageRoute(builder: (_) => screen));
  }

  // Hàm gọi Dialog chung, nhận vào list steps bất kỳ
  void _showGuide(BuildContext context, List<GuideStep> steps) {
    showDialog(
      context: context,
      builder: (context) => UserGuideDialog(steps: steps),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDarkMode = ref.watch(themeProvider);
    final textColor = isDarkMode ? Colors.white : Colors.black;
    final subTextColor = isDarkMode ? Colors.grey[400]! : Colors.black;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: isDarkMode
          ? SystemUiOverlayStyle.light.copyWith(statusBarColor: Colors.transparent)
          : SystemUiOverlayStyle.light.copyWith(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.dark),
      child: Scaffold(
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: MediaQuery.of(context).padding.top + 21.h),

            Padding(
              padding: EdgeInsets.symmetric(horizontal: 25.w),
              child: Text(
                'Thêm công thức mớiii',
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
                      text: 'Khám phá sự sáng tạo trong căn bếp của bạn',
                      style: TextStyle(
                        color: textColor,
                        fontSize: 28.sp,
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
                  'Đóng góp công thức nấu ăn của bạn vào cộng đồng Cookhub...',
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

            // --- KHU VỰC 2 NÚT CHỨC NĂNG ---
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  // 1. Nút Tự Tạo -> Truyền manualGuideSteps
                  _CardWithHelp(
                    onHelpTap: () => _showGuide(context, manualGuideSteps),
                    child: ResponsiveButtonCard(
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
                  ),

                  SizedBox(width: 10.w),

                  // 2. Nút AI -> Truyền aiGuideSteps
                  _CardWithHelp(
                    onHelpTap: () => _showGuide(context, aiGuideSteps),
                    child: ResponsiveButtonCard(
                      title: 'Tạo với AI',
                      subtitle: 'Gợi ý thông minh',
                      onTap: () => _navigateToScreen(context, const ChatScreen()),
                      titleColorLight: const Color(0xFF78350F),
                      subtitleColorLight: const Color(0xFF92400E),
                      backgroundColorLight: const Color(0xFFFEF3C7),
                      titleColorDark: Colors.white,
                      subtitleColorDark: Colors.grey[300]!,
                      backgroundColorDark: const Color(0xFFFFC836),
                      icon: Icon(Icons.auto_fix_high, size: 40.w, color: const Color(0xFFD97706)),
                    ),
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
                          child: Text('Chưa có bản nháp nào',
                              style: TextStyle(fontSize: 16.sp, color: Colors.grey[600])));
                    }
                    return ListView.builder(
                      padding: EdgeInsets.only(bottom: 110.h),
                      itemCount: drafts.length,
                      itemBuilder: (context, index) {
                        final draft = drafts[index];
                        return GestureDetector(
                          onTap: () {
                            // 1. Load dữ liệu nháp vào Provider
                            ref.read(addRecipeProvider.notifier).loadFromDraft(draft);

                            // 2. Mở màn hình AddRecipeScreen
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (_) => const AddRecipeScreen()),
                            );
                          },
                          child: DraftRecipeItem(draft: draft),
                        );
                      },
                    );

                  },
                ),
              ),
            ),
          ],
        ),

      ),

    );
  }
}

// Widget Helper: Nút ? đè lên Card
class _CardWithHelp extends StatelessWidget {
  final Widget child;
  final VoidCallback onHelpTap;

  const _CardWithHelp({Key? key, required this.child, required this.onHelpTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        child,
        Positioned(
          top: 8.h,
          right: 8.w,
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: onHelpTap,
              borderRadius: BorderRadius.circular(20),
              child: Container(
                padding: EdgeInsets.all(4.w),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withOpacity(0.6),
                  border: Border.all(color: Colors.grey.withOpacity(0.3), width: 1),
                  boxShadow: [
                    BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 2))
                  ],
                ),
                child: Icon(
                  Icons.help_outline_rounded,
                  size: 20.sp,
                  color: const Color(0xFFFE724C),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}