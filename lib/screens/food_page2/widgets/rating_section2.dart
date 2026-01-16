import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../Crete_recipe/logic/publish_recipe.dart';
import '../../Crete_recipe/logic/publish_service.dart';

class RatingSection2 extends StatefulWidget {
  final double width;
  final PublishRecipe recipe;
  const RatingSection2({super.key, required this.width, required this.recipe});

  @override
  State<RatingSection2> createState() => _RatingSectionState();
}

class _RatingSectionState extends State<RatingSection2> {
  int _currentRating = 0;
  final user = FirebaseAuth.instance.currentUser; // 👈 Lấy user hiện tại

  @override
  void initState() {
    super.initState();
    _loadUserRating();
  }

  // Tải điểm mà người dùng này đã đánh giá trước đó (nếu có)
  Future<void> _loadUserRating() async {
    int score = await PublishService().getUserRatingForRecipe(
        widget.recipe.authorId!,
        widget.recipe.id
    );
    if (mounted) setState(() => _currentRating = score);
  }

  @override
  Widget build(BuildContext context) {
    // Tính toán tỷ lệ cho các thanh Progress Bar
    final total = widget.recipe.totalRatings == 0 ? 1 : widget.recipe.totalRatings;
    final counts = widget.recipe.ratingCount ?? {};

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ---------------- LEFT: AVATAR + SCORE + STARS ----------------
        Expanded(
          flex: 4,
          child: Column(
            children: [
              // 1. Ảnh đại diện người dùng hiện tại
              FutureBuilder<Map<String, dynamic>?>(
                future: PublishService().getUserInfo(widget.recipe.authorId ?? ''),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CircleAvatar(radius: 30, child: CircularProgressIndicator());
                  }

                  // Lấy URL ảnh từ Firestore dựa trên key 'avatar_url'
                  final avatarUrl = snapshot.data?['avatar_url'] ?? '';

                  return CircleAvatar(
                    radius: 30,
                    backgroundImage: avatarUrl.isNotEmpty
                        ? NetworkImage(avatarUrl)
                        : const AssetImage("image/goldel.png") as ImageProvider,
                  );
                },
              ),
              const SizedBox(height: 8),

              // 2. Điểm trung bình từ Firebase
              Text(
                widget.recipe.averageRating?.toStringAsFixed(1) ?? "0.0",
                style: const TextStyle(fontSize: 42, fontWeight: FontWeight.bold),
              ),

              // 3. Sao tương tác
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(5, (index) {
                  return GestureDetector(
                    onTap: () async {
                      int newScore = index + 1;
                      setState(() => _currentRating = newScore);
                      await PublishService().submitRating(
                          widget.recipe.authorId!,
                          widget.recipe.id,
                          newScore
                      );
                    },
                    child: Icon(
                      Icons.star,
                      color: index < _currentRating ? Colors.amber : Colors.grey.shade300,
                      size: 24,
                    ),
                  );
                }),
              ),
              Text("(${widget.recipe.totalRatings} đánh giá)".tr()),
            ],
          ),
        ),

        const SizedBox(width: 15),

        // ---------------- RIGHT: PROGRESS BARS (Dữ liệu thật) ----------------
        Expanded(
          flex: 5,
          child: Column(
            children: [
              _buildRatingRow(5, (counts["5"] ?? 0) / total),
              _buildRatingRow(4, (counts["4"] ?? 0) / total),
              _buildRatingRow(3, (counts["3"] ?? 0) / total),
              _buildRatingRow(2, (counts["2"] ?? 0) / total),
              _buildRatingRow(1, (counts["1"] ?? 0) / total),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildRatingRow(int star, double percent) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          SizedBox(
            width: 14,
            child: Text(
              star.toString(),
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Stack(
              children: [
                Container(
                  height: 6,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                FractionallySizedBox(
                  widthFactor: percent,
                  child: Container(
                    height: 6,
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFC107),
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}