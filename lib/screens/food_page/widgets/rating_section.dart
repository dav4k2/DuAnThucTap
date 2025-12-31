import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../Crete_recipe/logic/publish_recipe.dart';
import '../../Crete_recipe/logic/publish_service.dart';

class RatingSection extends StatefulWidget {
  final double width;
  final PublishRecipe recipe;
  const RatingSection({super.key, required this.width, required this.recipe});

  @override
  State<RatingSection> createState() => _RatingSectionState();
}

class _RatingSectionState extends State<RatingSection> {
  int _currentRating = 0;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadUserRating(); // Tải đánh giá cũ của người dùng
  }

  Future<void> _loadUserRating() async {
    int rating = await PublishService().getUserRatingForRecipe(
      widget.recipe.authorId!,
      widget.recipe.id,
    );
    if (mounted) {
      setState(() {
        _currentRating = rating;
        _isLoading = false;
      });
    }
  }

  void _updateRating(int starValue) async {
    // Lưu lại điểm cũ để rollback nếu lỗi
    int oldRating = _currentRating;

    setState(() {
      _currentRating = starValue;
    });

    try {
      await PublishService().submitRating(
        widget.recipe.authorId!,
        widget.recipe.id,
        starValue,
      );
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(oldRating == 0 ? "Đã gửi đánh giá!" : "Đã cập nhật đánh giá!")),
        );
      }
    } catch (e) {
      setState(() { _currentRating = oldRating; }); // Rollback nếu lỗi
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Lỗi khi gửi đánh giá. Vui lòng thử lại.")),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ---------------- LEFT: SCORE + STARS ----------------
        Expanded(
          flex: 4,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                "Đánh giá".tr(),
                style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),

              // 2. HIỂN THỊ ĐIỂM: Nếu _currentRating = 0 thì hiện 0, ngược lại hiện số sao
              Text(
                _currentRating == 0 ? "0" : _currentRating.toDouble().toString(),
                style: const TextStyle(fontSize: 42, fontWeight: FontWeight.bold),
              ),

              const SizedBox(height: 4),

              // 3. DANH SÁCH SAO CÓ THỂ TƯƠNG TÁC
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(5, (index) {
                  int starValue = index + 1;
                  return GestureDetector(
                    onTap: () => _updateRating(starValue),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 2),
                      child: Icon(
                        Icons.star,
                        // Nếu index nhỏ hơn điểm hiện tại thì tô vàng, ngược lại màu xám
                        color: index < _currentRating
                            ? const Color(0xFFFFC107)
                            : Colors.grey.shade300,
                        size: 26,
                      ),
                    ),
                  );
                }),
              ),

              const SizedBox(height: 4),

              Text(
                "(25 đánh giá)".tr(),
                style: const TextStyle(color: Colors.grey, fontSize: 14),
              ),
            ],
          ),
        ),

        const SizedBox(width: 15),

        // ---------------- RIGHT: PROGRESS BARS (Giữ nguyên) ----------------
        Expanded(
          flex: 5,
          child: Column(
            children: [
              _buildRatingRow(5, 0.9),
              _buildRatingRow(4, 0.7),
              _buildRatingRow(3, 0.5),
              _buildRatingRow(2, 0.25),
              _buildRatingRow(1, 0.1),
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