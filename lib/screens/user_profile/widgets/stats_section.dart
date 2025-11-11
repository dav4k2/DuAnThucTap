// lib/widgets/stats_section.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class StatsSection extends StatelessWidget {
  final int recipes;
  final String followers;
  final int following;
  const StatsSection({super.key, required this.recipes, required this.followers, required this.following});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(left: 63.w, top: 370.h, child: Text('$recipes', style: TextStyle(fontSize: 26.sp, fontWeight: FontWeight.w500))),
        Positioned(left: 23.w, top: 405.h, child: Text('Số công thức', style: TextStyle(color: Colors.black.withOpacity(0.6), fontSize: 15.sp))),
        Positioned(left: 167.w, top: 370.h, child: Text(followers, style: TextStyle(fontSize: 26.sp, fontWeight: FontWeight.w500))),
        Positioned(left: 171.w, top: 405.h, child: Text('Follower', style: TextStyle(color: Colors.black.withOpacity(0.6), fontSize: 15.sp))),
        Positioned(left: 312.w, top: 370.h, child: Text('$following', style: TextStyle(fontSize: 26.sp, fontWeight: FontWeight.w500))),
        Positioned(left: 293.w, top: 405.h, child: Text('Đã follow', style: TextStyle(color: Colors.black.withOpacity(0.6), fontSize: 15.sp))),
        Positioned(
          left: 115.w,
          top: 395.h,
          child: Transform.rotate(
            angle: 1.55,
            child: Container(width: 50.w, height: 1.5.h, color: Colors.black.withOpacity(0.3)),
          ),
        ),
        Positioned(
          left: 240.w,
          top: 395.h,
          child: Transform.rotate(
            angle: 1.55,
            child: Container(width: 50.w, height: 1.5.h, color: Colors.black.withOpacity(0.3)),
          ),
        ),
      ],
    );
  }
}