import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../step_0/step_screen.dart';
import '../logic//prepare_provider.dart';

class BottomSection extends ConsumerWidget {
  const BottomSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final done = ref.watch(prepareStateProvider);

    return Positioned(
      top: 597,
      left: 0,
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: 277,
        decoration: const BoxDecoration(
          color: Color(0xFFFFB901),
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(30),
            topRight: Radius.circular(30),
            bottomLeft: Radius.circular(50),
            bottomRight: Radius.circular(50),
          ),
        ),
        child: Column(
          children: [
            const SizedBox(height: 30),
            const Text(
              "Chuẩn bị nguyên liệu",
              style: TextStyle(fontSize: 25, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 50),

            // Nút "Đã xong" kiêm chuyển trang
            GestureDetector(
              onTap: () {
                // 1. Cập nhật trạng thái
                ref.read(prepareStateProvider.notifier).state = true;

                // 2. Chuyển sang StepScreen
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const StepScreen(),
                  ),
                );
              },
              child: Container(
                width: 229,
                height: 66,
                decoration: BoxDecoration(
                  color: Colors.black, // ⚫ Đã đổi thành màu đen
                  borderRadius: BorderRadius.circular(30),
                ),
                child: const Center(
                  child: Text(
                    "Đã xong",
                    style: TextStyle(
                      fontSize: 32,
                      color: Colors.white, // Chữ trắng trên nền đen
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}