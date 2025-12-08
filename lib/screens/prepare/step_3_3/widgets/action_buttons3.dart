import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../finish/finish_screen.dart';
import '../logic/step3_3_provider.dart';

class StepActionButtons3 extends ConsumerWidget {
  const StepActionButtons3({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final timerState = ref.watch(stepTimerProvider);
    final timerNotifier = ref.read(stepTimerProvider.notifier);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // 1. Nút To (Bắt đầu / Tạm dừng)
        _PauseButton(
          onPressed: () {
            timerNotifier.togglePause();
          },
          isPaused: timerState.isPaused,
          isRunning: timerState.isRunning,
        ),

        const SizedBox(height: 20),

        // 2. Hàng ngang chứa "Trước đó" | "Bỏ qua"
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Nút Trái
              const _TextButton(label: "Trước đó"),

              // Đường kẻ dọc ngăn cách
              Container(
                width: 1,
                height: 24,
                color: Colors.black,
              ),

              // Nút Phải (Chuyển trang)
              GestureDetector(
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
            ],
          ),
        ),
      ],
    );
  }
}

// Widget nút Pause
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
    String buttonText;
    IconData buttonIcon;

    // 👇 Đã sửa: Tất cả trạng thái đều dùng màu ĐEN
    Color btnColor = Colors.black;

    if (!isRunning) {
      buttonText = 'Bắt đầu';
      buttonIcon = Icons.play_arrow;
    } else if (isPaused) {
      buttonText = 'Tiếp tục';
      buttonIcon = Icons.play_arrow;
    } else {
      buttonText = 'Tạm dừng';
      buttonIcon = Icons.pause;
    }

    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: 293,
        height: 66,
        decoration: BoxDecoration(
          color: btnColor, // ⚫ Luôn là màu đen
          borderRadius: BorderRadius.circular(30),
        ),
        alignment: Alignment.center,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Icon
            if (buttonIcon == Icons.pause)
              const Text("|| ", style: TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.bold))
            else
              Icon(buttonIcon, color: Colors.white, size: 32),

            const SizedBox(width: 8),
            // Text
            Text(
              buttonText,
              style: const TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.w500,
                color: Colors.white, // Chữ trắng trên nền đen
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
        fontSize: 24,
        fontWeight: FontWeight.w500,
        color: Colors.black,
        fontFamily: "SF Pro Rounded",
      ),
    );
  }
}