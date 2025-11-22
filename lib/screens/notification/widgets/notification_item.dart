import 'package:flutter/material.dart';
import 'dart:math' as math;
import '../logic/notification_provider.dart';

class NotificationItem extends StatelessWidget {
  final NotificationModel data;
  final VoidCallback? onTap;

  const NotificationItem({
    super.key,
    required this.data,
    this.onTap,
  });

  Widget _buildIcon() {
    switch (data.iconType) {
      case IconType.recipe:
        return const Icon(
          Icons.restaurant_menu,
          size: 24,
          color: Colors.black87,
        );
      case IconType.follow:
        return Stack(
          alignment: Alignment.center,
          children: [
            const Icon(
              Icons.person_outline,
              size: 22,
              color: Colors.black87,
            ),
            Positioned(
              right: -2,
              bottom: -2,
              child: Container(
                padding: const EdgeInsets.all(1),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.add_circle,
                  size: 12,
                  color: Colors.black87,
                ),
              ),
            ),
          ],
        );
      case IconType.comment:
        return Stack(
          clipBehavior: Clip.none,
          children: [
            const Icon(
              Icons.chat_bubble_outline,
              size: 22,
              color: Colors.black87,
            ),
            Positioned(
              right: -4,
              top: -4,
              child: Container(
                width: 10,
                height: 10,
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.black87, width: 1.5),
                ),
              ),
            ),
          ],
        );
      case IconType.achievement:
        return Transform.rotate(
          angle: -math.pi / 4,
          child: const Icon(
            Icons.celebration_outlined,
            size: 24,
            color: Colors.black87,
          ),
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white, // ❗ BỎ MÀU XÁM HARD-CODE
      child: InkWell(
        onTap: onTap,
        splashColor: Colors.grey.withOpacity(0.2),      // Chỉ hiện khi tap
        highlightColor: Colors.grey.withOpacity(0.1),   // Màu giữ khi nhấn
        child: Ink(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  border: Border.all(color: const Color(0xFFDDDDDD), width: 1),
                ),
                child: Center(child: _buildIcon()),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Text(
                  data.message,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: Colors.black,
                    height: 1.4,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Text(
                data.time,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[500],
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
