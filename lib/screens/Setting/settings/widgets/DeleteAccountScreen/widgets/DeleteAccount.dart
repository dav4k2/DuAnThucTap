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
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    final backgroundColor = isDarkMode ? Colors.grey[900] : Colors.white;
    final borderColor = isDarkMode ? Colors.white24 : Colors.black26;
    final dragBarColor = isDarkMode ? Colors.white54 : Colors.black.withOpacity(0.5);
    final titleColor = isDarkMode ? Colors.white : Colors.black;
    final subtitleColor = isDarkMode ? Colors.white70 : Colors.black54;
    final cancelButtonColor = isDarkMode ? Colors.white24 : const Color(0x2B8F8F8F);
    final cancelTextColor = isDarkMode ? Colors.white70 : Colors.black54;

    return Container(
      width: double.infinity,
      height: 309,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
        border: Border(
          top: BorderSide(color: borderColor, width: 1),
          left: BorderSide(color: borderColor, width: 1),
          right: BorderSide(color: borderColor, width: 1),
        ),
        boxShadow: const [
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
                color: dragBarColor,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),

          // Tiêu đề
          Positioned(
            top: 35,
            left: 16,
            right: 16,
            child: Text(
              'Bạn có chắc muốn xóa tài khoản?',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: titleColor,
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
            child: Container(height: 1, color: borderColor.withOpacity(0.45)),
          ),

          // Câu buồn :(
          Positioned(
            top: 114,
            left: 40,
            right: 40,
            child: Text(
              'Chúng tôi rất buồn khi thấy bạn rời đi :’(',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: subtitleColor,
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
                  color: cancelButtonColor,
                  borderRadius: BorderRadius.circular(50),
                ),
                alignment: Alignment.center,
                child: Text(
                  'Hủy',
                  style: TextStyle(
                    color: cancelTextColor,
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
