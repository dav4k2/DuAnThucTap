// lib/widgets/my_review_tab.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../logic/my_profile_provider.dart';           // dùng provider của trang cá nhân

class MyReviewTab extends ConsumerWidget {
  const MyReviewTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final reviews = ref.watch(myFilteredReviewsProvider);           // đổi provider
    final totalReviews = ref.read(myChefProvider).allReviews.length; // đổi provider

    return SliverList(
      delegate: SliverChildBuilderDelegate(
            (context, index) {
          // Header (index 0)
          if (index == 0) {
            return _buildHeader(totalReviews);
          }

          final review = reviews[index - 1];
          return Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: _reviewItem(review),
          );
        },
        childCount: reviews.length + 1, // +1 vì có header
      ),
    );
  }

  Widget _buildHeader(int totalReviews) {
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
                  style: TextStyle(fontSize: 15.sp),
                ),
                TextSpan(
                  text: ' ($totalReviews)',
                  style: TextStyle(
                    fontSize: 15.sp,
                    color: Colors.black.withOpacity(0.6),
                  ),
                ),
              ],
            ),
          ),
          GestureDetector(
            onTap: () {
              // TODO: Mở dialog viết đánh giá (hoặc trang riêng)
              // Giữ nguyên như cũ, bạn có thể thêm chức năng sau
            },
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

  Widget _reviewItem(Review review) {
    return Container(
      margin: EdgeInsets.only(bottom: 16.h),
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: Colors.grey[100],
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
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      review.name,
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w700,
                      ),
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
                          style: TextStyle(
                            fontSize: 15.sp,
                            color: Colors.black.withOpacity(0.6),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Text(
                review.timeAgo,
                style: TextStyle(
                  fontSize: 13.sp,
                  color: Colors.black.withOpacity(0.6),
                ),
              ),
            ],
          ),
          SizedBox(height: 8.h),
          Text(
            review.comment,
            style: TextStyle(fontSize: 16.sp),
          ),
        ],
      ),
    );
  }
}