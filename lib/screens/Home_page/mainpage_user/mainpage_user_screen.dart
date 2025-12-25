import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'widgets/home_header_user.dart';
import 'widgets/search_bar_user.dart';
import 'widgets/featured_recipes_user.dart';
import 'widgets/recommend_list_user.dart';
import 'package:fontend/navbar/smart_navbar.dart';

class HomeUserScreen extends StatefulWidget {
  const HomeUserScreen({super.key});

  @override
  State<HomeUserScreen> createState() => _HomeUserScreenState();
}

class _HomeUserScreenState extends State<HomeUserScreen> {
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
      extendBody: true, // ← Cho phép body kéo dài xuống dưới navbar
      body: SafeArea(
        bottom: false, // ← Không dùng safe area ở bottom
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
                        padding: EdgeInsets.only(bottom: 120.h), // ← Tăng padding để không bị navbar che
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


    );
  }
}