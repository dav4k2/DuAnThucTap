// lib/widgets/photo_grid.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PhotoGrid extends StatelessWidget {
  const PhotoGrid({super.key});
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        _photo(43.w, 594.h),
        _photo(200.w, 594.h),
        _photo(43.w, 730.h),
        _photo(200.w, 730.h),
      ],
    );
  }

  Widget _photo(double left, double top) => Positioned(
    left: left,
    top: top,
    child: Container(
      width: 150.w,
      height: 120.h,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16.r),
        image: const DecorationImage(image: NetworkImage("https://placehold.co/150x120"), fit: BoxFit.cover),
      ),
    ),
  );
}