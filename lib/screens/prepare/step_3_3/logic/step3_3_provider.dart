import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Provider cho index bước
final stepIndexProvider = StateProvider<int>((ref) => 1);

// Provider cho timer controller
final stepTimerProvider = StateNotifierProvider<StepTimerNotifier, TimerState>((ref) {
  return StepTimerNotifier();
});

// Class quản lý state của timer
class TimerState {
  final int timeLeftInSeconds;
  final bool isPaused;
  final bool isRunning;

  TimerState({
    required this.timeLeftInSeconds,
    required this.isPaused,
    required this.isRunning,
  });

  // Format thời gian thành MM:SS
  String get formattedTime {
    final minutes = timeLeftInSeconds ~/ 60;
    final seconds = timeLeftInSeconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  TimerState copyWith({
    int? timeLeftInSeconds,
    bool? isPaused,
    bool? isRunning,
  }) {
    return TimerState(
      timeLeftInSeconds: timeLeftInSeconds ?? this.timeLeftInSeconds,
      isPaused: isPaused ?? this.isPaused,
      isRunning: isRunning ?? this.isRunning,
    );
  }
}

// Notifier quản lý logic đếm ngược
class StepTimerNotifier extends StateNotifier<TimerState> {
  Timer? _timer;

  StepTimerNotifier()
      : super(TimerState(
    timeLeftInSeconds: 300, // 5 phút
    isPaused: false,
    isRunning: false,
  ));

  // Bắt đầu đếm ngược
  void startTimer() {
    if (state.isRunning) return;

    state = state.copyWith(isRunning: true, isPaused: false);

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!state.isPaused && state.timeLeftInSeconds > 0) {
        state = state.copyWith(
          timeLeftInSeconds: state.timeLeftInSeconds - 1,
        );
      }

      // Dừng timer khi hết thời gian
      if (state.timeLeftInSeconds == 0) {
        stopTimer();
      }
    });
  }

  // Tạm dừng / Tiếp tục
  void togglePause() {
    if (!state.isRunning) {
      startTimer();
    } else {
      state = state.copyWith(isPaused: !state.isPaused);
    }
  }

  // Dừng timer
  void stopTimer() {
    _timer?.cancel();
    _timer = null;
    state = state.copyWith(isRunning: false);
  }

  // Reset timer về thời gian ban đầu
  void resetTimer({int seconds = 300}) {
    stopTimer();
    state = TimerState(
      timeLeftInSeconds: seconds,
      isPaused: false,
      isRunning: false,
    );
  }

  // Đặt thời gian mới
  void setTime(int seconds) {
    state = state.copyWith(timeLeftInSeconds: seconds);
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}