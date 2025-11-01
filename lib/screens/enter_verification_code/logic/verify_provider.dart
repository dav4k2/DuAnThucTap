import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';

final verifyCodeProvider = StateNotifierProvider<VerifyCodeNotifier, VerifyCodeState>((ref) {
  return VerifyCodeNotifier();
});

class VerifyCodeState {
  final String code;
  final String errorMessage;

  VerifyCodeState({this.code = '', this.errorMessage = ''});

  VerifyCodeState copyWith({String? code, String? errorMessage}) {
    return VerifyCodeState(
      code: code ?? this.code,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}

class VerifyCodeNotifier extends StateNotifier<VerifyCodeState> {
  VerifyCodeNotifier() : super(VerifyCodeState());

  void setCode(String code) {
    state = state.copyWith(code: code, errorMessage: '');
  }

  Future<void> submitCode(BuildContext context) async {
    if (state.code == '1234') {
      // nếu đúng
      state = state.copyWith(errorMessage: '');
      Navigator.pushNamed(context, '/welcome'); // màn hình đích
    } else {
      // nếu sai
      state = state.copyWith(errorMessage: 'Mã xác minh không hợp lệ!');
    }
  }
}
