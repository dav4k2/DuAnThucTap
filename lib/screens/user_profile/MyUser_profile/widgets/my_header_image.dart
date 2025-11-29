// lib/widgets/my_header_image.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../logic/my_profile_provider.dart'; // nhớ import provider

class MyHeaderImage extends ConsumerWidget {
  const MyHeaderImage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final headerImage = ref.watch(myChefProvider).headerImage;

    return Positioned(
      left: 0,
      top: 0,
      child: Container(
        width: 402.w,
        height: 222.h,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(headerImage), // dùng ảnh từ provider
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}
