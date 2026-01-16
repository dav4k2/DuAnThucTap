// lib/screens/my_profile_screen.dart
import 'dart:ui';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

// Các import widgets của bạn giữ nguyên
import 'package:fontend/screens/user_profile/MyUser_profile/widgets/follower.dart';
import 'package:fontend/screens/user_profile/MyUser_profile/widgets/my_save_recipe_list.dart';
import 'package:fontend/screens/user_profile/MyUser_profile/widgets/edit_profile_button.dart';
import 'package:fontend/screens/user_profile/MyUser_profile/widgets/my_bio_tab.dart';
import 'package:fontend/screens/user_profile/MyUser_profile/widgets/my_chef_info.dart';
import 'package:fontend/screens/user_profile/MyUser_profile/widgets/my_header_image.dart';
import 'package:fontend/screens/user_profile/MyUser_profile/widgets/my_meal_filter.dart';
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
  bool _isLoading = true; // Thay thế FutureBuilder bằng biến trạng thái này

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
    // Gọi hàm load dữ liệu ngay khi màn hình khởi tạo
    _loadUserProfile();
  }

  // Hàm load dữ liệu và đồng bộ vào Provider ngay lập tức
  Future<void> _loadUserProfile() async {
    try {
      final user = await UserService().getUserProfile();

      if (user != null && mounted) {
        String joinedStr = "Vừa tham gia";
        if (user.createdAt != null) {
          joinedStr = DateFormat('dd/MM/yyyy').format(user.createdAt!);
        }

        // QUAN TRỌNG: Cập nhật dữ liệu vào SurveyProvider (nguồn của MyChefProvider)
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

        // Refresh lại myChefProvider để đảm bảo UI nhận data mới
        ref.invalidate(myChefProvider);
      }
    } catch (e) {
      print("Lỗi tải profile: $e");
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _navigateToEditProfile() async {
    final chef = ref.read(myChefProvider);
    // Vì đã load xong ở initState nên chef lúc này chắc chắn là data thật
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => EditProfileScreen(user: chef)),
    );
    // Sau khi edit xong quay về thì reload lại data
    _loadUserProfile();
  }

  @override
  void dispose() {
    _mainScrollController.dispose();
    _recipeScrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // 1. Lấy dữ liệu Chef tĩnh (để hiển thị tên, avatar...)
    final chef = ref.watch(myChefProvider);
    final profileTab = ref.watch(myProfileTabProvider);

    final currentUser = FirebaseAuth.instance.currentUser;
    final currentUserId = currentUser?.uid ?? '';

    // 🔥 2. Lắng nghe số lượng công thức REAL-TIME từ Firestore
    final recipeCountAsync = ref.watch(recipeCountProvider(currentUserId));

    // 🔥 3. Xử lý trạng thái AsyncValue để lấy ra con số (mặc định là 0 nếu đang load/lỗi)
    final realTimeRecipeCount = recipeCountAsync.maybeWhen(
      data: (count) => count,
      orElse: () => 0,
    );

    if (profileTab == ProfileTab.congThuc) {
      WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToTop());
    }

    if (_isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    if (currentUser == null) {
      return Scaffold(body: Center(child: Text("Vui lòng đăng nhập".tr())));
    }

    return Scaffold(
      body: CustomScrollView(
        controller: _mainScrollController,
        physics: const BouncingScrollPhysics(),
        slivers: [
          SliverAppBar(
            expandedHeight: 500.h,
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

                  // Dùng dữ liệu từ chef (Provider) thay vì user (FutureBuilder cũ)
                  MyHeaderImage(imageUrl: chef.coverUrl),
                  MyProfileAvatar(imageUrl: chef.avatarUrl),
                  MyChefInfo(
                      name: chef.name,
                      title: chef.title
                  ),
                  MyStatsSection(
                    recipes: realTimeRecipeCount, // Dùng biến real-time thay vì chef.recipes
                    onFollowersTap: () {
                      if (currentUserId.isEmpty) return;
                      showDialog(
                        context: context,
                        builder: (context) => FollowersListPage(
                          isFollowingTab: false,
                          userId: currentUserId,
                        ),
                      );
                    },
                    onFollowingTap: () {
                      if (currentUserId.isEmpty) return;
                      showDialog(
                        context: context,
                        builder: (context) => FollowersListPage(
                          isFollowingTab: true,
                          userId: currentUserId,
                        ),
                      );
                    },
                  ),
                  EditProfileButton(onTap: _navigateToEditProfile),
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

          if (profileTab == ProfileTab.congThuc)
            KeepAliveWrapper(
              child: MyRecipeList(userId: currentUserId), // Sửa thành currentUserId
            ),

          if (profileTab == ProfileTab.danhGia)
            const KeepAliveWrapper(
              child: SliverPersistentHeader(
                pinned: true,
                delegate: _MyReviewFilterDelegate(),
              ),
            ),

          if (profileTab == ProfileTab.danhGia)
            const KeepAliveWrapper(child: MyReviewTab()),

          if (profileTab == ProfileTab.tieuSu)
            KeepAliveWrapper(
              child: SliverToBoxAdapter(child: MyBioTab()),
            ),

          if (profileTab == ProfileTab.anh)
            KeepAliveWrapper(
              child: SliverToBoxAdapter(
                child: const MySavedRecipesList(),
              ),
            ),

          const SliverToBoxAdapter(child: SizedBox(height: 100)),
        ],
      ),
    );
  }
}

// ... Giữ nguyên các class KeepAliveWrapper và Delegate ở dưới ...
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