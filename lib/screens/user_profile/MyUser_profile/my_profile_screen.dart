// lib/screens/my_profile_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fontend/screens/user_profile/MyUser_profile/widgets/edit_profile_button.dart';
import 'package:fontend/screens/user_profile/MyUser_profile/widgets/my_bio_tab.dart';
import 'package:fontend/screens/user_profile/MyUser_profile/widgets/my_chef_info.dart';
import 'package:fontend/screens/user_profile/MyUser_profile/widgets/my_header_image.dart';
import 'package:fontend/screens/user_profile/MyUser_profile/widgets/my_meal_filter.dart';
import 'package:fontend/screens/user_profile/MyUser_profile/widgets/my_photo_grid.dart';
import 'package:fontend/screens/user_profile/MyUser_profile/widgets/my_profile_avatar.dart';
import 'package:fontend/screens/user_profile/MyUser_profile/widgets/my_profile_tabs.dart';
import 'package:fontend/screens/user_profile/MyUser_profile/widgets/my_recipe_list.dart';
import 'package:fontend/screens/user_profile/MyUser_profile/widgets/my_review_filter_header.dart';
import 'package:fontend/screens/user_profile/MyUser_profile/widgets/my_review_tab.dart';
import 'package:fontend/screens/user_profile/MyUser_profile/widgets/my_stats_section.dart';

import 'logic/my_profile_provider.dart';


class MyProfileScreen extends ConsumerStatefulWidget {
  const MyProfileScreen({super.key});

  @override
  ConsumerState<MyProfileScreen> createState() => _MyProfileScreenState();
}

class _MyProfileScreenState extends ConsumerState<MyProfileScreen>
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
    final chef = ref.watch(myChefProvider);
    final profileTab = ref.watch(myProfileTabProvider);
    final mealTab = ref.watch(myMealTabProvider);

    // Tự động scroll về đầu khi chuyển sang tab Công thức
    if (profileTab == ProfileTab.congThuc) {
      WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToTop());
    }

    return Scaffold(
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness:
          Theme.of(context).brightness == Brightness.dark
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
                    // Nền trắng bo góc trên khi scroll
                    Positioned(
                      top: 195.h,
                      left: 0,
                      right: 0,
                      child: Container(
                        decoration: ShapeDecoration(
                          color: Theme.of(context).scaffoldBackgroundColor,
                          shape: RoundedRectangleBorder(
                            borderRadius:
                            BorderRadius.vertical(top: Radius.circular(20.r)),
                          ),
                        ),
                      ),
                    ),

                    const MyHeaderImage(),
                    const MyProfileAvatar(),
                    MyChefInfo(name: chef.name, title: chef.title),
                    MyStatsSection(
                      recipes: chef.recipes,
                      followers: chef.followers,
                      following: chef.following,
                    ),
                    const EditProfileButton(),     // ← Nút chỉnh sửa
                    const MyProfileTabs(),
                  ],
                ),
              ),
            ),

            // === TAB CÔNG THỨC ===
            if (profileTab == ProfileTab.congThuc)
              const KeepAliveWrapper(
                child: SliverPersistentHeader(
                  pinned: true,
                  delegate: _MyMealFilterDelegate(),
                ),
              ),

            if (profileTab == ProfileTab.congThuc)
              KeepAliveWrapper(
                child: PrimaryScrollController(
                  controller: _recipeScrollController,
                  child: MyRecipeList(
                    key: ValueKey('$profileTab-$mealTab'),
                    recipes: chef.allRecipes
                        .where((r) =>
                    mealTab == MealTab.tatCa || r.meal == mealTab)
                        .toList(),
                  ),
                ),
              ),

            // === TAB ĐÁNH GIÁ ===
            if (profileTab == ProfileTab.danhGia)
              const KeepAliveWrapper(
                child: SliverPersistentHeader(
                  pinned: true,
                  delegate: _MyReviewFilterDelegate(),
                ),
              ),

            if (profileTab == ProfileTab.danhGia)
              const KeepAliveWrapper(child: MyReviewTab()),

            // === TAB TIỂU SỬ ===
            if (profileTab == ProfileTab.tieuSu)
              const KeepAliveWrapper(
                child: SliverToBoxAdapter(child: MyBioTab()),
              ),

            // === TAB ẢNH ===
            if (profileTab == ProfileTab.anh)
              const KeepAliveWrapper(
                child: SliverToBoxAdapter(child: MyPendingRecipesList()),
              ),

            // Khoảng trống cuối
            const SliverToBoxAdapter(child: SizedBox(height: 100)),
          ],
        ),
      ),
    );
  }
}

// ==================== KEEP ALIVE ====================
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

// ==================== DELEGATES ====================
class _MyMealFilterDelegate extends SliverPersistentHeaderDelegate {
  const _MyMealFilterDelegate();

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      color: Theme.of(context).scaffoldBackgroundColor,
      child: const MyMealFilter(),
    );
  }

  @override
  double get maxExtent => 54.0;
  @override
  double get minExtent => 54.0;
  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) => false;
}

class _MyReviewFilterDelegate extends SliverPersistentHeaderDelegate {
  const _MyReviewFilterDelegate();

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      color: Theme.of(context).scaffoldBackgroundColor,
      child: const MyReviewFilterHeader(),
    );
  }

  @override
  double get maxExtent => 54.0;
  @override
  double get minExtent => 54.0;
  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) => false;
}