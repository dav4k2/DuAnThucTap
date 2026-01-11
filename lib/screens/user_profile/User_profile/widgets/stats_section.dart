import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../MyUser_profile/logic/follower_provider.dart';
import '../../MyUser_profile/logic/my_profile_provider.dart';

class StatsSection extends ConsumerWidget {
  final String userId;

  const StatsSection({
    super.key,
    required this.userId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final recipeCountAsync = ref.watch(recipeCountProvider(userId));
    final followersAsync = ref.watch(followersListProvider(userId));
    final followingAsync = ref.watch(followingListProvider(userId));

    final textColor = Theme.of(context).textTheme.bodyMedium?.color ?? Colors.black;
    final secondaryColor = textColor.withOpacity(0.6);
    final dividerColor = textColor.withOpacity(0.15);

    return Container(
      margin: EdgeInsets.only(top: 370.h),
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          // 1. Số công thức
          recipeCountAsync.when(
            data: (count) => _buildStatItem('$count', 'Số công thức', textColor, secondaryColor),
            loading: () => _buildStatItem('-', 'Số công thức', textColor, secondaryColor),
            error: (_,__) => _buildStatItem('0', 'Số công thức', textColor, secondaryColor),
          ),

          _buildDivider(dividerColor),

          // 2. Số Follower (Người theo dõi User B)
          followersAsync.when(
            data: (list) => _buildStatItem('${list.length}', 'Follower', textColor, secondaryColor),
            loading: () => _buildStatItem('-', 'Follower', textColor, secondaryColor),
            error: (_,__) => _buildStatItem('0', 'Follower', textColor, secondaryColor),
          ),

          _buildDivider(dividerColor),

          // 3. Số Đang follow (User B đang follow ai)
          followingAsync.when(
            data: (list) => _buildStatItem('${list.length}', 'Đã follow', textColor, secondaryColor),
            loading: () => _buildStatItem('-', 'Đã follow', textColor, secondaryColor),
            error: (_,__) => _buildStatItem('0', 'Đã follow', textColor, secondaryColor),
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(String value, String label, Color textColor, Color secondaryColor) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          value,
          style: TextStyle(fontSize: 24.sp, fontWeight: FontWeight.w600, color: textColor),
        ),
        SizedBox(height: 4.h),
        Text(label, style: TextStyle(color: secondaryColor, fontSize: 14.sp)),
      ],
    );
  }

  Widget _buildDivider(Color color) {
    return Container(height: 30.h, width: 1.w, color: color);
  }
}