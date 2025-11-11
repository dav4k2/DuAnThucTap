// lib/screens/chef_profile_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fontend/screens/user_profile/widgets/bio_tab.dart';
import 'package:fontend/screens/user_profile/widgets/chef_info.dart';
import 'package:fontend/screens/user_profile/widgets/follow_button.dart';
import 'package:fontend/screens/user_profile/widgets/header_image.dart';
import 'package:fontend/screens/user_profile/widgets/meal_filter.dart';
import 'package:fontend/screens/user_profile/widgets/photo_grid.dart';
import 'package:fontend/screens/user_profile/widgets/profile_avatar.dart';
import 'package:fontend/screens/user_profile/widgets/profile_tabs.dart';
import 'package:fontend/screens/user_profile/widgets/recipe_list.dart';
import 'package:fontend/screens/user_profile/widgets/review_tab.dart';
import 'package:fontend/screens/user_profile/widgets/stats_section.dart';
import 'logic/chef_provider.dart';

class ChefProfileScreen extends ConsumerWidget {
  const ChefProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final chef = ref.watch(chefProvider);
    final profileTab = ref.watch(profileTabProvider);
    final mealTab = ref.watch(mealTabProvider);
    final displayedRecipes = profileTab == ProfileTab.congThuc
        ? chef.allRecipes.where((r) => mealTab == MealTab.tatCa || r.meal == mealTab).toList()
        : <Recipe>[];

    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            // === HEADER (Stack + Positioned) ===
            SizedBox(
              height: 570.h, // đủ cho header + tab
              child: Stack(
                children: [
                  // Background card trắng
                  Positioned(
                    left: 0,
                    top: 195.h,
                    child: Container(
                      width: 402.w,
                      height: 676.h,
                      decoration: ShapeDecoration(
                        color: Colors.white,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.r)),
                      ),
                    ),
                  ),

                  // Fixed widgets
                  const HeaderImage(),
                  const ProfileAvatar(),
                  ChefInfo(name: chef.name, title: chef.title),
                  StatsSection(recipes: chef.recipes, followers: chef.followers, following: chef.following),
                  const FollowButton(),
                  const ProfileTabs(),
                  if (profileTab == ProfileTab.congThuc) const MealFilter(),



                ],
              ),

            ),


            // === NỘI DUNG TAB (CUỘN CÙNG TRANG) ===
            if (profileTab == ProfileTab.congThuc)
              RecipeList(recipes: displayedRecipes, topOffset: 0) // topOffset = 0 vì không cần Positioned
            else if (profileTab == ProfileTab.tieuSu)
              const BioTab()
            else if (profileTab == ProfileTab.anh)
                const PhotoGrid()
              else if (profileTab == ProfileTab.danhGia)
                  const ReviewTab(),

            // === KHOẢNG TRỐNG DƯỚI ===
            SizedBox(height: 100.h),
          ],
        ),
      ),
    );
  }
}