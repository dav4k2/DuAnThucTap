// Widget hiển thị thanh trạng thái tùy chỉnh (giờ, sóng, wifi, pin)
// Thường dùng để mô phỏng giao diện giống trên điện thoại iPhone
import 'package:flutter/material.dart';

class CustomStatusBar extends StatelessWidget {
  const CustomStatusBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      // Tạo khoảng cách trên, dưới và hai bên cho thanh trạng thái
      padding: const EdgeInsets.only(top: 21, left: 16, right: 16, bottom: 19),

      // Dùng Row để hiển thị giờ bên trái và biểu tượng sóng/wifi/pin bên phải
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween, // Căn hai đầu
        children: [
          // ---- Phần hiển thị giờ ----
          const Text(
            '9:41', // Giờ mẫu (tĩnh)
            style: TextStyle(
              color: Colors.black, // Màu chữ đen
              fontSize: 17,
              fontFamily: 'SF Pro', // Font giống iOS
              fontWeight: FontWeight.w600, // Đậm nhẹ
              height: 1.29, // Giãn dòng
            ),
          ),

          // ---- Phần hiển thị biểu tượng sóng / wifi / pin ----
          Row(
            children: [
              // Biểu tượng khung pin ngoài (hộp pin trống)
              Opacity(
                opacity: 0.35, // Làm mờ một chút để trông nhẹ hơn
                child: Container(
                  width: 25,
                  height: 13,
                  decoration: BoxDecoration(
                    border: Border.all(width: 1, color: Colors.black), // Viền đen
                    borderRadius: BorderRadius.circular(4.3), // Bo góc hộp pin
                  ),
                ),
              ),

              const SizedBox(width: 6), // Khoảng cách giữa khung pin và phần pin đầy

              // Biểu tượng phần pin đầy (thanh nhỏ màu đen)
              Container(
                width: 21,
                height: 9,
                decoration: BoxDecoration(
                  color: Colors.black, // Màu đen tượng trưng cho năng lượng pin
                  borderRadius: BorderRadius.circular(2.5), // Bo nhẹ 4 góc
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
