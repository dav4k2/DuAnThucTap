// lib/main_layout.dart
import 'package:flutter/material.dart';
import '../navbar/navbar_selector.dart';
import '../screens/explore2/home_screen.dart';
import '../screens/explore/explore_screen.dart';
import '../screens/user_profile/chef_profile_screen.dart';

class MainLayout extends StatefulWidget {
  const MainLayout({super.key});

  @override
  State<MainLayout> createState() => _MainLayoutState();
}

class _MainLayoutState extends State<MainLayout> {
  int _currentIndex = 0;
  final ScrollController _scrollController = ScrollController();

  final List<Widget> _pages = const [
    HomeScreen(),
    ExploreScreen(),
    Center(child: Text('Library')),
    ChefProfileScreen(),
    Center(child: Text('Profile')),
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
      body: IndexedStack(
        index: _currentIndex,
        children: _pages,
      ),
      bottomNavigationBar: PlatformNavBar(
        currentIndex: _currentIndex,
        scrollController: _scrollController,
        onTap: (index) {
          setState(() => _currentIndex = index);
        },
      ),
    );
  }
}