import 'package:flutter_riverpod/flutter_riverpod.dart';

class NotificationModel {
  final String message;
  final String time;
  final bool isRead;
  final IconType iconType;

  NotificationModel({
    required this.message,
    required this.time,
    required this.iconType,
    this.isRead = false, // Mặc định là chưa đọc
  });

  NotificationModel copyWith({
    String? message,
    String? time,
    bool? isRead,
    IconType? iconType,
  }) {
    return NotificationModel(
      message: message ?? this.message,
      time: time ?? this.time,
      iconType: iconType ?? this.iconType,
      isRead: isRead ?? this.isRead,
    );
  }
}

enum IconType {
  recipe,
  follow,
  comment,
  achievement,
}

final notificationProvider =
StateNotifierProvider<NotificationController, List<NotificationModel>>((ref) {
  return NotificationController();
});

class NotificationController extends StateNotifier<List<NotificationModel>> {
  NotificationController()
      : super([
    NotificationModel(
      message: "Mr.Dean đã thêm công thức mới",
      time: "1h",
      iconType: IconType.recipe,
      isRead: true, // Đã đọc - nền trắng
    ),
    NotificationModel(
      message: "Soobin đã theo dõi bạn",
      time: "30m",
      iconType: IconType.follow,
      isRead: false, // Chưa đọc - nền xám
    ),
  ]);

  void markAllRead() {
    state = [
      for (final n in state) n.copyWith(isRead: true)
    ];
  }

  void markAsRead(int index) {
    state = [
      for (var i = 0; i < state.length; i++)
        if (i == index) state[i].copyWith(isRead: true) else state[i]
    ];
  }
}

final notificationProviderYesterday =
StateNotifierProvider<NotificationControllerYesterday, List<NotificationModel>>((ref) {
  return NotificationControllerYesterday();
});

class NotificationControllerYesterday extends StateNotifier<List<NotificationModel>> {
  NotificationControllerYesterday()
      : super([
    NotificationModel(
      message: "Mr.Dean đã thêm công thức mới",
      time: "1d",
      iconType: IconType.recipe,
      isRead: true, // Đã đọc
    ),
    NotificationModel(
      message: "Gordon Ramsay đã nhắc đến bạn trong một bình luận",
      time: "1d",
      iconType: IconType.comment,
      isRead: true, // Đã đọc
    ),
    NotificationModel(
      message: "Công thức của bạn đã lọt vào top 10 công thức nổi bật nhất",
      time: "1d",
      iconType: IconType.achievement,
      isRead: true, // Đã đọc
    ),
  ]);

  void markAllRead() {
    state = [
      for (final n in state) n.copyWith(isRead: true)
    ];
  }

  void markAsRead(int index) {
    state = [
      for (var i = 0; i < state.length; i++)
        if (i == index) state[i].copyWith(isRead: true) else state[i]
    ];
  }
}