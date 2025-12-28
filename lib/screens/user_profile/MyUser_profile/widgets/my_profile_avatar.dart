import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MyProfileAvatar extends StatelessWidget {
  final String? imageUrl; // Nhận URL ảnh từ API

  const MyProfileAvatar({
    super.key,
    this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    // Kiểm tra xem có link ảnh hợp lệ không
    final bool hasImage = imageUrl != null && imageUrl!.isNotEmpty;

    return Stack(
      children: [
        // Viền trắng bên ngoài
        Positioned(
          left: 136.w,
          top: 133.h,
          child: Container(
            width: 130.w,
            height: 130.h,
            decoration: const ShapeDecoration(
              color: Colors.white,
              shape: OvalBorder(),
            ),
          ),
        ),

        // Avatar thật
        Positioned(
          left: 141.w,
          top: 138.h,
          child: Container(
            width: 120.w,
            height: 120.h,
            decoration: ShapeDecoration(
              image: DecorationImage(
                // Logic: Nếu có link ảnh -> dùng NetworkImage, ngược lại dùng AssetImage
                image: hasImage
                    ? NetworkImage(imageUrl!) as ImageProvider
                    : const AssetImage("image/empty_user.jpg"), // Ảnh mặc định trong assets
                fit: BoxFit.cover,
              ),
              shape: const OvalBorder(),
            ),
          ),
        ),
      ],
    );
  }
}