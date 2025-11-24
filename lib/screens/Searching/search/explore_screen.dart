// lib/screens/search/explore_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'widgets/explore_appbar.dart';
import 'widgets/explore_popular_user.section.dart';
import 'widgets/explore_keyword_section.dart';
import 'widgets/explore_highlight_recipes.dart';
import 'package:fontend/navbar/smart_navbar.dart';

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
                  decoration: BoxDecoration(        // ❌ bỏ const
                    color: Theme.of(context).scaffoldBackgroundColor,     // ✔ tự đổi theo dark/light mode
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(30),
                    ),
                  ),
                  child: SingleChildScrollView(
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
                ),
              ),
            ],
          ),

          // ==================== NAVBAR FIXED Ở ĐÁY ====================
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: SafeArea(
              bottom: false, // tránh tạo khoảng trắng trong dark mode
              child: SmartNavBar(
                currentIndex: 1,
                scrollController: _scrollController,
                onTap: (index) {},
              ),
            ),
          ),
        ],
      ),
    );
  }
}
