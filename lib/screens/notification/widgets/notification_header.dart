import 'package:flutter/material.dart';

class NotificationHeader extends StatelessWidget {
  const NotificationHeader({
    super.key,
    required this.onMarkRead,
  });

  final VoidCallback onMarkRead;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFFFFC221),
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top, // vùng tai thỏ
      ),
      child: SizedBox(
        height: 56,
        child: Row(
          children: [
            // Nút Back
            IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.black, size: 24),
              onPressed: () => Navigator.pop(context),
            ),

            // Title căn giữa
            const Expanded(
              child: Center(
                child: Text(
                  'Thông báo',
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w600,
                    fontSize: 18,
                  ),
                ),
              ),
            ),

            // Nút Mới 1 – giống iOS
            Padding(
              padding: const EdgeInsets.only(right: 16),
              child: Material(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                child: InkWell(
                  onTap: onMarkRead,
                  borderRadius: BorderRadius.circular(20),
                  splashColor: Colors.black12,      // ripple xám
                  highlightColor: Colors.black12,   // highlight khi giữ
                  child: const Padding(
                    padding:
                    EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    child: Text(
                      'Mới 1',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
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
