import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'auth_service.dart';

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
  AuthNotifier() : super(const AuthState());

  // ---------------- TOGGLE UI ----------------
  void togglePassword() {
    state = state.copyWith(showPassword: !state.showPassword);
  }

  void toggleConfirmPassword() {
    state = state.copyWith(showConfirmPassword: !state.showConfirmPassword);
  }

  void toggleTerms() {
    state = state.copyWith(agreeTerms: !state.agreeTerms);
  }

  void setError(String? msg) {
    state = state.copyWith(errorMessage: msg);
  }

  // ---------------- LOGIN (giữ nguyên logic cũ) ----------------
  String? login(String account, String password) {
    if (account.isEmpty || password.isEmpty) {
      return "Vui lòng nhập tài khoản và mật khẩu!";
    }
    if (account == "a" && password == "1") return "admin";
    if (account == "u" && password == "1") return "user";
    return "Tài khoản hoặc mật khẩu không đúng!";
  }

  // ---------------- SIGNUP (email hoặc SĐT) ----------------
  String? signup(String account, String pass, String confirm, String emailOrPhone) {
    final acc = account.trim();
    final input = emailOrPhone.trim();
    final password = pass.trim();
    final confirmPassword = confirm.trim();

    if (acc.isEmpty) return 'Vui lòng nhập tài khoản';
    if (input.isEmpty) return 'Vui lòng nhập email hoặc số điện thoại';
    if (password.isEmpty) return 'Vui lòng nhập mật khẩu';
    if (confirmPassword.isEmpty) return 'Vui lòng nhập lại mật khẩu';

    final phoneRegex = RegExp(r'^[0-9]{4,11}$'); // demo: 4-11 chữ số
    final isEmail = input.contains('@');
    final isPhone = phoneRegex.hasMatch(input);

    if (!(isEmail || isPhone)) return 'Email hoặc SĐT không hợp lệ';

    if (isEmail) {
      final emailRegex = RegExp(r"^[^\s@]+@[^\s@]+\.[^\s@]+$");
      if (!emailRegex.hasMatch(input)) return 'Email không hợp lệ';
    }

    if (password.length < 4) return 'Mật khẩu phải ít nhất 4 ký tự';
    if (password != confirmPassword) return 'Mật khẩu nhập lại không khớp';
    if (acc.toLowerCase() == 'admin') return 'Tài khoản đã tồn tại';
    if (!state.agreeTerms) return 'Vui lòng đồng ý với điều khoản';

    return null; // hợp lệ
  }

  // ---------------- REGISTER (callback phân biệt email/phone) ----------------
  void register(
      String account,
      String pass,
      String confirm,
      String emailOrPhone,
      void Function(bool isEmail) onSuccess,
      ) {
    final error = signup(account, pass, confirm, emailOrPhone);
    if (error != null) {
      setError(error);
      return;
    }

    final isEmail = emailOrPhone.contains('@');
    final phoneRegex = RegExp(r'^[0-9]{4,11}$');
    final isPhone = phoneRegex.hasMatch(emailOrPhone);

    if (isEmail || isPhone) {
      setError(null);
      onSuccess(isEmail);
    }
  }
}

final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  return AuthNotifier();
});

final authServiceProvider = Provider<AuthServices>((ref) {
  return AuthServices();
});