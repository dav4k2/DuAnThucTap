import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MyHeaderImage extends StatelessWidget {
  final String? imageUrl; // Nhận URL ảnh bìa

  const MyHeaderImage({
    super.key,
    this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    final bool hasImage = imageUrl != null && imageUrl!.isNotEmpty;

    return Positioned(
      left: 0,
      top: 0,
      child: Container(
        width: 402.w,
        height: 222.h,
        decoration: BoxDecoration(
          color: Colors.grey[300], // Màu nền khi chưa có ảnh
          image: hasImage
              ? DecorationImage(
            image: NetworkImage(imageUrl!),
            fit: BoxFit.cover,
          )
              : const DecorationImage(
            // Bạn có thể để 1 ảnh bìa mặc định trong assets
            image: AssetImage("assets/images/default_cover.png"),
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}