// lib/widgets/review_tab.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../logic/chef_provider.dart';

enum ReviewFilter { newest, oldest, all }

final reviewFilterProvider = StateProvider<ReviewFilter>((_) => ReviewFilter.newest);

class ReviewTab extends ConsumerWidget {
  const ReviewTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final filter = ref.watch(reviewFilterProvider);
    final notifier = ref.read(reviewFilterProvider.notifier);

    // Dữ liệu mẫu (sẽ lấy từ API sau)
    final reviews = _getFilteredReviews(filter);

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 16.h),

          // === TIÊU ĐỀ + SỐ LƯỢNG + VIẾT ĐÁNH GIÁ ===
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text.rich(
                TextSpan(
                  children: [
                    TextSpan(
                      text: 'Đánh giá',
                      style: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.w400, height: 1.47),
                    ),
                    TextSpan(
                      text: ' (4)',
                      style: TextStyle(
                        fontSize: 15.sp,
                        fontWeight: FontWeight.w400,
                        color: Colors.black.withOpacity(0.6),
                        height: 1.47,
                      ),
                    ),
                  ],
                ),
              ),
              GestureDetector(
                onTap: () {
                  // TODO: Mở form viết đánh giá
                },
                child: Text(
                  'Viết đánh giá',
                  style: TextStyle(
                    fontSize: 15.sp,
                    fontWeight: FontWeight.w400,
                    color: const Color(0xFFFFB901),
                    height: 1.47,
                  ),
                ),
              ),
            ],
          ),

          SizedBox(height: 16.h),

          // === BỘ LỌC ===
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _filterChip('Mới nhất', ReviewFilter.newest, filter == ReviewFilter.newest, notifier),
                SizedBox(width: 8.w),
                _filterChip('Cũ nhất', ReviewFilter.oldest, filter == ReviewFilter.oldest, notifier),
                SizedBox(width: 8.w),
                _filterChip('Tất cả', ReviewFilter.all, filter == ReviewFilter.all, notifier),
              ],
            ),
          ),

          SizedBox(height: 24.h),

          // === DANH SÁCH BÌNH LUẬN ===
          Expanded(
            child: ListView.separated(
              padding: EdgeInsets.zero,
              itemCount: reviews.length,
              separatorBuilder: (_, __) => SizedBox(height: 16.h),
              itemBuilder: (context, index) {
                final review = reviews[index];
                return _reviewItem(review);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _filterChip(String label, ReviewFilter value, bool active, StateController<ReviewFilter> notifier) {
    return GestureDetector(
      onTap: () => notifier.state = value,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 6.h),
        decoration: BoxDecoration(
          color: active ? const Color(0xFFFFB901) : const Color(0xFFD9D9D9),
          borderRadius: BorderRadius.circular(20.r),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 14.sp,
            fontWeight: FontWeight.w400,
            color: Colors.black,
            height: 1.57,
          ),
        ),
      ),
    );
  }

  Widget _reviewItem(Review review) {
    return Container(
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
              // Avatar
              CircleAvatar(
                radius: 22.5.r,
                backgroundColor: Colors.grey[300],
                backgroundImage: NetworkImage(review.avatar),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      review.name,
                      style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w700, height: 1.38),
                    ),
                    SizedBox(height: 2.h),
                    Row(
                      children: [
                        ...List.generate(5, (i) => Icon(
                          Icons.star,
                          size: 16.sp,
                          color: i < review.rating ? Colors.amber : Colors.grey,
                        )),
                        SizedBox(width: 8.w),
                        Text(
                          '${review.rating}',
                          style: TextStyle(fontSize: 15.sp, color: Colors.black.withOpacity(0.6)),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Text(
                review.timeAgo,
                style: TextStyle(fontSize: 13.sp, color: Colors.black.withOpacity(0.6), height: 1.69),
              ),
            ],
          ),
          SizedBox(height: 8.h),
          Text(
            review.comment,
            style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w400, height: 1.38),
          ),
        ],
      ),
    );
  }

  List<Review> _getFilteredReviews(ReviewFilter filter) {
    final allReviews = [
      Review(
        name: 'Gordon Ramsay',
        comment: 'Một đầu bếp tuyệt vời!!',
        rating: 5,
        timeAgo: '1 tuần trước',
        avatar: 'https://placehold.co/45x45',
      ),
      Review(
        name: 'Remy',
        comment: 'Ông là idol của tôi',
        rating: 5,
        timeAgo: '2 ngày trước',
        avatar: 'https://placehold.co/45x45',
      ),
      Review(
        name: 'User A',
        comment: 'Công thức dễ làm, cảm ơn chef!',
        rating: 4,
        timeAgo: '3 ngày trước',
        avatar: 'https://placehold.co/45x45',
      ),
      Review(
        name: 'User B',
        comment: 'Tuyệt vời! Gà rán ngon nhất từng ăn.',
        rating: 5,
        timeAgo: '1 tháng trước',
        avatar: 'https://placehold.co/45x45',
      ),
      Review(
        name: 'Gordon Ramsay',
        comment: 'Một đầu bếp tuyệt vời!!',
        rating: 5,
        timeAgo: '1 tuần trước',
        avatar: 'https://placehold.co/45x45',
      ),
      Review(
        name: 'Remy',
        comment: 'Ông là idol của tôi',
        rating: 5,
        timeAgo: '2 ngày trước',
        avatar: 'https://placehold.co/45x45',
      ),
      Review(
        name: 'User A',
        comment: 'Công thức dễ làm, cảm ơn chef!',
        rating: 4,
        timeAgo: '3 ngày trước',
        avatar: 'https://placehold.co/45x45',
      ),
      Review(
        name: 'User B',
        comment: 'Tuyệt vời! Gà rán ngon nhất từng ăn.',
        rating: 5,
        timeAgo: '1 tháng trước',
        avatar: 'https://placehold.co/45x45',
      ),
      Review(
        name: 'Gordon Ramsay',
        comment: 'Một đầu bếp tuyệt vời!!',
        rating: 5,
        timeAgo: '1 tuần trước',
        avatar: 'https://placehold.co/45x45',
      ),
      Review(
        name: 'Remy',
        comment: 'Ông là idol của tôi',
        rating: 5,
        timeAgo: '2 ngày trước',
        avatar: 'https://placehold.co/45x45',
      ),
      Review(
        name: 'User A',
        comment: 'Công thức dễ làm, cảm ơn chef!',
        rating: 4,
        timeAgo: '3 ngày trước',
        avatar: 'https://placehold.co/45x45',
      ),
      Review(
        name: 'User B',
        comment: 'Tuyệt vời! Gà rán ngon nhất từng ăn.',
        rating: 5,
        timeAgo: '1 tháng trước',
        avatar: 'https://placehold.co/45x45',
      ),
      Review(
        name: 'Gordon Ramsay',
        comment: 'Một đầu bếp tuyệt vời!!',
        rating: 5,
        timeAgo: '1 tuần trước',
        avatar: 'https://placehold.co/45x45',
      ),
      Review(
        name: 'Remy',
        comment: 'Ông là idol của tôi',
        rating: 5,
        timeAgo: '2 ngày trước',
        avatar: 'https://placehold.co/45x45',
      ),
      Review(
        name: 'User A',
        comment: 'Công thức dễ làm, cảm ơn chef!',
        rating: 4,
        timeAgo: '3 ngày trước',
        avatar: 'https://placehold.co/45x45',
      ),
      Review(
        name: 'User B',
        comment: 'Tuyệt vời! Gà rán ngon nhất từng ăn.',
        rating: 5,
        timeAgo: '1 tháng trước',
        avatar: 'https://placehold.co/45x45',
      ),
    ];

    switch (filter) {
      case ReviewFilter.newest:
        return allReviews..sort((a, b) => b.timeAgo.compareTo(a.timeAgo));
      case ReviewFilter.oldest:
        return allReviews..sort((a, b) => a.timeAgo.compareTo(b.timeAgo));
      case ReviewFilter.all:
      default:
        return allReviews;
    }
  }
}

// === MODEL REVIEW ===
class Review {
  final String name;
  final String comment;
  final int rating;
  final String timeAgo;
  final String avatar;

  Review({
    required this.name,
    required this.comment,
    required this.rating,
    required this.timeAgo,
    required this.avatar,
  });
}