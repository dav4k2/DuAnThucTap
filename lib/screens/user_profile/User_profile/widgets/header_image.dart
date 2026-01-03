// lib/widgets/header_image.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class HeaderImage extends StatelessWidget {
  final String? imageUrl;
  const HeaderImage({super.key, this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: 0,
      top: 0,
      child: Container(
        width: 1.sw, // Sử dụng toàn chiều rộng màn hình
        height: 222.h,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: (imageUrl != null && imageUrl!.isNotEmpty)
                ? NetworkImage(imageUrl!) as ImageProvider
                : const AssetImage("image/profile_bg.png"),
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}