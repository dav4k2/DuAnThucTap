import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class RatingSection extends StatelessWidget {
  final double width;
  const RatingSection({super.key, required this.width});

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

              const Text(
                "4.9",
                style: TextStyle(fontSize: 42, fontWeight: FontWeight.bold),
              ),

              const SizedBox(height: 4),

              // Stars
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  5,
                      (index) => const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 2),
                    child: Icon(Icons.star, color: Color(0xFFFFC107), size: 26),
                  ),
                ),
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

        // ---------------- RIGHT: PROGRESS BARS ----------------
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
                      color: Color(0xFFFFC107),
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
