import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';

final verifySignupEmailProvider = StateNotifierProvider<VerifySignupEmailNotifier, VerifySignupEmailState>((ref) {
  return VerifySignupEmailNotifier();
});

class VerifySignupEmailState {
  final String code;
  final String errorMessage;

  VerifySignupEmailState({this.code = '', this.errorMessage = ''});

  VerifySignupEmailState copyWith({String? code, String? errorMessage}) {
    return VerifySignupEmailState(
      code: code ?? this.code,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}

class VerifySignupEmailNotifier extends StateNotifier<VerifySignupEmailState> {
  VerifySignupEmailNotifier() : super(VerifySignupEmailState());

  void setCode(String code) {
    state = state.copyWith(code: code, errorMessage: '');
  }

  Future<void> submitCode(BuildContext context) async {
    if (state.code == '1234') {
      state = state.copyWith(errorMessage: '');
      Navigator.pushNamed(context, '/signup-success-email');
    } else {
      state = state.copyWith(errorMessage: 'Mã xác minh không hợp lệ!');
    }
  }
}
