import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../Crete_recipe/logic/publish_service.dart'; // Đảm bảo đúng đường dẫn

class AuthorSection extends StatelessWidget {
  final String authorId;
  final DateTime? postedDate; // Nên thêm ngày đăng để hiển thị động
  final double width;

  const AuthorSection({
    super.key,
    required this.width,
    required this.authorId,
    this.postedDate,
  });

  @override
  Widget build(BuildContext context) {
    final PublishService _service = PublishService();

    return Container(
      margin: const EdgeInsets.all(20),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
      ),
      child: FutureBuilder<Map<String, dynamic>?>(
        future: _service.getUserInfo(authorId), // Lấy thông tin tác giả
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final userData = snapshot.data;
          final name = snapshot.data?['display_name'] ?? 'Đầu bếp';
          final avatar = snapshot.data?['photo_url'] ?? '';

          return Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Avatar (Sử dụng NetworkImage cho dữ liệu thực)
              ClipOval(
                child: avatar.isNotEmpty
                    ? Image.network(
                  avatar,
                  width: 70,
                  height: 70,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) =>
                      Image.asset("image/goldel.png", width: 70, height: 70),
                )
                    : Image.asset("image/goldel.png", width: 70, height: 70),
              ),

              const SizedBox(width: 12),

              // Thông tin tác giả
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      "Thành viên".tr(),
                      style: const TextStyle(
                        fontSize: 13,
                        color: Colors.grey,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      postedDate != null
                          ? "Đã đăng vào ${DateFormat('dd/MM/yyyy').format(postedDate!)}"
                          : "Ngày đăng không xác định",
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),

              // Nút Theo dõi với Logic Real-time
              StreamBuilder<bool>(
                // Giả định bạn đã thêm hàm isFollowingStream vào PublishService như hướng dẫn trước
                stream: _service.isFollowingStream(authorId),
                builder: (context, followSnapshot) {
                  final isFollowing = followSnapshot.data ?? false;

                  return GestureDetector(
                    onTap: () => _service.toggleFollow(authorId), // Xử lý Follow/Unfollow
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                      decoration: BoxDecoration(
                        color: isFollowing ? Colors.grey[300] : Colors.black,
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: Row(
                        children: [
                          Text(
                            isFollowing ? "Đang theo dõi".tr() : "Theo dõi".tr(),
                            style: TextStyle(
                              color: isFollowing ? Colors.black : Colors.white,
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(width: 6),
                          Icon(
                            isFollowing ? Icons.check : Icons.person_add_alt_1,
                            color: isFollowing ? Colors.black : Colors.white,
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