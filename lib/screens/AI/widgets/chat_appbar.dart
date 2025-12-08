// lib/screens/chat/widgets/chat_appbar.dart

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ChatAppBar extends StatelessWidget implements PreferredSizeWidget {
  final bool isDark;
  final VoidCallback onNewChat;

  const ChatAppBar({
    Key? key,
    required this.isDark,
    required this.onNewChat,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final textColor = isDark ? Colors.white : Colors.black87;
    final bgColor = isDark ? const Color(0xFF121212) : Colors.white;

    return AppBar(
      title: Text(
        'Chef AI',
        style: TextStyle(
          color: textColor,
          fontSize: 18.sp,
          fontWeight: FontWeight.bold,
        ),
      ),
      centerTitle: true,
      backgroundColor: bgColor,
      elevation: 0,

      // ===== BÊN TRÁI: BACK + MENU (nằm cạnh nhau) =====
      leading: Row(
        children: [
          // Nút Back
          IconButton(
            icon: Icon(Icons.arrow_back, color: textColor),
            onPressed: () => Navigator.of(context).pop(),
            tooltip: 'Quay lại',
          ),
          // Nút Menu (Drawer)
          Builder(
            builder: (context) => IconButton(
              icon: Icon(Icons.menu, color: textColor),
              onPressed: () => Scaffold.of(context).openDrawer(),
              tooltip: 'Lịch sử hội thoại',
            ),
          ),
        ],
      ),

      // Để Row không bị tràn ra ngoài leading (44x56), ta override leadingWidth
      leadingWidth: 96.w, // 48 (back) + 48 (menu)

      // ===== BÊN PHẢI: Tạo đoạn chat mới =====
      actions: [
        IconButton(
          icon: Icon(Icons.edit_square, color: textColor),
          onPressed: onNewChat,
          tooltip: 'Đoạn chat mới',
        ),
        SizedBox(width: 8.w),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}