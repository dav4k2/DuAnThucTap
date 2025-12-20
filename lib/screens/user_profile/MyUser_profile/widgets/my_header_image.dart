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
        color: Colors.grey[300], // Fallback color
        child: hasImage
            ? Image.network(
          imageUrl!,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) => _buildPlaceholder(),
        )
            : _buildPlaceholder(),
      ),
    );
  }

// Separate method to handle the asset image with a fallback
  Widget _buildPlaceholder() {
    return Image.asset(
      "assets/image/profile_bg.png",
      fit: BoxFit.cover,
      errorBuilder: (context, error, stackTrace) {
        // If the asset itself is missing, return a simple icon or empty box
        return const Icon(Icons.broken_image, color: Colors.grey);
      },
    );
  }
}