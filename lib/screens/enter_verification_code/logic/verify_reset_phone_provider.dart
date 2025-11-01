import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';

final verifyResetPhoneProvider = StateNotifierProvider<VerifyResetPhoneNotifier, VerifyResetPhoneState>((ref) {
  return VerifyResetPhoneNotifier();
});

class VerifyResetPhoneState {
  final String code;
  final String errorMessage;

  VerifyResetPhoneState({this.code = '', this.errorMessage = ''});

  VerifyResetPhoneState copyWith({String? code, String? errorMessage}) {
    return VerifyResetPhoneState(
      code: code ?? this.code,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}

class VerifyResetPhoneNotifier extends StateNotifier<VerifyResetPhoneState> {
  VerifyResetPhoneNotifier() : super(VerifyResetPhoneState());

  void setCode(String code) {
    state = state.copyWith(code: code, errorMessage: '');
  }

  Future<void> submitCode(BuildContext context) async {
    if (state.code == '1234') {
      state = state.copyWith(errorMessage: '');
      Navigator.pushNamed(context, '/reset-password-phone');
    } else {
      state = state.copyWith(errorMessage: 'Mã xác minh không hợp lệ!');
    }
  }
}
