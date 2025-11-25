import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AppLocalizations {
  final Locale locale;

  AppLocalizations(this.locale);

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
  _AppLocalizationsDelegate();

  static final Map<String, Map<String, String>> _localizedValues = {
    'vi': {
      'settings': 'Cài đặt',
      'terms': 'Điều khoản & dịch vụ',
      'notifications': 'Cài đặt thông báo',
      'dark_mode': 'Chế độ tối',
      'about': 'Giới thiệu',
      'password': 'Cài đặt mật khẩu',
      'language': 'Ngôn ngữ',
      'help': 'Trung tâm trợ giúp',
      'logout': 'Đăng xuất',
      'delete_account' : 'Xoá Tài khoản',
    },
    'en': {
      'settings': 'Settings',
      'terms': 'Terms & Services',
      'notifications': 'Notification Settings',
      'dark_mode': 'Dark Mode',
      'about': 'About',
      'password': 'Password Settings',
      'language': 'Language',
      'help': 'HelpCenter',
      'logout': 'Log Out',
      'delete_account' : 'Delete Account',
    },
  };

  String translate(String key) {
    return _localizedValues[locale.languageCode]?[key] ?? key;
  }
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) => ['vi', 'en'].contains(locale.languageCode);

  @override
  Future<AppLocalizations> load(Locale locale) async {
    return AppLocalizations(locale);
  }

  @override
  bool shouldReload(_) => false;
}