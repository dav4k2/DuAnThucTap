// lib/features/add_recipe/widgets/video_upload.dart
import 'dart:io';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import '../logic/add_recipe_provider.dart';

class VideoUpload extends ConsumerWidget {
  const VideoUpload({Key? key}) : super(key: key);

  Future<void> _pickVideo(BuildContext context, WidgetRef ref) async {
    final picker = ImagePicker();

    // image_picker tự động hiện popup xin quyền trên iOS (nếu chưa có)
    final pickedFile = await picker.pickVideo(
      source: ImageSource.gallery,
    );

    if (pickedFile == null) {
      return; // Người dùng bấm hủy
    }

    final file = File(pickedFile.path);
    final sizeInMB = file.lengthSync() / (1024 * 1024);

    // Kiểm tra định dạng
    if (!pickedFile.path.toLowerCase().endsWith('.mp4')) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Chỉ chấp nhận file .mp4'), backgroundColor: Colors.red),
        );
      }
      return;
    }

    // Kiểm tra dung lượng
    if (sizeInMB > 100) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Video phải dưới 100MB'), backgroundColor: Colors.red),
        );
      }
      return;
    }

    // Thành công → lưu vào provider
    ref.read(addRecipeProvider.notifier).updateVideo(pickedFile.path);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final videoPath = ref.watch(addRecipeProvider.select((s) => s.video));
    final hasVideo = videoPath != null && videoPath.isNotEmpty;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 18.h),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 25.w),
          child: GestureDetector(
            onTap: () => _pickVideo(context, ref),
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
                child: hasVideo
                    ? Stack(
                  fit: StackFit.expand,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(24.r),
                      child: Image.file(
                        File(videoPath!),
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => Container(
                          color: Colors.black,
                          child: const Icon(Icons.video_file, size: 60, color: Colors.white70),
                        ),
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.bottomCenter,
                          colors: [Colors.black.withOpacity(0.8), Colors.transparent],
                        ),
                      ),
                    ),
                    Center(
                      child: Icon(Icons.play_circle_fill, size: 80.sp, color: Colors.white),
                    ),
                    Positioned(
                      top: 8.h,
                      right: 8.w,
                      child: GestureDetector(
                        onTap: () => ref.read(addRecipeProvider.notifier).clearVideo(),
                        child: Container(
                          padding: EdgeInsets.all(6.w),
                          decoration: const BoxDecoration(color: Colors.black54, shape: BoxShape.circle),
                          child: Icon(Icons.close, color: Colors.white, size: 20.sp),
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 12.h,
                      left: 16.w,
                      right: 16.w,
                      child: Text(
                        videoPath.split('/').last,
                        style: TextStyle(color: Colors.white, fontSize: 13.sp, shadows: const [Shadow(blurRadius: 10, color: Colors.black)]),
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                )
                    : Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset('image/video.png', width: 64.sp, height: 64.sp, color: const Color(0xFFFFB901)),
                    SizedBox(height: 12.h),
                    Text(
                      'file .mp4 dung lượng dưới 100MB',
                      style: TextStyle(fontSize: 14.sp, color: Colors.grey.shade700, fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}