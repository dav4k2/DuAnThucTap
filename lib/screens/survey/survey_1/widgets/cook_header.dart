import 'package:flutter/material.dart';

class CookingHeader extends StatelessWidget {
  final int currentStep; // ví dụ: 1
  final int totalSteps;  // ví dụ: 2
  final VoidCallback? onSkip; // callback khi bấm "Bỏ qua"

  const CookingHeader({
    super.key,
    this.currentStep = 1,
    this.totalSteps = 2,
    this.onSkip,
  });

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    // Tính độ dài thanh tiến trình theo bước hiện tại
    final progressWidth = (currentStep / totalSteps) * (width * 0.5);

    return SizedBox(
      height: 100, // đủ cao để hiển thị nút back và thanh tiến trình
      child: Stack(
        children: [
          // Nội dung chính
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(width: 45), // chừa chỗ cho nút back nổi
                Expanded(
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      // Thanh nền xám
                      Container(
                        width: width * 0.5,
                        height: 5,
                        decoration: BoxDecoration(
                          color: const Color(0xFFDADADA),
                          borderRadius: BorderRadius.circular(60),
                        ),
                      ),
                      // Thanh vàng (tiến trình)
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Container(
                          width: progressWidth,
                          height: 5,
                          decoration: BoxDecoration(
                            color: const Color(0xFFFFC735),
                            borderRadius: BorderRadius.circular(60),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  '$currentStep/$totalSteps',
                  style: const TextStyle(
                    color: Colors.black54,
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const Spacer(),
                TextButton(
                  onPressed: onSkip,
                  child: const Text(
                    'Bỏ qua',
                    style: TextStyle(
                      color: Colors.black54,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Nút Back nổi
          Positioned(
            top: 50,
            left: 8,
            child: IconButton(
              icon: const Icon(
                Icons.arrow_back,
                color: Colors.black,
                size: 30,
              ),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),
        ],
      ),
    );
  }
}
