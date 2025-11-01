// Widget cho phép người dùng nhập email hoặc số điện thoại
// Dùng trong màn hình "Quên mật khẩu" hoặc "Xác minh tài khoản"
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../logic/reset_provider.dart'; // Import file chứa state quản lý bằng Riverpod

class ResetForm extends ConsumerWidget {
  const ResetForm({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Lấy giá trị hiện tại của email hoặc số điện thoại từ provider
    final emailOrPhone = ref.watch(emailProvider);

    // Tạo controller cho TextField, hiển thị giá trị ban đầu từ provider
    final controller = TextEditingController(text: emailOrPhone);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start, // Căn trái nội dung
      children: [
        // --- Tiêu đề hướng dẫn nhập thông tin ---
        const Text(
          'Nhập email/sđt nhận mã xác minh',
          style: TextStyle(
            fontSize: 20,
            fontFamily: 'SF Pro Rounded',
            fontWeight: FontWeight.w500, // In đậm vừa phải
          ),
        ),

        const SizedBox(height: 12), // Khoảng cách giữa tiêu đề và ô nhập

        // --- Ô nhập email / số điện thoại ---
        Container(
          decoration: BoxDecoration(
            color: const Color(0xFFEBEBEB), // Màu nền xám nhạt
            borderRadius: BorderRadius.circular(50), // Bo tròn góc
            border: Border.all(color: Colors.black.withOpacity(0.4)), // Viền mờ
          ),
          child: TextField(
            controller: controller, // Liên kết controller để hiển thị giá trị
            // Mỗi khi người dùng thay đổi nội dung, cập nhật lại giá trị trong provider
            onChanged: (value) => ref.read(emailProvider.notifier).state = value,

            // Cấu hình giao diện của ô nhập
            decoration: const InputDecoration(
              contentPadding: EdgeInsets.symmetric(horizontal: 24, vertical: 18), // Lề trong
              border: InputBorder.none, // Ẩn viền mặc định
              hintText: 'Email/SĐT', // Gợi ý hiển thị
              hintStyle: TextStyle(
                color: Colors.black54, // Màu chữ gợi ý mờ
                fontSize: 20,
                fontFamily: 'SF Pro Rounded',
              ),
            ),
          ),
        ),
      ],
    );
  }
}
