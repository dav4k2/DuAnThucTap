import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fontend/screens/setting/widgets/setting_item.dart';
import 'package:fontend/screens/setting/widgets/title_header.dart';
import '../../theme/app_localizations.dart';
import '../../theme/language_provider.dart';
import '../../theme/theme_provider.dart';
import 'logic/settings_provider.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = ref.watch(themeProvider);
    final lang = ref.watch(languageProvider);
    final l10n = AppLocalizations.of(context); // BÂY GIỜ AN TOÀN
    final textColor = Theme.of(context).textTheme.bodyMedium!.color!;
    final notifier = ref.read(settingsProvider);

    return Scaffold(
      body: Container(
        width: 402.w,
        height: 874.h,
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(color: const Color(0x3F000000), blurRadius: 4.r, offset: const Offset(0, 4)),
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
                  color: Theme.of(context).scaffoldBackgroundColor, // ĐÚNG THEME
                  shape: const RoundedRectangleBorder(side: BorderSide(width: 0)),
                ),
                child: Stack(
                  children: [
                    const TitleHeader(),

                    SettingItem(
                      iconPath: 'image/setting_term.png',
                      title: l10n.translate('terms'),
                      iconLeft: 10.5,
                      iconTop: 120,
                      onTap: () => _showInfo(context, l10n.translate('terms')),
                    ),

                    SettingItem(
                      iconPath: 'image/setting_noti.png',
                      title: l10n.translate('notifications'),
                      iconLeft: 10.5,
                      iconTop: 196,
                      onTap: () => _showInfo(context, l10n.translate('notifications')),
                    ),

                    SettingItem(
                      iconPath: 'image/setting_darkmode.png',
                      title: l10n.translate('dark_mode'),
                      iconLeft: 9.5,
                      iconTop: 275,
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
                      iconTop: 353,
                      onTap: () => _showInfo(context, l10n.translate('about')),
                    ),

                    SettingItem(
                      iconPath: 'image/setting_pass.png',
                      title: l10n.translate('password'),
                      iconLeft: 11,
                      iconTop: 435,
                      onTap: () => _showInfo(context, l10n.translate('password')),
                    ),

                    SettingItem(
                      iconPath: 'image/setting_lang.png',
                      title: l10n.translate('language'),
                      iconLeft: 11,
                      iconTop: 513,
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
                      iconTop: 589,
                      onTap: () => _showInfo(context, l10n.translate('help')),
                    ),

                    SettingItem(
                      iconPath: 'image/setting_logout.png',
                      title: l10n.translate('logout'),
                      iconLeft: 11,
                      iconTop: 677,
                      onTap: () => notifier.logout(context),
                      showArrow: false,
                      customArrow: Icons.exit_to_app,
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
}