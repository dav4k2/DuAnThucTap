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
    return Scaffold(
      // màu vàng phần trên (phần header)
      backgroundColor: const Color(0xFFFFC221),

      body: SafeArea(
        child: Column(
          children: [
            const HomeHeader(),
            const SizedBox(height: 10),
            const SearchBarWidget(),
            const SizedBox(height: 20),

            // 👇 phần nội dung chính (trắng)
            Expanded(
              child: Container(
                width: double.infinity,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(40),
                  ),
                ),
                child: SingleChildScrollView(
                  controller: _scrollController,
                  child: const Column(
                    children: [
                      FeaturedRecipes(),
                      RecommendedList(),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),

      // 👇 Thanh navbar nền trắng + truyền đúng tham số
      bottomNavigationBar: Container(
        color: Colors.white, // đổi nền thanh navbar thành trắng
        child: SmartNavBar(
          currentIndex: _currentIndex,
          onTap: _onItemTapped,
          scrollController: _scrollController,
        ),
      ),
    );
  }
}
