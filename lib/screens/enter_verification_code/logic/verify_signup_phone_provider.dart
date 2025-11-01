import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';

final verifySignupPhoneProvider = StateNotifierProvider<VerifySignupPhoneNotifier, VerifySignupPhoneState>((ref) {
  return VerifySignupPhoneNotifier();
});

class VerifySignupPhoneState {
  final String code;
  final String errorMessage;

  VerifySignupPhoneState({this.code = '', this.errorMessage = ''});

  VerifySignupPhoneState copyWith({String? code, String? errorMessage}) {
    return VerifySignupPhoneState(
      code: code ?? this.code,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}

class VerifySignupPhoneNotifier extends StateNotifier<VerifySignupPhoneState> {
  VerifySignupPhoneNotifier() : super(VerifySignupPhoneState());

  void setCode(String code) {
    state = state.copyWith(code: code, errorMessage: '');
  }

  Future<void> submitCode(BuildContext context) async {
    if (state.code == '1234') {
      state = state.copyWith(errorMessage: '');
      Navigator.pushNamed(context, '/signup-success-phone');
    } else {
      state = state.copyWith(errorMessage: 'Mã xác minh không hợp lệ!');
    }
  }
}
