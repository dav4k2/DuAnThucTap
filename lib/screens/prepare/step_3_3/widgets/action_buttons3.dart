// lib/screens/prepare/step_1/widgets/action_buttons.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../finish/finish_screen.dart';
import '../logic/step3_3_provider.dart';

class StepActionButtons3 extends ConsumerWidget {
  const StepActionButtons3({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Lấy state từ provider
    final timerState = ref.watch(stepTimerProvider);
    final timerNotifier = ref.read(stepTimerProvider.notifier);

    return Stack(
      children: [
        // Nút Tạm dừng / Tiếp tục / Bắt đầu
        Positioned(
          top: 740 - 597,
          left: 54,
          child: _PauseButton(
            onPressed: () {
              timerNotifier.togglePause();
            },
            isPaused: timerState.isPaused,
            isRunning: timerState.isRunning,
          ),
        ),

        // Nút "Trước đó"
        const Positioned(
          top: 838 - 597,
          left: 54,
          child: _TextButton(label: "Trước đó"),
        ),

        // Nút "Bỏ qua"
        Positioned(
          top: 838 - 597,
          right: 54,
          child: GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const FinishRecipeScreen(),
                ),
              );
            },
            child: const _TextButton(label: "Bỏ qua"),
          ),
        ),
      ],
    );
  }
}

class _PauseButton extends StatelessWidget {
  final VoidCallback onPressed;
  final bool isPaused;
  final bool isRunning;

  const _PauseButton({
    required this.onPressed,
    required this.isPaused,
    required this.isRunning,
  });

  @override
  Widget build(BuildContext context) {
    // Xác định text và icon dựa trên trạng thái
    String buttonText;
    IconData buttonIcon;

    if (!isRunning) {
      // Chưa bắt đầu
      buttonText = 'Bắt đầu';
      buttonIcon = Icons.play_arrow;
    } else if (isPaused) {
      // Đang tạm dừng
      buttonText = 'Tiếp tục';
      buttonIcon = Icons.play_arrow;
    } else {
      // Đang chạy
      buttonText = 'Tạm dừng';
      buttonIcon = Icons.pause;
    }

    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: 293,
        height: 66,
        decoration: BoxDecoration(
          color: const Color(0xFF21DB53),
          borderRadius: BorderRadius.circular(30),
        ),
        alignment: Alignment.center,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              buttonIcon,
              color: Colors.white,
              size: 32,
            ),
            const SizedBox(width: 8),
            Text(
              buttonText,
              style: const TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.w500,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TextButton extends StatelessWidget {
  final String label;

  const _TextButton({required this.label});

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      style: const TextStyle(
        fontSize: 26,
        fontWeight: FontWeight.w500,
        fontFamily: "SF Pro Rounded",
      ),
    );
  }
}