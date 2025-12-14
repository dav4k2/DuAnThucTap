import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'auth_service.dart';

// 1. Provider cho AuthService (để gọi hàm signIn, signUp...)
final authServiceProvider = Provider<AuthService>((ref) {
  return AuthService();
});

// 2. State lưu trạng thái UI (hiện/ẩn pass, checkbox, lỗi)
class AuthState {
  final String? errorMessage;
  final bool showPassword;
  final bool showConfirmPassword;
  final bool agreeTerms;

  const AuthState({
    this.errorMessage,
    this.showPassword = false,
    this.showConfirmPassword = false,
    this.agreeTerms = false,
  });

  AuthState copyWith({
    String? errorMessage,
    bool? showPassword,
    bool? showConfirmPassword,
    bool? agreeTerms,
  }) {
    return AuthState(
      errorMessage: errorMessage,
      showPassword: showPassword ?? this.showPassword,
      showConfirmPassword: showConfirmPassword ?? this.showConfirmPassword,
      agreeTerms: agreeTerms ?? this.agreeTerms,
    );
  }
}

// 3. Notifier quản lý logic UI
class AuthNotifier extends StateNotifier<AuthState> {
  AuthNotifier() : super(const AuthState());

  void togglePassword() => state = state.copyWith(showPassword: !state.showPassword);
  void toggleConfirmPassword() => state = state.copyWith(showConfirmPassword: !state.showConfirmPassword);
  void toggleTerms() => state = state.copyWith(agreeTerms: !state.agreeTerms);
  void setError(String? msg) => state = state.copyWith(errorMessage: msg);

  // Validate form đăng ký
  String? validateSignup(String username, String email, String pass, String confirm) {
    if (username.trim().isEmpty) return 'Vui lòng nhập tên tài khoản';
    if (email.trim().isEmpty) return 'Vui lòng nhập email';
    if (!email.contains('@')) return 'Email không hợp lệ';
    if (pass.length < 6) return 'Mật khẩu phải ít nhất 6 ký tự';
    if (pass != confirm) return 'Mật khẩu nhập lại không khớp';
    if (!state.agreeTerms) return 'Vui lòng đồng ý điều khoản';
    return null;
  }
}

final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  return AuthNotifier();
});