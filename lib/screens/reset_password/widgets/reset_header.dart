// Widget hiển thị phần tiêu đề và hướng dẫn nhập Email/SĐT
// Thường được đặt ở đầu màn hình "Quên mật khẩu" hoặc "Xác minh tài khoản"
import 'package:flutter/material.dart';

class ResetHeader extends StatelessWidget {
  const ResetHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      // Sắp xếp các phần tử theo chiều dọc
      children: const [
        // --- Dòng tiêu đề chính ---
        Text(
          'Nhập Email hoặc SĐT \ncủa bạn', // Dấu \n giúp xuống dòng
          textAlign: TextAlign.center, // Căn giữa văn bản
          style: TextStyle(
            color: Colors.black, // Màu chữ đen
            fontSize: 32, // Kích thước chữ lớn
            fontFamily: 'SF Pro', // Font chữ chính
            fontWeight: FontWeight.w600, // In đậm nhẹ
            height: 1.16, // Giãn cách giữa các dòng
          ),
        ),

        // --- Khoảng cách giữa tiêu đề và phần mô tả ---
        SizedBox(height: 12),

        // --- Đoạn mô tả hướng dẫn người dùng ---
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 24), // Thêm lề ngang
          child: Text(
            // Nội dung hướng dẫn chi tiết
            'Nhập Email hoặc số điện thoại bạn đã dùng để đăng ký tài khoản, để nhận mã xác minh cho yêu cầu cập nhật mật khẩu của bạn.',
            textAlign: TextAlign.center, // Căn giữa văn bản
            style: TextStyle(
              color: Colors.black54, // Màu chữ xám nhẹ
              fontSize: 15, // Cỡ chữ nhỏ hơn tiêu đề
              height: 1.47, // Giãn dòng giúp dễ đọc
            ),
          ),
        ),
      ],
    );
  }
}
