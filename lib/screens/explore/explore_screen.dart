import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'widgets/explore_appbar.dart';
import 'widgets/explore_popular_user.section.dart';
import 'widgets/explore_keyword_section.dart';
import 'widgets/explore_highlight_recipes.dart';
import '../../screens/navbar.dart';

class ExploreScreen extends ConsumerWidget {
  const ExploreScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final size = MediaQuery.of(context).size;
    final width = size.width;
    final height = size.height;

    return Scaffold(
      backgroundColor: Colors.white, // ⚪ Nền trắng toàn bộ
      body: Column(
        children: [
          // 🟨 AppBar (nền vàng) - bo tròn góc dưới
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

          // ⚪ Nội dung trên nền trắng
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
