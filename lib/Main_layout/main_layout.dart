import 'package:flutter/material.dart';
import '../navbar.dart';
import '../screens/explore2/home_screen.dart';
import '../screens/explore/explore_screen.dart';

class MainLayout extends StatefulWidget {
  const MainLayout({super.key});

  @override
  State<MainLayout> createState() => _MainLayoutState();
}

class _MainLayoutState extends State<MainLayout> {
  int _currentIndex = 0;

  // ScrollController để navbar đổi màu theo vùng sáng/tối
  final ScrollController _scrollController = ScrollController();

  final List<Widget> _pages = const [
    HomeScreen(),
    ExploreScreen(),
    HomeScreen(),
  ];

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      backgroundColor: Colors.white,
      // 👇 body hiển thị page theo tab
      body: IndexedStack(
        index: _currentIndex,
        children: _pages,
      ),
      // 👇 truyền controller vào navbar
      bottomNavigationBar: SmartNavBar(
        currentIndex: _currentIndex,
        scrollController: _scrollController,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
    );
  }
}
