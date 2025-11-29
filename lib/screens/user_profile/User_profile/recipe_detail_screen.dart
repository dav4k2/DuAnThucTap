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
      appBar: AppBar(
        title: Text(recipe.title),
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: Colors.black,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // === ẢNH MÓN ĂN (TỪ recipe.imageUrl) ===
            Container(
              height: 220.h,
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20.r),
                image: DecorationImage(
                  image: AssetImage(recipe.imageAsset), // ← DÙNG ẢNH CỦA MÓN
                  fit: BoxFit.cover,
                ),
              ),
            ),
            SizedBox(height: 16.h),

            // === TIÊU ĐỀ ===
            Text(
              recipe.title,
              style: TextStyle(fontSize: 24.sp, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8.h),

            // === THÔNG TIN ===
            Row(
              children: [
                Icon(Icons.access_time, size: 16.sp, color: Colors.grey),
                SizedBox(width: 4.w),
                Text('${recipe.time} • '),
                Icon(Icons.bar_chart, size: 16.sp, color: Colors.grey),
                SizedBox(width: 4.w),
                Text(recipe.difficulty),
              ],
            ),
            SizedBox(height: 8.h),

            // === ĐÁNH GIÁ ===
            Row(
              children: [
                Icon(Icons.star, size: 18.sp, color: Colors.amber),
                SizedBox(width: 4.w),
                Text('${recipe.rating}', style: TextStyle(fontWeight: FontWeight.w600)),
                Text(' (${recipe.reviews} đánh giá)', style: TextStyle(color: Colors.grey)),
              ],
            ),
            SizedBox(height: 24.h),

            // === NGUYÊN LIỆU ===
            const Text('Nguyên liệu', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
            SizedBox(height: 8.h),
            _buildIngredient("4 miếng đùi gà"),
            _buildIngredient("200g bột mì"),
            _buildIngredient("2 quả trứng"),
            _buildIngredient("Gia vị: muối, tiêu, tỏi bột"),

            SizedBox(height: 24.h),

            // === CÁCH LÀM ===
            const Text('Cách làm', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
            SizedBox(height: 8.h),
            _buildStep(1, "Rửa sạch gà, thấm khô."),
            _buildStep(2, "Trộn bột mì với gia vị."),
            _buildStep(3, "Nhúng gà qua trứng, lăn bột."),
            _buildStep(4, "Chiên ngập dầu 180°C trong 8 phút."),
          ],
        ),
      ),
    );
  }

  Widget _buildIngredient(String text) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4.h),
      child: Row(
        children: [
          Container(width: 8.w, height: 8.h, decoration: BoxDecoration(color: Colors.amber, shape: BoxShape.circle)),
          SizedBox(width: 8.w),
          Text(text, style: TextStyle(fontSize: 14.sp)),
        ],
      ),
    );
  }

  Widget _buildStep(int step, String text) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 6.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 24.w,
            height: 24.h,
            decoration: BoxDecoration(color: const Color(0xFFFFC735), shape: BoxShape.circle),
            alignment: Alignment.center,
            child: Text('$step', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12.sp)),
          ),
          SizedBox(width: 12.w),
          Expanded(child: Text(text, style: TextStyle(fontSize: 14.sp, height: 1.5))),
        ],
      ),
    );
  }
}