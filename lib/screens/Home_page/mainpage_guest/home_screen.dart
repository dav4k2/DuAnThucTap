import 'package:flutter/material.dart';
import 'widgets/home_header.dart';
import 'widgets/search_bar.dart';
import 'widgets/featured_recipes.dart';
import 'widgets/recommended_list.dart';
import 'package:fontend/navbar/smart_navbar.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ScrollController _scrollController = ScrollController();
  int _currentIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    // 🔹 Lấy theme hiện tại
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: const Color(0xFFFFC221),
      body: SafeArea(
        child: Column(
          children: [
            const HomeHeader(),
            const SizedBox(height: 10),
            const SearchBarWidget(),
            const SizedBox(height: 20),

            // ⚪ Nền nội dung chính
            Expanded(
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: theme.colorScheme.surface, // 🌗 đổi theo theme
                  borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(40)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const FeaturedRecipes(),
                    const SizedBox(height: 10),

                    // 🧍 Tiêu đề cố định (bỏ const để nhận theme)
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Text(
                        'Đề xuất',
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),

                    const SizedBox(height: 10),

                    // 📜 Phần cuộn
                    Expanded(
                      child: SingleChildScrollView(
                        controller: _scrollController,
                        physics: const BouncingScrollPhysics(),
                        child: const RecommendedList(),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),

      // 🔸 Thanh điều hướng (đổi màu theo theme)
      bottomNavigationBar: Container(
        color: theme.colorScheme.surface,
        child: SmartNavBar(
          currentIndex: _currentIndex,
          onTap: _onItemTapped,
          scrollController: _scrollController,
        ),
      ),
    );
  }
}
