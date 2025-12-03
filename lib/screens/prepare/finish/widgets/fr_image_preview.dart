import 'package:flutter/material.dart';

class FRImagePreview extends StatelessWidget {
  final String assetPath; // ảnh local trong thư mục image/

  const FRImagePreview({super.key, required this.assetPath});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 308,
      left: 34,
      child: Container(
        width: 336,
        height: 258,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(assetPath),  // load ảnh từ thư mục image/
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}
