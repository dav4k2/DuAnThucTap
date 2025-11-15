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

    return Scaffold(
      backgroundColor: const Color(0xFFFFC221), // ← CỐ ĐỊNH MÀU VÀNG
      body: Column(
        children: [
          // AppBar vàng
          ExploreAppBar(width: width),

          // Nội dung cuộn
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: Theme.of(context).scaffoldBackgroundColor, // ← Đổi theo theme
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(30), // ← Thêm bo góc
                ),
              ),
              child: SafeArea(
                top: false,
                bottom: true,
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
                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}