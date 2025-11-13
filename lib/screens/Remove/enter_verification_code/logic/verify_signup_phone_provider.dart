import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'dart:async';

final verifySignupPhoneProvider = StateNotifierProvider.autoDispose<
    VerifySignupPhoneNotifier, VerifySignupPhoneState>((ref) {
  return VerifySignupPhoneNotifier();
});

class VerifySignupPhoneState {
  final String code;
  final String errorMessage;
  final bool isWaiting;
  final int secondsLeft;

  VerifySignupPhoneState({
    this.code = '',
    this.errorMessage = '',
    this.isWaiting = false,
    this.secondsLeft = 0,
  });

  VerifySignupPhoneState copyWith({
    String? code,
    String? errorMessage,
    bool? isWaiting,
    int? secondsLeft,
  }) {
    return VerifySignupPhoneState(
      code: code ?? this.code,
      errorMessage: errorMessage ?? this.errorMessage,
      isWaiting: isWaiting ?? this.isWaiting,
      secondsLeft: secondsLeft ?? this.secondsLeft,
    );
  }
}

class VerifySignupPhoneNotifier extends StateNotifier<VerifySignupPhoneState> {
  VerifySignupPhoneNotifier() : super(VerifySignupPhoneState());

  Timer? _timer;

  void setCode(String code) {
    state = state.copyWith(code: code, errorMessage: '');
  }

  Future<void> submitCode(BuildContext context) async {
    if (state.code == '1234') {
      state = state.copyWith(errorMessage: '');
      Navigator.pushNamed(context, '/welcome');
    } else {
      state = state.copyWith(errorMessage: 'Mã xác minh không hợp lệ!');
    }
  }

  void resendCode() {
    // TODO: call API gửi SMS đăng ký tại đây
    _startCooldown();
  }

  void _startCooldown() {
    const cooldown = 60;
    state = state.copyWith(isWaiting: true, secondsLeft: cooldown);

    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (state.secondsLeft <= 1) {
        timer.cancel();
        state = state.copyWith(isWaiting: false, secondsLeft: 0);
      } else {
        state = state.copyWith(secondsLeft: state.secondsLeft - 1);
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}
