import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final settingsProvider = Provider<SettingsNotifier>((ref) {
  return SettingsNotifier();
});

class SettingsNotifier {
  void logout(BuildContext context) {
    // XỬ LÝ ĐĂNG XUẤT Ở ĐÂY
    // Ví dụ: xóa token, chuyển về login
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Đã đăng xuất')),
    );
    // Navigator.pushNamedAndRemoveUntil(context, '/signin', (route) => false);
  }
}