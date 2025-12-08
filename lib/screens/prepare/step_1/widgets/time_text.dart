import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../logic/step_provider1.dart';

class StepTimeText1 extends ConsumerWidget {
  const StepTimeText1({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Lấy state từ provider
    final timerState = ref.watch(stepTimerProvider);

    // ❌ Đã xóa Positioned để layout tự động
    return Text(
      timerState.formattedTime,
      textAlign: TextAlign.center,
      style: TextStyle(
        fontSize: 64, // Tăng size lên một chút cho giống ảnh mẫu (số to)
        fontWeight: FontWeight.w700,
        fontFamily: "SF Pro Rounded",
        // Logic màu sắc giữ nguyên
        color: timerState.timeLeftInSeconds <= 60
            ? Colors.red
            : Colors.black,
      ),
    );
  }
}