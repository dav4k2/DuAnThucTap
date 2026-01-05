import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:fontend/Service/user_service.dart'; // Import service
import 'package:fontend/Service/user_model.dart';   // Import model
import 'package:fontend/screens/notification/notification_screen.dart';

class HomeHeader extends StatelessWidget {
  const HomeHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final textColor = isDark ? Colors.white : Colors.black;

    // Khởi tạo UserService
    final UserService userService = UserService();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: FutureBuilder<UserModel?>(
        future: userService.getUserProfile(), // Gọi logic lấy thông tin user
        builder: (context, snapshot) {
          // 1. Trạng thái đang load dữ liệu
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator(strokeWidth: 2));
          }

          // 2. Lấy dữ liệu từ snapshot
          final user = snapshot.data;

          final String displayName = user?.displayName ?? "Người dùng";
          final String? avatarUrl = user?.avatarUrl;

          return Row(
            children: [
              // Avatar người dùng
              CircleAvatar(
                radius: 30,
                backgroundColor: Colors.grey[300],
                backgroundImage: (avatarUrl != null && avatarUrl.isNotEmpty)
                    ? NetworkImage(avatarUrl) // Dùng ảnh từ Cloudinary
                    : const AssetImage('image/avatar.png') as ImageProvider, // Ảnh mặc định
              ),

              const SizedBox(width: 12),

              // Text chào hỏi
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${'Chào buổi sáng'.tr()}, $displayName!',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: textColor,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Nay bạn muốn nấu gì'.tr(),
                      style: TextStyle(
                        fontSize: 16,
                        color: textColor.withOpacity(0.7),
                      ),
                    ),
                  ],
                ),
              ),

              // Nút thông báo
              _buildNotificationButton(context),
            ],
          );
        },
      ),
    );
  }

  // Tách widget nút thông báo cho gọn
  Widget _buildNotificationButton(BuildContext context) {
    return Container(
      width: 50,
      height: 50,
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: IconButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const NotificationScreen(),
            ),
          );
        },
        icon: const Icon(Icons.notifications, color: Colors.black, size: 24),
        padding: EdgeInsets.zero,
      ),
    );
  }
}