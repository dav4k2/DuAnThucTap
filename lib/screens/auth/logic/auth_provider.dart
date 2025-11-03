import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Provider lưu trạng thái màn hình (đăng nhập / đăng ký)
final authModeProvider = StateProvider<AuthMode>((ref) => AuthMode.login);

enum AuthMode { login, register }
