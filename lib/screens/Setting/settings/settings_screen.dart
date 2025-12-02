import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fontend/screens/Setting/settings/widgets/DeleteAccount.dart';
import 'package:fontend/screens/Setting/settings/widgets/Help/HelpCenterScreen.dart';
import 'package:fontend/screens/Setting/settings/widgets/reset_pass/password_reset_screen.dart';
import 'package:fontend/screens/Setting/settings/widgets/setting_item.dart';
import 'package:fontend/screens/Setting/settings/widgets/title_header.dart';
import '../../../theme/app_localizations.dart';
import '../../../theme/language_provider.dart';
import '../../../theme/theme_provider.dart';
import '../notification_setting/NotificationSettingsScreen.dart';
import 'widgets/terms_and_conditions/about_us.dart';
import 'widgets/terms_and_conditions/terms.dart';
import 'logic/settings_provider.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = ref.watch(themeProvider);
    final lang = ref.watch(languageProvider);
    final l10n = AppLocalizations.of(context);
    final textColor = Theme.of(context).textTheme.bodyMedium!.color!;
    final notifier = ref.read(settingsProvider);

    return Scaffold(
      body: Container(
        width: 402.w,
        height: 874.h,
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: const Color(0x3F000000),
              blurRadius: 4.r,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Stack(
          children: [
            Positioned(
              left: 0,
              top: 0,
              child: Container(
                width: 402.w,
                height: 874.h,
                clipBehavior: Clip.antiAlias,
                decoration: ShapeDecoration(
                  color: Theme.of(context).scaffoldBackgroundColor,
                  shape: const RoundedRectangleBorder(side: BorderSide(width: 0)),
                ),
                child: Stack(
                  children: [
                    const TitleHeader(),

                    // Điều khoản
                    SettingItem(
                      iconPath: 'image/setting_term.png',
                      title: l10n.translate('terms'),
                      iconLeft: 10.5,
                      iconTop: 100,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => TermsPage()),
                        );
                      },

                    ),

                    //Thông báo
                    SettingItem(
                      iconPath: 'image/setting_noti.png',
                      title: l10n.translate('notifications'),
                      iconLeft: 10.5,
                      iconTop: 170,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => NotificationSettingsScreen()),
                        );
                      },
                    ),

                    //Dark mode
                    SettingItem(
                      iconPath: 'image/setting_darkmode.png',
                      title: l10n.translate('dark_mode'),
                      iconLeft: 9.5,
                      iconTop: 240,
                      showArrow: false,

                      trailing: GestureDetector(
                        onTap: () => ref.read(themeProvider.notifier).toggle(),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          width: 76,
                          height: 42,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30),

                            color: isDark ? const Color(0xFFFFB901) : Colors.grey.shade300,
                          ),
                          padding: const EdgeInsets.all(3),
                          child: AnimatedAlign(
                            duration: const Duration(milliseconds: 300),

                            alignment: isDark ? Alignment.centerRight : Alignment.centerLeft,
                            child: Container(
                              width: 36,
                              height: 36,
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.white,
                                boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 6, offset: Offset(0, 2))],
                              ),
                              child: Icon(

                                isDark ? Icons.brightness_2_rounded : Icons.wb_sunny_rounded,
                                size: 20,

                                color: isDark ? const Color(0xFFFFB901) : Colors.grey.shade600,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),

                    //Giới thiệu
                    SettingItem(
                      iconPath: 'image/setting_in4.png',
                      title: l10n.translate('about'),
                      iconLeft: 11,
                      iconTop: 310,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => AboutUs()),
                        );
                      },
                    ),
                    SettingItem(
                      iconPath: 'image/setting_pass.png',
                      title: l10n.translate('password'),
                      iconLeft: 11,
                      iconTop: 380,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => PasswordResetScreen()),
                        );
                      },
                    ),
                    SettingItem(
                      iconPath: 'image/setting_lang.png',
                      title: l10n.translate('language'),
                      iconLeft: 11,
                      iconTop: 450,
                      onTap: () => _selectLanguage(context, ref),
                      trailing: Text(
                        lang.toUpperCase(),
                        style: TextStyle(fontSize: 24.sp, color: textColor.withOpacity(0.6)),
                      ),
                    ),
                    SettingItem(
                      iconPath: 'image/setting_help.png',
                      title: l10n.translate('help'),
                      iconLeft: 7.5,
                      iconTop: 520,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => HelpCenterApp()),
                        );
                      },
                    ),
                    SettingItem(
                      iconPath: 'image/setting_logout.png',
                      title: l10n.translate('logout'),
                      iconLeft: 11,
                      iconTop: 590,
                      onTap: () => notifier.logout(context),
                      showArrow: false,
                      customArrow: Icons.exit_to_app,
                    ),


                    SettingItem(
                      iconPath: 'image/setting_delete.png',
                      title: l10n.translate('delete_account'),
                      iconLeft: 11,
                      iconTop: 660,
                      onTap: () => _showDeleteAccountDialog(context),
                      showArrow: false,
                      customArrow: Icons.delete_forever,
                      forceIconColor: const Color(0xFFEB3D32),
                      forceTextColor: const Color(0xFFEB3D32),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showInfo(BuildContext context, String title) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(title)));
  }

  void _selectLanguage(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l10n.translate('language')),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            {'code': 'vi', 'name': 'Tiếng Việt'},
            {'code': 'en', 'name': 'English'},
          ].map((lang) => ListTile(
            title: Text(lang['name']!),
            onTap: () {
              ref.read(languageProvider.notifier).set(lang['code']!);
              Navigator.pop(ctx);
            },
          )).toList(),
        ),
      ),
    );
  }

  // DIALOG XÓA TÀI KHOẢN MỚI
// Thay hàm _showDeleteAccountDialog bằng cái này:
  void _showDeleteAccountDialog(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => Padding(
        padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: DeleteAccountBottomSheet(
          onConfirm: () {
            // TODO: gọi API xóa tài khoản thật ở đây
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Đang xử lý xóa tài khoản...')),
            );
          },
        ),
      ),
    );
  }}