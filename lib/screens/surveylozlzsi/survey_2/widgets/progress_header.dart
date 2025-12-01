import 'package:flutter/material.dart';

class ProgressHeader extends StatelessWidget {
  const ProgressHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Nút quay lại
          IconButton(
            icon: const Icon(
              Icons.arrow_back,
              color: Colors.black,
              size: 28,
            ),
            onPressed: () {
              Navigator.popUntil(context, ModalRoute.withName('/welcome'));
            },
          ),

          // Cột giữa: Thanh tiến trình + 2/2 (căn giữa)
          Expanded(
            child: Column(
              children: [
                // Thanh tiến trình
                Container(
                  height: 5,
                  width: double.infinity,
                  margin: const EdgeInsets.symmetric(horizontal: 20),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFC735),
                    borderRadius: BorderRadius.circular(60),
                  ),
                ),
                const SizedBox(height: 4),
                const Text(
                  '2/2',
                  style: TextStyle(
                    color: Colors.black54,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),

          // Nút "Bỏ qua"
          TextButton(
            onPressed: () {
              // TODO: xử lý khi nhấn "Bỏ qua"
            },
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
    );
  }
}
