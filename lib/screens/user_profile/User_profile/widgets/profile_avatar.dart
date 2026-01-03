// lib/widgets/profile_avatar.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ProfileAvatar extends StatelessWidget {
  final String? imageUrl;
  const ProfileAvatar({super.key, this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
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
        Positioned(
          left: 141.w,
          top: 138.h,
          child: Container(
            width: 120.w,
            height: 120.h,
            child: ClipOval(
              child: (imageUrl != null && imageUrl!.isNotEmpty)
                  ? Image.network(
                imageUrl!,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) =>
                    Image.asset("image/empty_user.jpg", fit: BoxFit.fill),
              )
                  : Image.asset("image/empty_user.jpg", fit: BoxFit.fill),
            ),
          ),
        ),
      ],
    );
  }
}
