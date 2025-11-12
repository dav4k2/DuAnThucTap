import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fontend/screens/setting/widgets/setting_item.dart';
import 'package:fontend/screens/setting/widgets/title_header.dart';

import '../../theme/language_provider.dart';
import '../../theme/theme_provider.dart';

import 'logic/settings_provider.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = ref.watch(themeProvider);
    final lang = ref.watch(languageProvider);
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
                  color: Theme.of(context).scaffoldBackgroundColor, // TỰ ĐỔI THEO THEME
                  shape: RoundedRectangleBorder(
                    side: const BorderSide(width: 0),
                  ),
                ),
                child: Stack(
                  children: [
                    // Tiêu đề
                    const TitleHeader(),

                    // Điều khoản & dịch vụ
                    SettingItem(
                      iconPath: 'image/setting_term.png',
                      title: 'Điều khoản & dịch vụ',
                      iconLeft: 10.5,
                      iconTop: 120,
                      onTap: () => _showInfo(context, 'Điều khoản & dịch vụ'),
                    ),

                    // Cài đặt thông báo
                    SettingItem(
                      iconPath: 'image/setting_noti.png',
                      title: 'Cài đặt thông báo',
                      iconLeft: 10.5,
                      iconTop: 196,
                      onTap: () => _showInfo(context, 'Cài đặt thông báo'),
                    ),

                    // Chế độ tối
                    SettingItem(
                      iconPath: 'image/setting_darkmode.png',
                      title: 'Chế độ tối',
                      iconLeft: 9.5,
                      iconTop: 275,
                      showArrow: false,
                      trailing: Switch(
                        value: isDark,
                        onChanged: (_) => ref.read(themeProvider.notifier).toggle(),
                        activeColor: const Color(0xFFD4A017),
                      ),
                    ),

                    // Giới thiệu
                    SettingItem(
                      iconPath: 'image/setting_in4.png',
                      title: 'Giới thiệu',
                      iconLeft: 11,
                      iconTop: 353,
                      onTap: () => _showInfo(context, 'Giới thiệu'),
                    ),

                    // Cài đặt mật khẩu
                    SettingItem(
                      iconPath: 'image/setting_pass.png',
                      title: 'Cài đặt mật khẩu',
                      iconLeft: 11,
                      iconTop: 435,
                      onTap: () => _showInfo(context, 'Cài đặt mật khẩu'),
                    ),

                    // Ngôn ngữ
                    SettingItem(
                      iconPath: 'image/setting_lang.png',
                      title: 'Ngôn ngữ',
                      iconLeft: 11,
                      iconTop: 513,
                      onTap: () => _selectLanguage(context, ref),
                      trailing: Text(
                        lang.toUpperCase(),
                        style: TextStyle(fontSize: 24.sp, color: Colors.grey[600]),
                      ),
                    ),

                    // Trung tâm trợ giúp
                    SettingItem(
                      iconPath: 'image/setting_help.png',
                      title: 'Trung tâm trợ giúp',
                      iconLeft: 7.5,
                      iconTop: 589,
                      onTap: () => _showInfo(context, 'Trung tâm trợ giúp'),
                    ),

                    // Đăng xuất
                    SettingItem(
                      iconPath: 'image/setting_logout.png',
                      title: 'Đăng xuất',
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
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Đã chọn: $title')),
    );
  }

  void _selectLanguage(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Chọn ngôn ngữ'),
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