// lib/main_layout.dart
import 'package:flutter/material.dart';
import '../navbar/navbar_selector.dart';
import '../screens/Cooking_step/recipe_run_screen.dart';
import '../screens/Crete_recipe/create_recipe_screen.dart';
import '../screens/Home_page/mainpage_guest/home_screen.dart';
import '../screens/Home_page/mainpage_user/mainpage_user_screen.dart';
import '../screens/Searching/search/explore_screen.dart';
import '../screens/Setting/settings/settings_screen.dart';
import '../screens/user_profile/MyUser_profile/my_profile_screen.dart';

class MainLayout extends StatefulWidget {
  const MainLayout({super.key});

  @override
  State<MainLayout> createState() => _MainLayoutState();
}

class _MainLayoutState extends State<MainLayout> {
  int _currentIndex = 0;
  final ScrollController _scrollController = ScrollController();

  final List<Widget> _pages = const [
    HomeUserScreen(),
    ExploreScreen(),
    CreateRecipeScreen(),
    MyProfileScreen(),
    SettingsScreen(),
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