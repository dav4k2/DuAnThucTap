// lib/screens/search/widgets/search_results_tabs.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'recipe_card.dart';
import 'chef_card.dart'; // ← Đảm bảo import đúng

class SearchResultsTabs extends StatelessWidget {
  final TabController tabController;
  const SearchResultsTabs({super.key, required this.tabController});

  @override
  Widget build(BuildContext context) {
    return TabBarView(
      controller: tabController,
      children: [
        // TAB CÔNG THỨC
        ListView(
          padding: EdgeInsets.all(20.w),
          children: [
            RecipeCard(
              title: 'Bò Sốt Vang',
              time: '60 phút',
              level: 'Trung bình',
              author: 'Hoàng Sơn',
              rating: '4.8 (1k+ Đánh giá)',
              imagePath: 'image/garan.png', // sửa thành ảnh thật
              onTap: () {},
            ),
            SizedBox(height: 20.h),
            RecipeCard(
              title: 'Phở Tái Nạm Gầu',
              time: '120 phút',
              level: 'Khó',
              author: 'Minh Thư',
              rating: '4.9 (2.3k Đánh giá)',
              imagePath: 'image/garan.png',
              onTap: () {},
            ),
          ],
        ),

        // TAB ĐẦU BẾP – DÙNG CHEFCARD MỚI CÓ ẢNH + FOLLOW THẬT
        ListView(
          padding: EdgeInsets.all(20.w),
          children: [
            ChefCard(
              name: 'Gordon Ramsay',
              recipeCount: '132 công thức',
              avatarPath: 'image/bean.png',
              initiallyFollowing: true,
            ),
            ChefCard(
              name: 'Gordon Freeman',
              recipeCount: '1 công thức',
              avatarPath: 'images/gordon_freeman.png',
              initiallyFollowing: false,
            ),
            ChefCard(
              name: 'Gordon Kentucky',
              recipeCount: '12 công thức',
              avatarPath: 'images/gordon_kentucky.png',
              initiallyFollowing: false,
            ),
          ],
        ),
      ],
    );
  }
}