import 'package:flutter/material.dart';

class NotificationHeader extends StatelessWidget {
  final int unreadCount;

  const NotificationHeader({
    super.key,
    required this.onMarkRead, required this.unreadCount,
  });

  final VoidCallback onMarkRead;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    // Màu nền header – vàng sáng ở light mode, màu tối nổi bật ở dark mode
    final backgroundColor = isDark ? const Color(0xFFFFC221) : const Color(0xFFFFC221);

    // Màu chữ và icon – đen ở light, trắng ở dark
    final textAndIconColor = isDark ? Colors.white : Colors.black;


    // Màu ripple/highlight – nhẹ nhàng phù hợp với theme
    final rippleColor = isDark ? Colors.white24 : Colors.black12;

    return Container(
      color: backgroundColor,
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top, // vùng tai thỏ / notch
      ),
      child: SizedBox(
        height: 56,
        child: Row(
          children: [
            // Nút Back
            IconButton(
              icon: Icon(Icons.arrow_back, color: textAndIconColor, size: 24),
              onPressed: () => Navigator.pop(context),
            ),

            // Title căn giữa
            Expanded(
              child: Center(
                child: Text(
                  'Thông báo',
                  style: TextStyle(
                    color: textAndIconColor,
                    fontWeight: FontWeight.w600,
                    fontSize: 18,
                  ),
                ),
              ),
            ),

            // Nút "Mới 1" – thiết kế giống iOS
            Padding(
              padding: const EdgeInsets.only(right: 16),
              child: Material(
                borderRadius: BorderRadius.circular(20),
                elevation: isDark ? 2 : 0, // thêm chút nổi ở dark mode
                child: InkWell(
                  onTap: onMarkRead,
                  borderRadius: BorderRadius.circular(20),
                  splashColor: rippleColor,
                  highlightColor: rippleColor,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    child: Text(
                      'Mới $unreadCount',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: textAndIconColor,
                        fontSize: 13,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}