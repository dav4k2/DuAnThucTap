// lib/features/add_recipe/widgets/video_upload.dart

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class VideoUpload extends StatelessWidget {
  const VideoUpload({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 18.h),

        // Ô upload video – viền nét đứt vàng, bo góc đẹp
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 25.w),
          child: DottedBorder(
            color: const Color(0xFFFFB901),
            strokeWidth: 2.5,
            dashPattern: const [8, 5],
            borderType: BorderType.RRect,
            radius: Radius.circular(24.r),
            child: Container(
              width: double.infinity,
              height: 180.h,
              decoration: BoxDecoration(
                color: const Color(0x51D4D4D4),
                borderRadius: BorderRadius.circular(24.r),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Icon video to đẹp ở giữa
                  Center(
                    child: Image.asset(
                      'image/video.png', // thay bằng đường dẫn file của bạn
                      width: 64.sp,
                      height: 64.sp,
                      color: const Color(0xFFFFB901), // nếu muốn đổi màu
                    ),
                  ),

                  SizedBox(height: 12.h),

                  // Text hướng dẫn
                  Text(
                    'file .mp4 dung lượng dưới 100MB',
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: Colors.grey.shade700,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}