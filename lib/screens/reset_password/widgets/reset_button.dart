// Widget nút "Xác nhận" — dùng để gửi yêu cầu xác minh hoặc chuyển sang bước tiếp theo
import 'package:flutter/material.dart';

class ResetButton extends StatelessWidget {
  // Hàm callback khi người dùng nhấn nút
  final VoidCallback onPressed;

  const ResetButton({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      // Bắt sự kiện chạm (tap) và gọi hàm onPressed
      onTap: onPressed,

      // Giao diện nút bấm
      child: Container(
        width: double.infinity, // Chiều rộng toàn phần (kéo dài hết màn hình)
        height: 65, // Chiều cao nút
        alignment: Alignment.center, // Căn giữa nội dung (chữ)
        margin: const EdgeInsets.symmetric(vertical: 32), // Khoảng cách trên & dưới nút

        // Trang trí giao diện nút
        decoration: BoxDecoration(
          color: Colors.amberAccent, // Màu nền vàng nhạt (amber)
          borderRadius: BorderRadius.circular(50), // Bo tròn viền nút
        ),

        // Chữ hiển thị trong nút
        child: const Text(
          'Xác nhận', // Nội dung nút
          style: TextStyle(
            color: Colors.black, // Màu chữ đen
            fontSize: 24, // Cỡ chữ lớn
            fontFamily: 'SF Pro Rounded', // Font chữ tròn (giống iOS)
            fontWeight: FontWeight.w700, // In đậm
          ),
        ),
      ),
    );
  }
}
