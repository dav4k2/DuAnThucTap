import 'package:flutter/material.dart';
import 'widgets/home_header.dart';
import 'widgets/search_bar.dart';
import 'widgets/featured_recipes.dart';
import 'widgets/recommended_list.dart';
import 'widgets/bottom_nav_bar.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // màu vàng phần trên
      backgroundColor: const Color(0xFFFFC221),
      body: SafeArea(
        child: Column(
          children: [
            const HomeHeader(),
            const SizedBox(height: 10),
            const SearchBarWidget(),
            const SizedBox(height: 20),

            // 👇 phần nội dung chính (trắng) chiếm hết phần còn lại
            Expanded(
              child: Container(
                width: double.infinity,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(40)),
                ),
                child: const SingleChildScrollView(
                  child: Column(
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
      bottomNavigationBar: const BottomNavBar(),
    );
  }
}
