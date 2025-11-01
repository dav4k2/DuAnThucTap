import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';

final verifyResetEmailProvider = StateNotifierProvider<VerifyResetEmailNotifier, VerifyResetEmailState>((ref) {
  return VerifyResetEmailNotifier();
});

class VerifyResetEmailState {
  final String code;
  final String errorMessage;

  VerifyResetEmailState({this.code = '', this.errorMessage = ''});

  VerifyResetEmailState copyWith({String? code, String? errorMessage}) {
    return VerifyResetEmailState(
      code: code ?? this.code,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}

class VerifyResetEmailNotifier extends StateNotifier<VerifyResetEmailState> {
  VerifyResetEmailNotifier() : super(VerifyResetEmailState());

  void setCode(String code) {
    state = state.copyWith(code: code, errorMessage: '');
  }

  Future<void> submitCode(BuildContext context) async {
    if (state.code == '1234') {
      state = state.copyWith(errorMessage: '');
      Navigator.pushNamed(context, '/welcome'); // route đặt lại mật khẩu
    } else {
      state = state.copyWith(errorMessage: 'Mã xác minh không hợp lệ!');
    }
  }
}
