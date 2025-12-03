// lib/widgets/my_review_tab.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../theme/theme_provider.dart';
import '../logic/my_profile_provider.dart';


class MyReviewTab extends ConsumerWidget {
  const MyReviewTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final reviews = ref.watch(myFilteredReviewsProvider);
    final totalReviews = ref.read(myChefProvider).allReviews.length;

    final isDark = ref.watch(themeProvider); //
    final textColor = isDark ? Colors.white : Colors.black;
    final subText = isDark ? Colors.white70 : Colors.black.withOpacity(0.6);
    final cardColor = isDark ? const Color(0xFF1E1E1E) : Colors.grey[100];

    return SliverList(
      delegate: SliverChildBuilderDelegate(
            (context, index) {
          if (index == 0) {
            return _buildHeader(totalReviews, textColor, subText);
          }

          final review = reviews[index - 1];
          return Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: _reviewItem(review, cardColor!, textColor, subText),
          );
        },
        childCount: reviews.length + 1,
      ),
    );
  }

  // ===========================
  // HEADER
  // ===========================
  Widget _buildHeader(int totalReviews, Color textColor, Color subText) {
    return Padding(
      padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 8.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text.rich(
            TextSpan(
              children: [
                TextSpan(
                  text: 'Đánh giá',
                  style: TextStyle(
                    fontSize: 15.sp,
                    color: textColor,
                  ),
                ),
                TextSpan(
                  text: ' ($totalReviews)',
                  style: TextStyle(
                    fontSize: 15.sp,
                    color: subText,
                  ),
                ),
              ],
            ),
          ),
          GestureDetector(
            onTap: () {},
            child: Text(
              'Viết đánh giá',
              style: TextStyle(
                fontSize: 15.sp,
                color: const Color(0xFFFFB901),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ===========================
  // REVIEW ITEM
  // ===========================
  Widget _reviewItem(
      Review review,
      Color cardColor,
      Color textColor,
      Color subText,
      ) {
    return Container(
      margin: EdgeInsets.only(bottom: 16.h),
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: cardColor,
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
                backgroundColor: Colors.grey[300],
              ),
              SizedBox(width: 12.w),

              // ===== NAME + RATING =====
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      review.name,
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w700,
                        color: textColor,
                      ),
                    ),
                    Row(
                      children: [
                        ...List.generate(
                          5,
                              (i) => Icon(
                            Icons.star,
                            size: 16.sp,
                            color: i < review.rating
                                ? Colors.amber
                                : Colors.grey,
                          ),
                        ),
                        SizedBox(width: 8.w),
                        Text(
                          '${review.rating}',
                          style: TextStyle(
                            fontSize: 15.sp,
                            color: subText,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // TIME AGO
              Text(
                review.timeAgo,
                style: TextStyle(
                  fontSize: 13.sp,
                  color: subText,
                ),
              ),
            ],
          ),

          SizedBox(height: 8.h),

          // COMMENT
          Text(
            review.comment,
            style: TextStyle(
              fontSize: 16.sp,
              color: textColor,
            ),
          ),
        ],
      ),
    );
  }
}
