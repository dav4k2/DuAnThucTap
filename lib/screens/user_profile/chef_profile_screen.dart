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
import 'package:fontend/screens/user_profile/widgets/review_filter_header.dart';
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
        ? chef.allRecipes
        .where((r) => mealTab == MealTab.tatCa || r.meal == mealTab)
        .toList()
        : <Recipe>[];

    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: isDark ? Brightness.light : Brightness.dark,
          statusBarBrightness: isDark ? Brightness.dark : Brightness.light,
        ),
        child: CustomScrollView(
          controller: _scrollController,
          physics: const BouncingScrollPhysics(),
          slivers: [
            SliverAppBar(
              expandedHeight: 510.h,
              floating: false,
              pinned: true,
              backgroundColor: theme.scaffoldBackgroundColor,
              elevation: 0.5,
              automaticallyImplyLeading: false,
              title: Opacity(
                opacity: _titleOpacity,
                child: Text(
                  chef.name,
                  style: TextStyle(
                    fontSize: 17.sp,
                    fontWeight: FontWeight.w600,
                    color: theme.textTheme.bodyMedium!.color!,
                  ),
                ),
              ),
              centerTitle: true,
              flexibleSpace: FlexibleSpaceBar(
                collapseMode: CollapseMode.parallax,
                background: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Positioned(
                      top: 195.h,
                      left: 0,
                      right: 0,
                      child: Container(
                        width: double.infinity,
                        decoration: ShapeDecoration(
                          color: theme.scaffoldBackgroundColor,
                          shape: RoundedRectangleBorder(
                            borderRadius:
                            BorderRadius.vertical(top: Radius.circular(20.r)),
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

            if (profileTab == ProfileTab.congThuc)
              SliverPersistentHeader(
                pinned: true,
                delegate: _MealFilterDelegate(bgColor: theme.scaffoldBackgroundColor),
              ),

            if (profileTab == ProfileTab.danhGia)
              SliverPersistentHeader(
                pinned: true,
                delegate: _ReviewFilterDelegate(bgColor: theme.scaffoldBackgroundColor),
              ),

            if (profileTab == ProfileTab.congThuc)
              RecipeList(recipes: displayedRecipes),
            if (profileTab == ProfileTab.danhGia) const ReviewTab(),
            if (profileTab == ProfileTab.tieuSu)
              const SliverToBoxAdapter(child: BioTab()),
            if (profileTab == ProfileTab.anh)
              const SliverToBoxAdapter(child: PhotoGrid()),

            SliverToBoxAdapter(child: SizedBox(height: 100.h)),
          ],
        ),
      ),
    );
  }
}

class _MealFilterDelegate extends SliverPersistentHeaderDelegate {
  final Color bgColor;
  const _MealFilterDelegate({required this.bgColor});

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      color: bgColor,
      child: const MealFilter(),
    );
  }

  @override
  double get maxExtent => 54.0;
  @override
  double get minExtent => 54.0;
  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) => false;
}

class _ReviewFilterDelegate extends SliverPersistentHeaderDelegate {
  final Color bgColor;
  const _ReviewFilterDelegate({required this.bgColor});

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      color: bgColor,
      child: const ReviewFilterHeader(),
    );
  }

  @override
  double get maxExtent => 54.0;
  @override
  double get minExtent => 54.0;
  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) => false;
}