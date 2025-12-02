// lib/screens/delete_account/widgets/delete_account_bottom_sheet.dart

import 'package:flutter/material.dart';

class DeleteAccountBottomSheet extends StatelessWidget {
  final VoidCallback onConfirm;

  const DeleteAccountBottomSheet({
    super.key,
    required this.onConfirm,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 309,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
        border: Border(
          top: BorderSide(color: Colors.black26, width: 1),
          left: BorderSide(color: Colors.black26, width: 1),
          right: BorderSide(color: Colors.black26, width: 1),
        ),
        boxShadow: [
          BoxShadow(
            color: Color(0x3F000000),
            blurRadius: 4,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Stack(
        children: [
          // Thanh kéo
          Positioned(
            top: 10,
            left: MediaQuery.of(context).size.width / 2 - 61,
            child: Container(
              width: 122,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.5),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),

          // Tiêu đề
          const Positioned(
            top: 35,
            left: 16,
            right: 16,
            child: Text(
              'Bạn có chắc muốn xóa tài khoản?',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.black,
                fontSize: 22,
                fontFamily: 'SF Pro',
                fontWeight: FontWeight.w600,
                height: 1.36,
              ),
            ),
          ),

          // Dòng phân cách
          Positioned(
            top: 94,
            left: 0,
            right: 0,
            child: Container(height: 1, color: Colors.black12),
          ),

          // Câu buồn :(
          const Positioned(
            top: 114,
            left: 40,
            right: 40,
            child: Text(
              'Chúng tôi rất buồn khi thấy bạn rời đi :’(',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.black54,
                fontSize: 22,
                fontFamily: 'SF Pro',
                fontWeight: FontWeight.w400,
                height: 1.18,
              ),
            ),
          ),

          // Nút Hủy
          Positioned(
            top: 200,
            left: 26,
            child: GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Container(
                width: 169,
                height: 58,
                decoration: BoxDecoration(
                  color: const Color(0x2B8F8F8F),
                  borderRadius: BorderRadius.circular(50),
                ),
                alignment: Alignment.center,
                child: const Text(
                  'Hủy',
                  style: TextStyle(
                    color: Colors.black54,
                    fontSize: 22,
                    fontFamily: 'SF Pro',
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ),

          // Nút Xóa (màu đỏ)
          Positioned(
            top: 200,
            right: 26,
            child: GestureDetector(
              onTap: () {
                Navigator.pop(context); // Đóng bottom sheet trước
                onConfirm();            // Sau đó mới thực hiện xóa thật
              },
              child: Container(
                width: 169,
                height: 58,
                decoration: BoxDecoration(
                  color: const Color(0xFFFF5959),
                  borderRadius: BorderRadius.circular(50),
                ),
                alignment: Alignment.center,
                child: const Text(
                  'Xóa tài khoản',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontFamily: 'SF Pro',
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}