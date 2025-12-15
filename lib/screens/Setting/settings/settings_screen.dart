import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

// --- CÁC IMPORT ---
import 'package:fontend/screens/Setting/settings/widgets/DeleteAccountScreen/DeleteAccountScreen.dart';
import 'package:fontend/screens/Setting/settings/widgets/Help/HelpCenterScreen.dart';
import 'package:fontend/screens/Setting/settings/widgets/language.dart';
import 'package:fontend/screens/Setting/settings/widgets/logout_bottom_sheet.dart';
import 'package:fontend/screens/Setting/settings/widgets/reset_pass/password_reset_screen.dart';
import 'package:fontend/screens/Setting/settings/widgets/setting_item.dart';
import 'package:fontend/screens/Setting/settings/widgets/title_header.dart';
import '../../../theme/theme_provider.dart';
import '../../Signin/sign_in&sign_up/auth/auth_gate.dart';
import '../../Signin/sign_in&sign_up/auth/auth_provider.dart';
import '../../Signin/sign_in&sign_up/auth/storage_service.dart';
import '../../survey/logic/survey_provider.dart';
import '../../user_profile/MyUser_profile/logic/my_profile_provider.dart';
import '../notification_setting/NotificationSettingsScreen.dart';
import 'widgets/terms_and_conditions/about_us.dart';
import 'widgets/terms_and_conditions/terms.dart';
import 'logic/settings_provider.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = ref.watch(themeProvider);
    // Không cần watch languageProvider nữa

    final themeData = Theme.of(context);
    final textColor = themeData.textTheme.bodyMedium?.color ?? (isDark ? Colors.white : Colors.black87);

    return Scaffold(
      body: SafeArea(
        child: Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: themeData.scaffoldBackgroundColor,
            boxShadow: [
              BoxShadow(
                color: const Color(0x3F000000).withOpacity(0.05),
                blurRadius: 10.r,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Column(
            children: [
              const TitleHeader(),
              SizedBox(height: 30.h),

              Expanded(
                child: ListView(
                  padding: EdgeInsets.symmetric(horizontal: 10.w),
                  children: [
                    // --- NHÓM 1 ---
                    _buildSettingCard(
                      context,
                      [
                        SettingItem(
                          iconPath: 'image/setting_noti.png',
                          title: 'notifications'.tr(), // <--- DÙNG .tr()
                          onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => NotificationSettingsScreen())),
                        ),
                        _buildDivider(context),
                        SettingItem(
                          iconPath: 'image/setting_lang.png',
                          title: 'language'.tr(), // <--- DÙNG .tr()
                          onTap: () {
                            showModalBottomSheet(
                              context: context,
                              isScrollControlled: true,
                              backgroundColor: Colors.transparent,
                              builder: (_) => const LanguageBottomSheet(),
                            );
                          },
                          trailing: Text(
                            context.locale.languageCode.toUpperCase(), // <--- LẤY MÃ NGÔN NGỮ ('VI' hoặc 'EN')
                            style: TextStyle(fontSize: 14.sp, color: textColor.withOpacity(0.6), fontWeight: FontWeight.w600),
                          ),
                        ),
                        _buildDivider(context),
                        _buildDarkModeItem(context, isDark, ref),
                      ],
                    ),

                    SizedBox(height: 30.h),

                    // --- NHÓM 2 ---
                    _buildSettingCard(
                      context,
                      [
                        SettingItem(
                          iconPath: 'image/setting_term.png',
                          title: 'terms'.tr(),
                          onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => TermsPage())),
                        ),
                        _buildDivider(context),
                        SettingItem(
                          iconPath: 'image/setting_in4.png',
                          title: 'about'.tr(),
                          onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => AboutUs())),
                        ),
                        _buildDivider(context),
                        SettingItem(
                          iconPath: 'image/setting_help.png',
                          title: 'help'.tr(),
                          onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const HelpCenterScreen())),
                        ),
                      ],
                    ),

                    SizedBox(height: 30.h),

                    // --- NHÓM 3 ---
                    _buildSettingCard(
                      context,
                      [
                        SettingItem(
                          iconPath: 'image/setting_pass.png',
                          title: 'password'.tr(),
                          onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => PasswordResetScreen())),
                        ),
                        _buildDivider(context),
                        SettingItem(
                          iconPath: 'image/setting_delete.png',
                          title: 'delete_account'.tr(),
                          showArrow: true,
                          customArrow: Icons.delete_forever_rounded,
                          forceIconColor: const Color(0xFFEB3D32),
                          forceTextColor: const Color(0xFFEB3D32),
                          onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => DeleteAccountScreen())),
                        ),
                        _buildDivider(context),
                        SettingItem(
                          iconPath: 'image/setting_logout.png',
                          title: 'logout'.tr(),
                          showArrow: true,
                          customArrow: Icons.exit_to_app_rounded,
                          forceIconColor: const Color(0xFFFE724C),
                          forceTextColor: const Color(0xFFFE724C),
                          onTap: () => _showCustomBottomSheet(
                            context,
                            LogoutBottomSheett(
                              onConfirm: () => logOut(context, ref),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 40.h),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // --- WIDGET HELPER ---
  Widget _buildSettingCard(BuildContext context, List<Widget> children) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 10.w),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF2C2C2C) : Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 10.r,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16.r),
        child: Column(children: children),
      ),
    );
  }

  Widget _buildDivider(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Divider(
      height: 1.h,
      thickness: 1,
      indent: 20.w,
      endIndent: 20.w,
      color: isDark ? Colors.grey.shade700 : Colors.grey.shade200,
    );
  }

  Widget _buildDarkModeItem(BuildContext context, bool isDark, WidgetRef ref) {
    return SettingItem(
      iconPath: 'image/setting_darkmode.png',
      title: 'dark_mode'.tr(), // <--- DÙNG .tr()
      showArrow: false,
      onTap: () => ref.read(themeProvider.notifier).toggle(),
      trailing: GestureDetector(
        onTap: () => ref.read(themeProvider.notifier).toggle(),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          width: 76.w,
          height: 42.h,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30.r),
            color: isDark ? const Color(0xFFFFB901) : Colors.grey.shade300,
          ),
          padding: EdgeInsets.all(3.r),
          child: AnimatedAlign(
            duration: const Duration(milliseconds: 300),
            alignment: isDark ? Alignment.centerRight : Alignment.centerLeft,
            child: Container(
              width: 36.r,
              height: 36.r,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white,
                boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 6.r, offset: const Offset(0, 2))],
              ),
              child: Icon(
                isDark ? Icons.dark_mode_rounded : Icons.wb_sunny_rounded,
                size: 20.sp,
                color: isDark ? const Color(0xFFFFB901) : Colors.grey.shade600,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> logOut(BuildContext context, WidgetRef ref) async {
    try {
      final authService = ref.read(authServiceProvider);
      await authService.signOut();

      ref.invalidate(myChefProvider);
      ref.invalidate(surveyProvider);
      ref.invalidate(authProvider);

      if (context.mounted) {
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => const AuthGate()),
              (route) => false,
        );
      }
    } catch (e) {
      debugPrint("Lỗi khi đăng xuất: $e");
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Lỗi đăng xuất: $e")),
        );
      }
    }
  }

  void _showCustomBottomSheet(BuildContext context, Widget child) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      useSafeArea: false,
      builder: (_) => Padding(
        padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: child,
      ),
    );
  }
}