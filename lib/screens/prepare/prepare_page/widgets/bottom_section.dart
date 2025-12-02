import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Nút Đã xong
                GestureDetector(
                  onTap: () {
                    ref.read(prepareStateProvider.notifier).state = true;
                  },
                  child: Container(
                    width: 229,
                    height: 66,
                    decoration: BoxDecoration(
                      color: const Color(0xFF21DB53),
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: const Center(
                      child: Text(
                        "Đã xong",
                        style: TextStyle(
                          fontSize: 32,
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                ),

                const SizedBox(width: 15),

                // Nút chuyển trang (icon trắng không nền)
                GestureDetector(
                  onTap: () {
                    // TODO: chuyển sang màn tiếp theo tại đây
                  },
                  child: const Icon(
                    Icons.arrow_forward_ios,
                    color: Colors.black,
                    size: 40,
                  ),
                ),
              ],
            ),

            if (done)
              const Padding(
                padding: EdgeInsets.only(top: 12),
                child: Text(
                  "✔ Hoàn thành!",
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
              )
          ],
        ),
      ),
    );
  }
}
