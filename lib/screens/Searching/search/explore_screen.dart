// lib/screens/search/explore_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'widgets/explore_appbar.dart';
import 'widgets/explore_popular_user.section.dart';
import 'widgets/explore_keyword_section.dart';
import 'widgets/explore_highlight_recipes.dart';

class ExploreScreen extends ConsumerStatefulWidget {
  const ExploreScreen({super.key});

  @override
  ConsumerState<ExploreScreen> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends ConsumerState<ExploreScreen> {
  int currentIndex = 1;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final width = size.width;
    final height = size.height;

    // lib/screens/search/explore_screen.dart
    return Scaffold(
      //backgroundColor: Colors.white,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        bottom: true,
        child: Column(
          children: [
            // AppBar vàng
            Container(
              decoration: const BoxDecoration(
                color: Color(0xFFFFB901),
              ),
              child: ExploreAppBar(width: width),
            ),

            // Nội dung cuộn
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: height * 0.02),
                  child: Column(
                    children: [
                      PopularUsersSection(width: width),
                      SizedBox(height: height * 0.02),
                      KeywordsSection(width: width),
                      SizedBox(height: height * 0.02),
                      HighlightRecipes(width: width),
                      // Nếu bạn vẫn muốn giữ cái thanh kéo dưới cùng (kiểu sheet)
                      // thì để ở đây, không để trong AppBar hay widget khác
                      // const BottomIndicator(),
                      const SizedBox(height: 20), // để không sát mép
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}