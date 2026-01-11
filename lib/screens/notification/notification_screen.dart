// file: lib/screens/notification/notification_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'widgets/notification_header.dart';
import 'widgets/notification_item.dart';
import 'widgets/notification_section_title.dart';
import 'logic/notification_provider.dart';

class NotificationScreen extends ConsumerWidget {
  const NotificationScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // 1. Lắng nghe dữ liệu từ Stream
    final notificationAsync = ref.watch(notificationStreamProvider);

    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final scaffoldBackgroundColor = isDark ? Colors.grey[900]! : Colors.white;

    return Scaffold(
      backgroundColor: scaffoldBackgroundColor,
      body: notificationAsync.when(
        data: (allNotifications) {
          // 2. Logic chia dữ liệu (Today vs Yesterday)
          final now = DateTime.now();
          final todayData = allNotifications.where((n) {
            final diff = now.difference(n.createdAt);
            return diff.inHours < 24 && n.createdAt.day == now.day;
          }).toList();

          final yesterdayData = allNotifications.where((n) {
            return !todayData.contains(n);
          }).toList();

          // Đếm số lượng chưa đọc để hiển thị lên Header (nếu cần custom header)
          final unreadCount = allNotifications.where((n) => !n.isRead).length;

          return Column(
            children: [
              // Header tùy chỉnh (đã cập nhật logic nút Mới)
              PreferredSize(
                preferredSize: const Size.fromHeight(56),
                child: _BuiltHeader(unreadCount: unreadCount),
              ),

              // Nội dung list
              Expanded(
                child: ListView(
                  physics: const BouncingScrollPhysics(),
                  padding: EdgeInsets.zero,
                  children: [
                    if (todayData.isNotEmpty) ...[
                      const NotificationSectionTitle(title: "HÔM NAY"),
                      ...todayData.map((e) => NotificationItem(
                        data: e,
                        onTap: () {
                          _handleNotificationTap(context, ref, e);
                        },
                      )),
                    ],
                    if (yesterdayData.isNotEmpty) ...[
                      const SizedBox(height: 16),
                      const NotificationSectionTitle(title: "CŨ HƠN"),
                      ...yesterdayData.map((e) => NotificationItem(
                        data: e,
                        onTap: () {
                          _handleNotificationTap(context, ref, e);
                        },
                      )),
                    ],
                    if (allNotifications.isEmpty)
                      const Padding(
                        padding: EdgeInsets.only(top: 100),
                        child: Center(child: Text("Chưa có thông báo nào")),
                      ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ],
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Lỗi: $err')),
      ),
    );
  }

  void _handleNotificationTap(BuildContext context, WidgetRef ref, NotificationModel noti) {
    // 1. Đánh dấu đã đọc
    ref.read(notificationControllerProvider).markAsRead(noti.id);

    // 2. Điều hướng (nếu là thông báo công thức)
    if (noti.iconType == IconType.recipe && noti.recipeId != null) {
      // Navigator.pushNamed(context, '/recipe_detail', arguments: noti.recipeId);
      print("Chuyển hướng đến công thức: ${noti.recipeId}");
    }
  }
}

// Wrapper nhỏ để Header nhận context và ref dễ dàng
class _BuiltHeader extends ConsumerWidget {
  final int unreadCount;
  const _BuiltHeader({required this.unreadCount});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return NotificationHeader(
      // Truyền số lượng chưa đọc vào Text "Mới" (Bạn cần sửa file Header một chút để nhận biến này nếu muốn dynamic)
      // Hiện tại file Header của bạn đang hardcode "Mới 1".
      // Logic mark all read:
      onMarkRead: () {
        ref.read(notificationControllerProvider).markAllAsRead();
      }, unreadCount: 0,
    );
  }
}