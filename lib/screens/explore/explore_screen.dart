import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'widgets/explore_appbar.dart';
import 'widgets/explore_popular_user.section.dart';
import 'widgets/explore_keyword_section.dart';
import 'widgets/explore_highlight_recipes.dart';
import '../../navbar.dart';

class ExploreScreen extends ConsumerStatefulWidget {
  const ExploreScreen({super.key});

  @override
  ConsumerState<ExploreScreen> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends ConsumerState<ExploreScreen> {
  int currentIndex = 1; // ví dụ mặc định đang ở Explore/Search

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final width = size.width;
    final height = size.height;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          // 🟨 AppBar
          Container(
            decoration: const BoxDecoration(
              color: Color(0xFFFFB901),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(30),
                bottomRight: Radius.circular(30),
              ),
            ),
            child: SafeArea(
              bottom: false,
              child: ExploreAppBar(width: width),
            ),
          ),

          // ⚪ Nội dung
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.symmetric(
                  vertical: height * 0.02,
                ),
                child: Column(
                  children: [
                    PopularUsersSection(width: width),
                    SizedBox(height: height * 0.02),
                    KeywordsSection(width: width),
                    SizedBox(height: height * 0.02),
                    HighlightRecipes(width: width),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
