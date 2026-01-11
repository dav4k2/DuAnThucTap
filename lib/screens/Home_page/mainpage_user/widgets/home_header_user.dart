// lib/screens/home/widgets/home_header_user.dart (hoặc đường dẫn của bạn)
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart'; // 1. Import Riverpod
import 'package:fontend/Service/user_service.dart';
import 'package:fontend/Service/user_model.dart';
import 'package:fontend/screens/notification/notification_screen.dart';
// 2. Import provider vừa tạo ở Bước 1 (sửa đường dẫn cho đúng file của bạn)
import 'package:fontend/screens/notification/logic/notification_provider.dart';

// 3. Đổi thành ConsumerWidget để lắng nghe Provider
class HomeHeader extends ConsumerWidget {
  const HomeHeader({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final textColor = isDark ? Colors.white : Colors.black;

    // Khởi tạo UserService
    final UserService userService = UserService();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: FutureBuilder<UserModel?>(
        future: userService.getUserProfile(),
        builder: (context, snapshot) {
          // Trạng thái đang load dữ liệu user
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator(strokeWidth: 2));
          }

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
                    ? NetworkImage(avatarUrl)
                    : const AssetImage('image/empty_user.jpg') as ImageProvider,
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

              // Nút thông báo (có truyền ref vào để lắng nghe)
              _buildNotificationButton(context, ref),
            ],
          );
        },
      ),
    );
  }

  Widget _buildNotificationButton(BuildContext context, WidgetRef ref) {
    // 4. Lắng nghe số lượng tin chưa đọc
    final unreadCountAsync = ref.watch(unreadNotificationCountProvider);

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const NotificationScreen(),
          ),
        );
      },
      child: Container(
        width: 50,
        height: 50,
        // Dùng Stack để đè Badge lên Container
        child: Stack(
          clipBehavior: Clip.none, // Cho phép badge trồi ra ngoài nếu cần
          alignment: Alignment.center,
          children: [
            // Nền trắng và Icon
            Container(
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
              child: const Icon(Icons.notifications, color: Colors.black, size: 24),
            ),

            // Logic hiển thị chấm đỏ / số lượng
            unreadCountAsync.when(
              data: (count) {
                if (count == 0) return const SizedBox.shrink(); // Không có tin mới -> ẩn

                return Positioned(
                  top: 10,  // Căn chỉnh vị trí dấu đỏ
                  right: 10,
                  child: Container(
                    padding: const EdgeInsets.all(4), // Padding cho chấm đỏ
                    decoration: BoxDecoration(
                      color: Colors.red,
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 1.5), // Viền trắng cho nổi
                    ),
                    constraints: const BoxConstraints(
                      minWidth: 16, // Kích thước tối thiểu
                      minHeight: 16,
                    ),
                    child: Center(
                      child: Text(
                        count > 9 ? '9+' : '$count', // Nếu > 9 thì hiện 9+
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          height: 1, // Fix căn giữa text
                        ),
                      ),
                    ),
                  ),
                );
              },
              loading: () => const SizedBox.shrink(),
              error: (_, __) => const SizedBox.shrink(),
            ),
          ],
        ),
      ),
    );
  }
}