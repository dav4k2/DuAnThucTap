import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // Đảm bảo import DateFormat
import '../../Crete_recipe/logic/publish_service.dart';

class AuthorSection2 extends StatelessWidget {
  final String authorId;
  final DateTime? postedDate;
  final double width;

  const AuthorSection2({
    super.key,
    required this.width,
    required this.authorId,
    this.postedDate,
  });

  @override
  Widget build(BuildContext context) {
    final PublishService _service = PublishService();

    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    // Màu sắc theo theme
    final containerBackground = isDark ? Colors.grey[850]! : Colors.white;
    final textColor = isDark ? Colors.white : Colors.black;
    final secondaryTextColor = isDark ? Colors.grey[400]! : Colors.grey;
    final followingButtonBg = isDark ? Colors.grey[700]! : Colors.grey[300]!;
    final followButtonBg = isDark ? Colors.white : Colors.black;
    final followingButtonTextColor = isDark ? Colors.white : Colors.black;
    final followButtonTextColor = isDark ? Colors.black : Colors.white;

    return Container(
      margin: const EdgeInsets.all(20),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: containerBackground,
        borderRadius: BorderRadius.circular(30),
        // Thêm nhẹ shadow để nổi hơn ở dark mode
        boxShadow: isDark
            ? [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 10,
            offset: const Offset(0, 4),
          )
        ]
            : null,
      ),
      child: FutureBuilder<Map<String, dynamic>?>(
        future: _service.getUserInfo(authorId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final userData = snapshot.data;
          final name = userData?['display_name'] ?? 'Đầu bếp'.tr();
          final avatar = userData?['avatar_url'] ?? '';

          return Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Avatar
              ClipOval(
                child: avatar.isNotEmpty
                    ? Image.network(
                  avatar,
                  width: 70,
                  height: 70,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) =>
                      Image.asset(
                        "image/empty_user.jpg",
                        width: 70,
                        height: 70,
                        fit: BoxFit.cover,
                      ),
                )
                    : Image.asset(
                  "image/empty_user.jpg",
                  width: 70,
                  height: 70,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(width: 12),

              // Thông tin tác giả
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: textColor,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      "Thành viên".tr(),
                      style: TextStyle(
                        fontSize: 13,
                        color: secondaryTextColor,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      postedDate != null
                          ? "Đã đăng vào ${DateFormat('dd/MM/yyyy').format(postedDate!)}"
                          : "Ngày đăng không xác định".tr(),
                      style: TextStyle(
                        fontSize: 12,
                        color: secondaryTextColor,
                      ),
                    ),
                  ],
                ),
              ),

              // Nút Theo dõi/Unfollow
              StreamBuilder<bool>(
                stream: _service.isFollowingStream(authorId),
                builder: (context, followSnapshot) {
                  final isFollowing = followSnapshot.data ?? false;

                  return GestureDetector(
                    onTap: () => _service.toggleFollow(authorId),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                      decoration: BoxDecoration(
                        color: isFollowing ? followingButtonBg : followButtonBg,
                        borderRadius: BorderRadius.circular(30),
                        border: isFollowing && isDark
                            ? Border.all(color: Colors.grey[600]!, width: 1)
                            : null, // viền nhẹ ở dark khi đang follow
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            isFollowing ? "Đang theo dõi".tr() : "Theo dõi".tr(),
                            style: TextStyle(
                              color: isFollowing ? followingButtonTextColor : followButtonTextColor,
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(width: 6),
                          Icon(
                            isFollowing ? Icons.check : Icons.person_add_alt_1,
                            color: isFollowing ? followingButtonTextColor : followButtonTextColor,
                            size: 16,
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ],
          );
        },
      ),
    );
  }
}