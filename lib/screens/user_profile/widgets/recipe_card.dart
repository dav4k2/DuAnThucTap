// lib/widgets/recipe_card.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../logic/chef_provider.dart';

class RecipeCard extends StatelessWidget {
  final Recipe recipe;
  final VoidCallback onTap;
  const RecipeCard({super.key, required this.recipe, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Stack(
        children: [
          Container(
            width: 322.w,
            height: 139.h,
            decoration: ShapeDecoration(
              image: const DecorationImage(image: NetworkImage("https://placehold.co/322x139"), fit: BoxFit.cover),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.r)),
              shadows: const [BoxShadow(color: Color(0x3F000000), blurRadius: 4, offset: Offset(0, 4))],
            ),
          ),
          Positioned(
            top: 102.h,
            child: Container(
              width: 322.w,
              height: 37.h,
              decoration: ShapeDecoration(
                color: const Color(0xA3D9D9D9),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(41.r),
                    topRight: Radius.circular(41.r),
                    bottomLeft: Radius.circular(48.r),
                    bottomRight: Radius.circular(48.r),
                  ),
                ),
              ),
            ),
          ),
          Positioned(left: 13.w, top: 102.h, child: Text(recipe.title, style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w600))),
          Positioned(left: 31.w, top: 119.h, child: Text(recipe.time, style: _info())),
          Positioned(left: 84.w, top: 119.h, child: Text(recipe.difficulty, style: _info())),
          Positioned(left: 113.w, top: 119.h, child: Text('Đăng bởi ${recipe.author}', style: _info())),
          Positioned(left: 74.w, top: 117.h, child: Text('.', style: _dot())),
          Positioned(left: 102.w, top: 117.h, child: Text('.', style: _dot())),
          Positioned(
            left: 8.w,
            top: 5.h,
            child: Container(
              width: 128.w,
              height: 23.h,
              decoration: ShapeDecoration(color: const Color(0x7FF3EFEF), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.r))),
              alignment: Alignment.center,
              child: Text('${recipe.rating} (1k+ Đánh giá)', style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w500)),
            ),
          ),
          Positioned(
            right: 8.w,
            top: 8.h,
            child: Container(width: 25.w, height: 25.h, decoration: ShapeDecoration(color: Colors.white.withOpacity(0.5), shape: const OvalBorder())),
          ),
        ],
      ),
    );
  }

  TextStyle _info() => TextStyle(color: Colors.black.withOpacity(0.7), fontSize: 11.sp, fontWeight: FontWeight.w300, height: 1.36);
  TextStyle _dot() => TextStyle(color: Colors.black.withOpacity(0.7), fontSize: 20.sp, fontWeight: FontWeight.w700, height: 0.75);
}