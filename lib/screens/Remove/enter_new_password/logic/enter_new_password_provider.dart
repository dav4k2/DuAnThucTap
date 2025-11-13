import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ResetPasswordController extends ChangeNotifier {
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmController = TextEditingController();

  bool obscurePassword = true;
  bool obscureConfirm = true;
  String? errorText;

  ResetPasswordController() {
    // mỗi lần người dùng nhập, kiểm tra lại để ẩn lỗi nếu hợp lệ
    passwordController.addListener(_onTextChange);
    confirmController.addListener(_onTextChange);
  }

  void _onTextChange() {
    // nếu đang có lỗi mà user gõ lại thì kiểm tra lại
    if (errorText != null) {
      validateInputs(silent: true);
    }
  }

  void togglePassword() {
    obscurePassword = !obscurePassword;
    notifyListeners();
  }

  void toggleConfirm() {
    obscureConfirm = !obscureConfirm;
    notifyListeners();
  }

  /// kiểm tra nhưng không điều hướng, chỉ hiển thị lỗi
  bool validateAndSubmit() {
    final valid = validateInputs(silent: false);
    notifyListeners();
    return valid;
  }

  /// kiểm tra input, silent=true thì không hiện lỗi lên UI
  bool validateInputs({bool silent = false}) {
    final pwd = passwordController.text.trim();
    final confirm = confirmController.text.trim();

    String? newError;

    if (pwd.isEmpty || confirm.isEmpty) {
      newError = 'Vui lòng nhập đầy đủ thông tin';
    } else if (pwd.length < 6) {
      newError = 'Mật khẩu phải có ít nhất 6 ký tự';
    } else if (pwd != confirm) {
      newError = 'Mật khẩu và xác nhận không khớp';
    }

    if (!silent) errorText = newError;

    notifyListeners();
    return newError == null;
  }

  void resetState() {
    passwordController.clear();
    confirmController.clear();
    errorText = null;
    obscurePassword = true;
    obscureConfirm = true;
    notifyListeners();
  }

  @override
  void dispose() {
    passwordController.dispose();
    confirmController.dispose();
    super.dispose();
  }
}

final resetProvider = ChangeNotifierProvider.autoDispose<ResetPasswordController>(
      (ref) => ResetPasswordController(),
);
