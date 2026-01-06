// lib/screens/my_profile_screen.dart
import 'dart:ui';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/cupertino.dart';
import 'package:fontend/screens/user_profile/MyUser_profile/widgets/follower.dart';
import 'package:intl/intl.dart';
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
import '../../../Service/user_model.dart';
import '../../../Service/user_service.dart';
import '../../survey/logic/survey_provider.dart';
import '../Edit_user/edit_profile_screen.dart';
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
  // Biến lưu data user
  Future<UserModel?>? _userFuture;

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
  void initState() {
    super.initState();
    _userFuture = UserService().getUserProfile();
  }

  Future<void> _refreshData() async {
    final user = await UserService().getUserProfile();

    if (user != null && mounted) {
      setState(() {
        _userFuture = Future.value(user);
      });

      String joinedStr = "Vừa tham gia";
      if (user.createdAt != null) {
        joinedStr = DateFormat('dd/MM/yyyy').format(user.createdAt!);
      }

      // Đồng bộ Email và các thông tin khác vào Provider
      ref.read(surveyProvider.notifier).updateUserData(
        displayName: user.displayName,
        bio: user.bio,
        cookingTitle: user.cookingLevel,
        country: user.country,
        email: user.email,
        joinedDated: joinedStr,
        avatarUrl: user.avatarUrl,
        coverUrl: user.coverUrl,
      );

      // 3. Làm mới Provider
      ref.invalidate(myChefProvider);
    }
  }

  void _navigateToEditProfile() async {
    final chef = ref.read(myChefProvider);
    if (chef.name.isEmpty) {
      print("Vui lòng đợi dữ liệu tải xong");
      return;
    }

    await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => EditProfileScreen(user: chef)),
    );
    _refreshData();
  }

  @override
  void dispose() {
    _mainScrollController.dispose();
    _recipeScrollController.dispose();
    super.dispose();
  }

  void _showFollowersDialog(BuildContext context, bool isFollowingTab) {
    showDialog(
      context: context,
      barrierColor: Colors.black.withOpacity(0.5), // Nền tối hơn giúp Box trắng nổi bật
      builder: (context) => BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 4, sigmaY: 4), // Mờ nền phía sau
        child: FollowersListPage(isFollowingTab: isFollowingTab),
      ),
    );
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
      body: FutureBuilder<UserModel?>(
          future: _userFuture,
          builder: (context, snapshot){
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (snapshot.hasError || !snapshot.hasData || snapshot.data == null) {
              return Center(child: Text("Hãy đăng nhập để sử duụng tính năng này".tr()));
            }

            final user = snapshot.data!;

            return CustomScrollView(
              controller: _mainScrollController,
              physics: const BouncingScrollPhysics(),
              slivers: [
                SliverAppBar(
                  expandedHeight: 480.h,
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
                                borderRadius:
                                BorderRadius.vertical(top: Radius.circular(20.r)),
                              ),
                            ),
                          ),
                        ),

                        MyHeaderImage(imageUrl: user.coverUrl),
                        MyProfileAvatar(imageUrl: user.avatarUrl),
                        MyChefInfo(
                            name: user.displayName ?? "Người dùng mới",
                            title: user.cookingLevel ?? "Yêu thích nấu ăn"
                        ),
                        MyStatsSection(
                          recipes: chef.recipes,
                          onFollowersTap: () {
                            _showFollowersDialog(context, false);
                          },
                          onFollowingTap: () {
                            _showFollowersDialog(context, true);
                          },
                        ),
                        EditProfileButton(onTap: _navigateToEditProfile),     // Nút chỉnh sửa
                        const MyProfileTabs(),
                      ],
                    ),
                  ),
                ),


                if (profileTab == ProfileTab.congThuc)
                  const KeepAliveWrapper(
                    child: SliverPersistentHeader(
                      pinned: true,
                      delegate: _MyMealFilterDelegate(),
                    ),
                  ),

                // === TAB CÔNG THỨC ===
                if (profileTab == ProfileTab.congThuc)
                  KeepAliveWrapper(
                    child: MyRecipeList(userId: user.id),
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
                  KeepAliveWrapper(
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
            );
          }
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