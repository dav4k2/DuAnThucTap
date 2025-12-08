// lib/screens/search/explore_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'widgets/explore_appbar.dart';
import 'widgets/explore_popular_user.section.dart';
import 'widgets/explore_keyword_section.dart';
import 'widgets/explore_highlight_recipes.dart';
// import 'package:fontend/navbar/smart_navbar.dart';

class ExploreScreen extends ConsumerStatefulWidget {
  const ExploreScreen({super.key});

  @override
  ConsumerState<ExploreScreen> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends ConsumerState<ExploreScreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final width = size.width;
    final height = size.height;
    final backgroundColor = Theme.of(context).scaffoldBackgroundColor;

    return Scaffold(
      backgroundColor: const Color(0xFFFFC221),
      extendBody: true,
      extendBodyBehindAppBar: true,

      body: Stack(
        children: [
          // ==================== NỘI DUNG CHÍNH ====================
          Column(
            children: [
              ExploreAppBar(width: width),

              Expanded(
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: backgroundColor, // Màu nền trắng
                    // ❌ Không đặt boxShadow ở đây vì nó sẽ hắt ngược lên trên
                  ),

                  // 👇 Dùng Stack để đè lớp bóng lên trên nội dung cuộn
                  child: Stack(
                    children: [
                      // 1. Nội dung chính (Nằm dưới)
                      SingleChildScrollView(
                        controller: _scrollController,
                        child: Padding(
                          padding: EdgeInsets.symmetric(vertical: height * 0.02),
                          child: Column(
                            children: [
                              PopularUsersSection(width: width),
                              SizedBox(height: height * 0.02),
                              KeywordsSection(width: width),
                              SizedBox(height: height * 0.02),
                              HighlightRecipes(width: width),
                              const SizedBox(height: 140),
                            ],
                          ),
                        ),
                      ),

                      // 2. Kẻ tạo bóng giả (Nằm trên cùng, cố định)
                      // Đây là thủ thuật: Một đường kẻ mỏng tang đổ bóng xuống dưới
                      Positioned(
                        top: 0,
                        left: 0,
                        right: 0,
                        child: Container(
                          height: 1, // Siêu mỏng
                          decoration: BoxDecoration(
                            color: backgroundColor, // Màu giống nền để tàng hình
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.15), // Màu bóng
                                offset: const Offset(0, 4), // 👇 Đổ bóng XUỐNG DƯỚI (vào phần trắng)
                                blurRadius: 10,  // Độ nhòe
                                spreadRadius: 1,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}