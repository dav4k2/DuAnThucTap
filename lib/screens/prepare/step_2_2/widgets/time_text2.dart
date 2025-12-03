import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../logic/step2_2_provider.dart';

class StepTimeText2 extends ConsumerWidget {
  const StepTimeText2({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Lấy state từ provider
    final timerState = ref.watch(stepTimerProvider);

    return Positioned(
      top: 685 - 597,
      left: 0,
      right: 0,
      child: Text(
        timerState.formattedTime,
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 48,
          fontWeight: FontWeight.w700,
          fontFamily: "SF Pro Rounded",
          // Thêm màu đỏ khi sắp hết thời gian (dưới 1 phút)
          color: timerState.timeLeftInSeconds <= 60
              ? Colors.red
              : Colors.black,
        ),
      ),
    );
  }
}