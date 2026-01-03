import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../Search_result/search_results_screen.dart';
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
  final ScrollController _scrollController = ScrollController();
  // Khởi tạo controller để dùng chung cho AppBar và KeywordsSection
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _scrollController.dispose();
    _searchController.dispose();
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
          Column(
            children: [
              // Truyền controller vào AppBar
              ExploreAppBar(
                width: width,
                controller: _searchController,
                onSubmitted: (query) {
                  final trimmedQuery = query.trim();
                  if (trimmedQuery.isNotEmpty) {
                    // Điều hướng đến màn hình kết quả tìm kiếm
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => SearchResultsScreen(query: trimmedQuery),
                      ),
                    );
                  }
                },
              ),

              Expanded(
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(color: backgroundColor),
                  child: Stack(
                    children: [
                      SingleChildScrollView(
                        controller: _scrollController,
                        child: Padding(
                          padding: EdgeInsets.symmetric(vertical: height * 0.02),
                          child: Column(
                            children: [
                              PopularUsersSection(width: width),
                              SizedBox(height: height * 0.02),
                              // Truyền hàm callback để gán giá trị vào controller
                              KeywordsSection(
                                width: width,
                                onKeywordSelected: (keyword) {
                                  _searchController.text = keyword;
                                },
                              ),
                              SizedBox(height: height * 0.02),
                              HighlightRecipes(width: width),
                              const SizedBox(height: 140),
                            ],
                          ),
                        ),
                      ),
                      Positioned(
                        top: 0,
                        left: 0,
                        right: 0,
                        child: Container(
                          height: 1,
                          decoration: BoxDecoration(
                            color: backgroundColor,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.15),
                                offset: const Offset(0, 4),
                                blurRadius: 10,
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