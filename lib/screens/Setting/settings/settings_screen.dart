import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fontend/screens/Setting/settings/widgets/DeleteAccount.dart';
import 'package:fontend/screens/Setting/settings/widgets/setting_item.dart';
import 'package:fontend/screens/Setting/settings/widgets/title_header.dart';
import '../../../theme/app_localizations.dart';
import '../../../theme/language_provider.dart';
import '../../../theme/theme_provider.dart';
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

                    // Các mục cũ giữ nguyên
                    SettingItem(
                      iconPath: 'image/setting_term.png',
                      title: l10n.translate('terms'),
                      iconLeft: 10.5,
                      iconTop: 100,
                      onTap: () => _showInfo(context, l10n.translate('terms')),
                    ),
                    SettingItem(
                      iconPath: 'image/setting_noti.png',
                      title: l10n.translate('notifications'),
                      iconLeft: 10.5,
                      iconTop: 170,
                      onTap: () => _showInfo(context, l10n.translate('notifications')),
                    ),
                    SettingItem(
                      iconPath: 'image/setting_darkmode.png',
                      title: l10n.translate('dark_mode'),
                      iconLeft: 9.5,
                      iconTop: 240,
                      showArrow: false,
                      trailing: Switch(
                        value: isDark,
                        onChanged: (_) => ref.read(themeProvider.notifier).toggle(),
                        activeColor: const Color(0xFFD4A017),
                      ),
                    ),
                    SettingItem(
                      iconPath: 'image/setting_in4.png',
                      title: l10n.translate('about'),
                      iconLeft: 11,
                      iconTop: 310,
                      onTap: () => _showInfo(context, l10n.translate('about')),
                    ),
                    SettingItem(
                      iconPath: 'image/setting_pass.png',
                      title: l10n.translate('password'),
                      iconLeft: 11,
                      iconTop: 380,
                      onTap: () => _showInfo(context, l10n.translate('password')),
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
                      onTap: () => _showInfo(context, l10n.translate('help')),
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