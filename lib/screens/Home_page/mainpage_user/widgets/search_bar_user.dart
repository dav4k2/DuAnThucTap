import 'package:flutter/material.dart';

class SearchBarWidget extends StatelessWidget {
  const SearchBarWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      margin: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width * 0.05),
      padding: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: isDark ? Colors.black.withOpacity(0.2) : Colors.white,
        border: Border.all(
          color: isDark ? Colors.white54 : Colors.black26,
        ),
        borderRadius: BorderRadius.circular(50),
      ),
      child: TextField(
        style: TextStyle(color: isDark ? Colors.white : Colors.black),
        decoration: InputDecoration(
          hintText: 'Nhập tên món ăn hoặc nguyên liệu...',
          hintStyle: TextStyle(
            color: isDark ? Colors.white70 : Colors.black,
          ),
          border: InputBorder.none,
          icon: Icon(
            Icons.search,
            color: isDark ? Colors.white : Colors.black54,
          ),
        ),
      ),
    );
  }
}
