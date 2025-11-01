import 'package:flutter_riverpod/flutter_riverpod.dart';

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

class AuthNotifier extends StateNotifier<AuthState> {
  /// Đăng ký
  String register(String account, String password, String email) {
    if (account.isEmpty || email.isEmpty || password.isEmpty ) {
      return "Không được để trống";
    }

    // demo: chặn user "admin"
    if (account.toLowerCase() == "admin") {
      return "Tài khoản đã tồn tại";
    }

    // success
    state = state.copyWith(errorMessage: null);
    return "done";
  }

  AuthNotifier() : super(const AuthState());

  /// Toggle show password
  void togglePassword() {
    state = state.copyWith(showPassword: !state.showPassword);
  }

  void toggleConfirmPassword() {
    state = state.copyWith(showConfirmPassword: !state.showConfirmPassword);
  }

  void toggleTerms() {
    state = state.copyWith(agreeTerms: !state.agreeTerms);
  }

  /// Đăng nhập
  String? login(String account, String password) {
    if (account.isEmpty || password.isEmpty) {
      return "Vui lòng nhập tài khoản và mật khẩu!";
    }
    if (account == "a" && password == "1") return "admin";
    if (account == "u" && password == "1") return "user";
    return "Tài khoản hoặc mật khẩu không đúng!";
  }

  /// Đăng ký
  String? signup(String account, String pass, String confirm, String email) {
    if (account.isEmpty || pass.isEmpty || confirm.isEmpty || email.isEmpty) {
      return "Vui lòng điền đầy đủ thông tin!";
    }
    if (pass != confirm) {
      return "Mật khẩu nhập lại không khớp!";
    }
    if (!state.agreeTerms) {
      return "Vui lòng đồng ý với điều khoản!";
    }
    return null; // hợp lệ
  }

  void setError(String? msg) {
    state = state.copyWith(errorMessage: msg);
  }
}

final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  return AuthNotifier();
});
