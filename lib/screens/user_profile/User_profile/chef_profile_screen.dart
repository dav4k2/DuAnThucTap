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
  final String userId;

  const ChefProfileScreen({super.key, required this.userId});

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
    final chefAsync = ref.watch(chefDataProvider(widget.userId));
    // Lấy danh sách công thức thực tế của người dùng này
    final recipesAsync = ref.watch(userRecipesProvider(widget.userId));

    final profileTab = ref.watch(profileTabProvider);
    final mealTab = ref.watch(mealTabProvider);
    final mockChefData = ref.watch(chefProvider);

    return chefAsync.when(
      loading: () => const Scaffold(body: Center(child: CircularProgressIndicator())),
      error: (err, stack) => Scaffold(body: Center(child: Text('Lỗi: $err'))),
      data: (user) {
        if (user == null) return const Scaffold(body: Center(child: Text('Không thấy người dùng')));

        return Scaffold(
          body: AnnotatedRegion<SystemUiOverlayStyle>(
            value: SystemUiOverlayStyle(
              statusBarColor: Colors.transparent,
              statusBarIconBrightness: Theme.of(context).brightness == Brightness.dark ? Brightness.light : Brightness.dark,
            ),
            child: CustomScrollView(
              controller: _mainScrollController,
              slivers: [
                SliverAppBar(
                  expandedHeight: 510.h,
                  pinned: true,
                  backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                  automaticallyImplyLeading: true, // Cho phép quay lại trang trước
                  title: Opacity(
                    opacity: _titleOpacity,
                    child: Text(user.displayName ?? 'Ẩn danh'),
                  ),
                  centerTitle: true,
                  flexibleSpace: FlexibleSpaceBar(
                    background: Stack(
                      clipBehavior: Clip.none,
                      children: [
                        Positioned(
                          top: 195.h,
                          left: 0, right: 0,
                          child: Container(
                            height: 400.h,
                            decoration: BoxDecoration(
                              color: Theme.of(context).scaffoldBackgroundColor,
                              borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
                            ),
                          ),
                        ),
                        HeaderImage(imageUrl: user.coverUrl),
                        ProfileAvatar(imageUrl: user.avatarUrl),
                        ChefInfo(
                            name: user.displayName ?? 'Ẩn danh',
                            title: user.cookingLevel ?? 'Thành viên'
                        ),
                        recipesAsync.when(
                          data: (recipes) => StatsSection(
                            userId: user.id,          // Truyền ID của User B
                          ),
                          loading: () => StatsSection(userId: user.id),
                          error: (_, __) => StatsSection(userId: user.id),
                        ),
                        FollowButton(
                          targetUserId: user.id,      // Truyền ID của User B
                          targetUserName: user.displayName ?? "Người dùng",
                        ),
                        const ProfileTabs(),
                      ],
                    ),
                  ),
                ),

                // Logic hiển thị Tabs
                if (profileTab == ProfileTab.congThuc) ...[
                  SliverPersistentHeader(pinned: true, delegate: const _MealFilterDelegate()),
                  recipesAsync.when(
                    data: (recipeModels) {
                      // Chuyển đổi từ RecipeModel sang List hiển thị nếu cần
                      // hoặc cập nhật RecipeList để nhận RecipeModel
                      return RecipeList(
                        recipes: recipeModels, // Truyền list từ Firestore về
                      );
                    },
                    loading: () => const SliverToBoxAdapter(child: Center(child: CircularProgressIndicator())),
                    error: (err, _) => SliverToBoxAdapter(child: Text('Lỗi tải công thức: $err')),
                  ),
                ],

                if (profileTab == ProfileTab.danhGia) const KeepAliveWrapper(child: ReviewTab()),
                if (profileTab == ProfileTab.tieuSu) SliverToBoxAdapter(child: BioTab(bioText: user.bio)),
                if (profileTab == ProfileTab.anh) const KeepAliveWrapper(child: SliverToBoxAdapter(child: PhotoGrid())),

                const SliverToBoxAdapter(child: SizedBox(height: 100)),
              ],
            ),
          ),
        );
      },
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