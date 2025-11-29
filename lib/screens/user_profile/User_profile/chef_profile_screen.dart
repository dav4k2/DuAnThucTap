// lib/screens/chef_profile_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fontend/screens/user_profile/User_profile/widgets/bio_tab.dart';
import 'package:fontend/screens/user_profile/User_profile/widgets/chef_info.dart';
import 'package:fontend/screens/user_profile/User_profile/widgets/follow_button.dart';
import 'package:fontend/screens/user_profile/User_profile/widgets/header_image.dart';
import 'package:fontend/screens/user_profile/User_profile/widgets/meal_filter.dart';
import 'package:fontend/screens/user_profile/User_profile/widgets/photo_grid.dart';
import 'package:fontend/screens/user_profile/User_profile/widgets/profile_avatar.dart';
import 'package:fontend/screens/user_profile/User_profile/widgets/profile_tabs.dart';
import 'package:fontend/screens/user_profile/User_profile/widgets/recipe_list.dart';
import 'package:fontend/screens/user_profile/User_profile/widgets/review_filter_header.dart';
import 'package:fontend/screens/user_profile/User_profile/widgets/review_tab.dart';
import 'package:fontend/screens/user_profile/User_profile/widgets/stats_section.dart';


import 'logic/chef_provider.dart';

class ChefProfileScreen extends ConsumerStatefulWidget {
  const ChefProfileScreen({super.key});

  @override
  ConsumerState<ChefProfileScreen> createState() => _ChefProfileScreenState();
}

class _ChefProfileScreenState extends ConsumerState<ChefProfileScreen>
    with TickerProviderStateMixin {
  late final ScrollController _mainScrollController = ScrollController()
    ..addListener(_updateTitleOpacity);

  late final ScrollController _recipeScrollController = ScrollController();

  double _titleOpacity = 0.0;

  void _updateTitleOpacity() {
    const double headerHeight = 550.0;
    const double collapsedHeight = 56.0;
    final double maxScroll = headerHeight - collapsedHeight;
    final double offset = _mainScrollController.offset.clamp(0.0, maxScroll);
    final double triggerPoint = maxScroll * 0.9;
    final double opacity = offset > triggerPoint
        ? ((offset - triggerPoint) / (maxScroll - triggerPoint)).clamp(0.0, 1.0)
        : 0.0;
    if (opacity != _titleOpacity) {
      setState(() => _titleOpacity = opacity);
    }
  }

  void _scrollToTop() {
    if (_recipeScrollController.hasClients) {
      _recipeScrollController.animateTo(
        0,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  @override
  void dispose() {
    _mainScrollController.dispose();
    _recipeScrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final chef = ref.watch(chefProvider);
    final profileTab = ref.watch(profileTabProvider);
    final mealTab = ref.watch(mealTabProvider);

    // GIỮ NGUYÊN LOGIC CỦA BẠN
    if (profileTab == ProfileTab.congThuc) {
      WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToTop());
    }

    return Scaffold(
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Theme.of(context).brightness == Brightness.dark
              ? Brightness.light
              : Brightness.dark,
        ),
        child: CustomScrollView(
          controller: _mainScrollController,
          physics: const BouncingScrollPhysics(),
          slivers: [
            SliverAppBar(
              expandedHeight: 510.h,
              floating: false,
              pinned: true,
              backgroundColor: Theme.of(context).scaffoldBackgroundColor,
              elevation: 0.5,
              automaticallyImplyLeading: false,
              title: Opacity(
                opacity: _titleOpacity,
                child: Text(
                  chef.name,
                  style: TextStyle(fontSize: 17.sp, fontWeight: FontWeight.w600),
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
                        decoration: ShapeDecoration(
                          color: Theme.of(context).scaffoldBackgroundColor,
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
                        following: chef.following),
                    const FollowButton(),
                    const ProfileTabs(),
                  ],
                ),
              ),
            ),

            // SỬA XONG – XÓA const Ở 2 CHỖ NÀY THÔI
            if (profileTab == ProfileTab.congThuc)
              KeepAliveWrapper(
                child: SliverPersistentHeader(
                  pinned: true,
                  delegate: _MealFilterDelegate(),
                ),
              ),

            if (profileTab == ProfileTab.danhGia)
              KeepAliveWrapper(
                child: SliverPersistentHeader(
                  pinned: true,
                  delegate: _ReviewFilterDelegate(),
                ),
              ),

            if (profileTab == ProfileTab.congThuc)
              KeepAliveWrapper(
                child: PrimaryScrollController(
                  controller: _recipeScrollController,
                  child: RecipeList(
                    key: ValueKey('$profileTab-$mealTab'),
                    recipes: chef.allRecipes
                        .where((r) => mealTab == MealTab.tatCa || r.meal == mealTab)
                        .toList(),
                  ),
                ),
              ),

            if (profileTab == ProfileTab.danhGia) const KeepAliveWrapper(child: ReviewTab()),
            if (profileTab == ProfileTab.tieuSu)
              const KeepAliveWrapper(child: SliverToBoxAdapter(child: BioTab())),
            if (profileTab == ProfileTab.anh)
              const KeepAliveWrapper(child: SliverToBoxAdapter(child: PhotoGrid())),

            const SliverToBoxAdapter(child: SizedBox(height: 100)),
          ],
        ),
      ),
    );
  }
}

// KeepAliveWrapper giữ nguyên
class KeepAliveWrapper extends StatefulWidget {
  final Widget child;
  const KeepAliveWrapper({super.key, required this.child});

  @override
  State<KeepAliveWrapper> createState() => _KeepAliveWrapperState();
}

class _KeepAliveWrapperState extends State<KeepAliveWrapper>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return widget.child;
  }
}

// Delegate sửa – bỏ tham số bgColor, lấy từ Theme trực tiếp
class _MealFilterDelegate extends SliverPersistentHeaderDelegate {
  const _MealFilterDelegate();

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      color: Theme.of(context).scaffoldBackgroundColor,
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
  const _ReviewFilterDelegate();

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      color: Theme.of(context).scaffoldBackgroundColor,
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