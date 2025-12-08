import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'widgets/home_header.dart';
//import 'widgets/search_bar.dart';
import 'widgets/featured_recipes.dart';
import 'widgets/recommended_list.dart';
// import 'package:fontend/navbar/smart_navbar.dart'; // Bỏ comment nếu bạn dùng

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ScrollController _scrollController = ScrollController();

  // Biến này nếu bạn dùng cho Navbar
  // int _currentIndex = 0;
  // void _onItemTapped(int index) {
  //   setState(() {
  //     _currentIndex = index;
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    // 🔹 Lấy theme hiện tại
    final theme = Theme.of(context);
    // final isDark = theme.brightness == Brightness.dark; // Dùng nếu cần check dark mode

    return Scaffold(
      backgroundColor: const Color(0xFFFFC221), // Màu vàng chủ đạo
      extendBody: true, // Cho phép body tràn xuống dưới navbar
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            const HomeHeader(),

            // 🔻 Đã giảm khoảng cách này xuống (trước là 10 + 20)
            // Chỉ giữ lại một chút để phần trắng không đè lên chữ của Header
            const SizedBox(height: 15),

            // ⚪ Nền nội dung chính
            Expanded(
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: theme.colorScheme.surface, // Màu trắng (hoặc đen theo theme)
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(30), // Bo góc mềm mại như ảnh mẫu
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 🔻 KHOẢNG ĐỆM QUAN TRỌNG:
                    // Đẩy nội dung xuống để không dính sát mép cong
                    const SizedBox(height: 20),

                    // 🍲 Phần danh sách ngang (Công thức nổi bật)
                    const FeaturedRecipes(),

                    const SizedBox(height: 10),

                    // 🏷 Tiêu đề Đề xuất
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

                    // 📜 Phần danh sách dọc (Đề xuất) - Cuộn được
                    Expanded(
                      child: SingleChildScrollView(
                        controller: _scrollController,
                        physics: const BouncingScrollPhysics(),
                        // Padding dưới cùng để nội dung không bị Navbar che mất
                        padding: EdgeInsets.only(bottom: 120.h),
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