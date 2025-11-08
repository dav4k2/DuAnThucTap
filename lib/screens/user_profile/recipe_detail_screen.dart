// lib/screens/recipe_detail_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'logic/chef_provider.dart';

class RecipeDetailScreen extends StatelessWidget {
  final Recipe recipe;
  const RecipeDetailScreen({super.key, required this.recipe});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(recipe.title)),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(height: 200.h, decoration: BoxDecoration(borderRadius: BorderRadius.circular(20.r), image: const DecorationImage(image: NetworkImage("https://placehold.co/400x200"), fit: BoxFit.cover))),
            SizedBox(height: 16.h),
            Text(recipe.title, style: TextStyle(fontSize: 24.sp, fontWeight: FontWeight.bold)),
            SizedBox(height: 8.h),
            Text('Thời gian: ${recipe.time} • Độ khó: ${recipe.difficulty}'),
            SizedBox(height: 8.h),
            Text('Đánh giá: ${recipe.rating} (${recipe.reviews} đánh giá)'),
            SizedBox(height: 16.h),
            const Text('Nguyên liệu', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
            const Text('Cách làm', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
          ],
        ),
      ),
    );
  }
}