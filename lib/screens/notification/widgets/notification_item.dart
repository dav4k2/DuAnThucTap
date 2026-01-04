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

  Widget _buildIcon(Color iconColor, Color overlayBackground) {
    switch (data.iconType) {
      case IconType.recipe:
        return Icon(
          Icons.restaurant_menu,
          size: 24,
          color: iconColor,
        );
      case IconType.follow:
        return Stack(
          alignment: Alignment.center,
          children: [
            Icon(
              Icons.person_outline,
              size: 22,
              color: iconColor,
            ),
            Positioned(
              right: -2,
              bottom: -2,
              child: Container(
                padding: const EdgeInsets.all(1),
                decoration: BoxDecoration(
                  color: overlayBackground,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.add_circle,
                  size: 12,
                  color: iconColor,
                ),
              ),
            ),
          ],
        );
      case IconType.comment:
        return Stack(
          clipBehavior: Clip.none,
          children: [
            Icon(
              Icons.chat_bubble_outline,
              size: 22,
              color: iconColor,
            ),
            Positioned(
              right: -4,
              top: -4,
              child: Container(
                width: 10,
                height: 10,
                decoration: BoxDecoration(
                  color: overlayBackground,
                  shape: BoxShape.circle,
                  border: Border.all(color: iconColor, width: 1.5),
                ),
              ),
            ),
          ],
        );
      case IconType.achievement:
        return Transform.rotate(
          angle: -math.pi / 4,
          child: Icon(
            Icons.celebration_outlined,
            size: 24,
            color: iconColor,
          ),
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    // Màu sắc theo theme
    final backgroundColor = isDark ? Colors.grey[900]! : Colors.white;
    final iconColor = isDark ? Colors.white : Colors.black87;
    final textColor = isDark ? Colors.white : Colors.black;
    final secondaryTextColor = isDark ? Colors.grey[400]! : Colors.grey[500]!;
    final borderColor = isDark ? Colors.grey[700]! : const Color(0xFFDDDDDD);
    final overlayBackground = isDark ? Colors.grey[900]! : Colors.white; // nền cho dấu + hoặc chấm nhỏ

    // Màu ripple & highlight
    final splashColor = isDark ? Colors.white.withOpacity(0.2) : Colors.grey.withOpacity(0.2);
    final highlightColor = isDark ? Colors.white.withOpacity(0.1) : Colors.grey.withOpacity(0.1);

    return Material(
      color: backgroundColor,
      child: InkWell(
        onTap: onTap,
        splashColor: splashColor,
        highlightColor: highlightColor,
        child: Ink(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Vòng tròn chứa icon
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: backgroundColor, // cùng nền với item để hòa hợp
                  shape: BoxShape.circle,
                  border: Border.all(color: borderColor, width: 1),
                ),
                child: Center(child: _buildIcon(iconColor, overlayBackground)),
              ),
              const SizedBox(width: 14),
              // Nội dung thông báo
              Expanded(
                child: Text(
                  data.message,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: textColor,
                    height: 1.4,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              // Thời gian
              Text(
                data.time,
                style: TextStyle(
                  fontSize: 12,
                  color: secondaryTextColor,
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