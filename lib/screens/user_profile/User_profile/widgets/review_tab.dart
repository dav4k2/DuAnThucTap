// lib/widgets/review_tab.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../logic/chef_provider.dart';

class ReviewTab extends ConsumerWidget {
  const ReviewTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final reviews = ref.watch(filteredReviewsProvider);
    final totalReviews = ref.read(chefProvider).allReviews.length;

    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final titleColor = isDark ? Colors.white : Colors.black;
    final subtitleColor = isDark ? Colors.white.withOpacity(0.6) : Colors.black.withOpacity(0.6);
    final textColor = isDark ? Colors.white : Colors.black;
    final itemBackgroundColor = isDark ? Colors.grey[850] : Colors.grey[100];

    return SliverList(
      delegate: SliverChildBuilderDelegate(
            (context, index) {
          if (index == 0) {
            return _buildHeader(totalReviews, titleColor, subtitleColor);
          }
          final review = reviews[index - 1];
          return Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: _reviewItem(review, textColor, subtitleColor),
          );
        },
        childCount: reviews.length + 1,
      ),
    );
  }

  Widget _buildHeader(int totalReviews, Color titleColor, Color subtitleColor) {
    return Padding(
      padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 8.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text.rich(
            TextSpan(
              children: [
                TextSpan(text: 'Đánh giá', style: TextStyle(fontSize: 15.sp, color: titleColor)),
                TextSpan(
                  text: ' ($totalReviews)',
                  style: TextStyle(fontSize: 15.sp, color: subtitleColor),
                ),
              ],
            ),
          ),
          GestureDetector(
            onTap: () {},
            child: Text(
              'Viết đánh giá',
              style: TextStyle(fontSize: 15.sp, color: const Color(0xFFFFB901)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _reviewItem(Review review, Color textColor, Color subtitleColor, ) {
    return Container(
      margin: EdgeInsets.only(bottom: 16.h),
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 22.5.r,
                backgroundImage: NetworkImage(review.avatar),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      review.name,
                      style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w700, color: textColor),
                    ),
                    Row(
                      children: [
                        ...List.generate(
                          5,
                              (i) => Icon(
                            Icons.star,
                            size: 16.sp,
                            color: i < review.rating ? Colors.amber : Colors.grey,
                          ),
                        ),
                        SizedBox(width: 8.w),
                        Text(
                          '${review.rating}',
                          style: TextStyle(fontSize: 15.sp, color: subtitleColor),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Text(
                review.timeAgo,
                style: TextStyle(fontSize: 13.sp, color: subtitleColor),
              ),
            ],
          ),
          SizedBox(height: 8.h),
          Text(review.comment, style: TextStyle(fontSize: 16.sp, color: textColor)),
        ],
      ),
    );
  }
}