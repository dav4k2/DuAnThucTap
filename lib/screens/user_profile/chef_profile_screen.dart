// lib/screens/chef_profile_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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

class ChefProfileScreen extends ConsumerStatefulWidget {
  const ChefProfileScreen({super.key});

  @override
  ConsumerState<ChefProfileScreen> createState() => _ChefProfileScreenState();
}

class _ChefProfileScreenState extends ConsumerState<ChefProfileScreen>
    with TickerProviderStateMixin {
  late final ScrollController _scrollController;
  double _titleOpacity = 0.0;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController()..addListener(_updateTitleOpacity);
  }

  void _updateTitleOpacity() {
    const double headerHeight = 550.0;
    const double collapsedHeight = 56.0;
    final double maxScroll = headerHeight - collapsedHeight;
    final offset = _scrollController.offset.clamp(0.0, maxScroll);

    final double triggerPoint = maxScroll * 0.9;
    final double opacity = offset > triggerPoint
        ? ((offset - triggerPoint) / (maxScroll - triggerPoint)).clamp(0.0, 1.0)
        : 0.0;

    if (opacity != _titleOpacity) {
      setState(() => _titleOpacity = opacity);
    }
  }

  @override
  void dispose() {
    _scrollController.removeListener(_updateTitleOpacity);
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final chef = ref.watch(chefProvider);
    final profileTab = ref.watch(profileTabProvider);
    final mealTab = ref.watch(mealTabProvider);
    final displayedRecipes = profileTab == ProfileTab.congThuc
        ? chef.allRecipes.where((r) => mealTab == MealTab.tatCa || r.meal == mealTab).toList()
        : <Recipe>[];

    return Scaffold(
      backgroundColor: Colors.white,
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: const SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.light,
          statusBarBrightness: Brightness.dark,
        ),
        child: CustomScrollView(
          controller: _scrollController,
          physics: const BouncingScrollPhysics(),
          slivers: [
            // === HEADER ===
            SliverAppBar(
              expandedHeight: 480.h,
              floating: false,
              pinned: true,
              backgroundColor: Colors.white,
              elevation: 0.5,
              automaticallyImplyLeading: false,
              title: Opacity(
                opacity: _titleOpacity,
                child: Text(
                  chef.name,
                  style: TextStyle(fontSize: 17.sp, fontWeight: FontWeight.w600, color: Colors.black87),
                ),
              ),
              centerTitle: true,
              flexibleSpace: FlexibleSpaceBar(
                collapseMode: CollapseMode.parallax,
                background: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    // Nền trắng bo góc - tự động co giãn
                    Positioned(
                      top: 195.h,
                      left: 0,
                      right: 0,
                      child: Container(
                        width: double.infinity,
                        decoration: ShapeDecoration(
                          color: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
                          ),
                        ),
                      ),
                    ),
                    const HeaderImage(),
                    const ProfileAvatar(),
                    ChefInfo(name: chef.name, title: chef.title),
                    StatsSection(
                      recipes: chef.recipes,
                      followers: chef.followers,
                      following: chef.following,
                    ),
                    const FollowButton(),
                    const ProfileTabs(),
                  ],
                ),
              ),
            ),

            // === MEAL FILTER – DÍNH CỐ ĐỊNH DƯỚI PROFILE TABS ===
            if (profileTab == ProfileTab.congThuc)
              SliverPersistentHeader(
                pinned: true,
                delegate: _MealFilterDelegate(),
              ),


            // === NỘI DUNG TAB ===
            SliverToBoxAdapter(
              child: Builder(builder: (context) {
                if (profileTab == ProfileTab.congThuc) {
                  return RecipeList(recipes: displayedRecipes, topOffset: 0);
                } else if (profileTab == ProfileTab.tieuSu) {
                  return const BioTab();
                } else if (profileTab == ProfileTab.anh) {
                  return const PhotoGrid();
                } else {
                  return SizedBox(
                    height: MediaQuery.of(context).size.height - 550.h, // trừ header
                    child: const ReviewTab(),
                  );
                }
              }),
            ),

            SliverToBoxAdapter(child: SizedBox(height: 100.h)),
          ],
        ),
      ),
    );
  }
}

// === MEAL FILTER DELEGATE – TỰ ĐO CHIỀU CAO, DÍNH CỐ ĐỊNH ===
class _MealFilterDelegate extends SliverPersistentHeaderDelegate {
  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      color: Colors.white,
      child: const MealFilter(),
    );
  }

  @override
  double get maxExtent => 54.h; // padding 12.h + chip 30.h + padding 12.h

  @override
  double get minExtent => 54.h;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) => false;
}