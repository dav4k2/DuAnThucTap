import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'dart:async';

final verifyResetEmailProvider = StateNotifierProvider.autoDispose<
    VerifyResetEmailNotifier, VerifyResetEmailState>((ref) {
  return VerifyResetEmailNotifier();
});

class VerifyResetEmailState {
  final String code;
  final String errorMessage;
  final bool isWaiting;
  final int secondsLeft;

  VerifyResetEmailState({
    this.code = '',
    this.errorMessage = '',
    this.isWaiting = false,
    this.secondsLeft = 0,
  });

  VerifyResetEmailState copyWith({
    String? code,
    String? errorMessage,
    bool? isWaiting,
    int? secondsLeft,
  }) {
    return VerifyResetEmailState(
      code: code ?? this.code,
      errorMessage: errorMessage ?? this.errorMessage,
      isWaiting: isWaiting ?? this.isWaiting,
      secondsLeft: secondsLeft ?? this.secondsLeft,
    );
  }
}

class VerifyResetEmailNotifier extends StateNotifier<VerifyResetEmailState> {
  VerifyResetEmailNotifier() : super(VerifyResetEmailState());

  Timer? _timer;

  void setCode(String code) {
    state = state.copyWith(code: code, errorMessage: '');
  }

  Future<void> submitCode(BuildContext context) async {
    if (state.code == '1234') {
      state = state.copyWith(errorMessage: '');
      Navigator.pushNamed(context, '/enterpass');
    } else {
      state = state.copyWith(errorMessage: 'Mã xác minh không hợp lệ!');
    }
  }

  void resendCode() {
    // TODO: call API send mail tại đây
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
