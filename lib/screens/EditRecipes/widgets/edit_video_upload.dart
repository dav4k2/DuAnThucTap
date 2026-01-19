// lib/features/add_recipe/widgets/edit_video_upload.dart
import 'dart:io';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import '../logic/edit_recipe_provider.dart';

class EditVideoUpload extends ConsumerWidget {
  const EditVideoUpload({Key? key}) : super(key: key);

  Future<void> _pickVideo(BuildContext context, WidgetRef ref) async {
    final picker = ImagePicker();
    // Chọn video từ thư viện
    final pickedFile = await picker.pickVideo(
        source: ImageSource.gallery,
        maxDuration: const Duration(minutes: 5) // Giới hạn thời lượng nếu muốn
    );

    if (pickedFile == null) return;

    if (!pickedFile.path.toLowerCase().endsWith('.mp4')) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Chỉ chấp nhận file .mp4'), backgroundColor: Colors.red),
        );
      }
      return;
    }

    // Kiểm tra dung lượng (Ví dụ 100MB)
    final file = File(pickedFile.path);
    int sizeInBytes = file.lengthSync();
    double sizeInMb = sizeInBytes / (1024 * 1024);
    if (sizeInMb > 100) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Video quá lớn (>100MB)'), backgroundColor: Colors.red),
        );
      }
      return;
    }

    // Cập nhật vào Provider
    ref.read(editRecipeProvider.notifier).updateVideo(pickedFile.path);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    // Lấy đường dẫn video từ state
    final videoPath = ref.watch(editRecipeProvider.select((s) => s.video));
    final hasVideo = videoPath != null && videoPath.isNotEmpty;

    // Kiểm tra xem video là link Online hay File Offline
    final isNetworkVideo = hasVideo && (videoPath!.startsWith('http') || videoPath.startsWith('https'));

    final dottedBgColor = isDark ? const Color(0x33D4D4D4) : const Color(0x51D4D4D4);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ... (Giữ nguyên phần UI bao quanh nếu muốn)
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
                  color: dottedBgColor,
                  borderRadius: BorderRadius.circular(24.r),
                ),
                child: hasVideo
                    ? Stack(
                  fit: StackFit.expand,
                  children: [
                    // 1. Nền: Vì không render được MP4 bằng Image Widget,
                    // ta dùng Container màu đen hoặc Icon để biểu thị
                    ClipRRect(
                      borderRadius: BorderRadius.circular(24.r),
                      child: Container(
                        color: Colors.black87,
                        child: Center(
                          child: Icon(
                              Icons.videocam,
                              color: Colors.white24,
                              size: 80.sp
                          ),
                        ),
                      ),
                    ),

                    // 2. Icon Play ở giữa
                    Center(
                      child: Icon(Icons.play_circle_fill, size: 60.sp, color: const Color(0xFFFFB901)),
                    ),

                    // 3. Hiển thị tên file hoặc trạng thái
                    Positioned(
                      bottom: 12.h,
                      left: 16.w,
                      right: 16.w,
                      child: Text(
                        isNetworkVideo ? "Video đã lưu trên Server" : "Video mới: ${videoPath!.split('/').last}",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 13.sp,
                          fontWeight: FontWeight.bold,
                          shadows: const [Shadow(blurRadius: 4, color: Colors.black)],
                        ),
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.center,
                      ),
                    ),

                    // 4. Nút Xóa
                    Positioned(
                      top: 8.h,
                      right: 8.w,
                      child: GestureDetector(
                        onTap: () => ref.read(editRecipeProvider.notifier).clearVideo(),
                        child: Container(
                          padding: EdgeInsets.all(6.w),
                          decoration: const BoxDecoration(color: Colors.black54, shape: BoxShape.circle),
                          child: Icon(Icons.close, color: Colors.white, size: 20.sp),
                        ),
                      ),
                    ),
                  ],
                )
                    : Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      'image/video.png', // Đảm bảo bạn có ảnh này
                      width: 64.sp,
                      height: 64.sp,
                      color: const Color(0xFFFFB901),
                      errorBuilder: (c,e,s) => Icon(Icons.video_library, size: 64.sp, color: const Color(0xFFFFB901)),
                    ),
                    SizedBox(height: 12.h),
                    Text(
                      'Thêm Video (MP4 < 100MB)',
                      style: TextStyle(
                        fontSize: 14.sp,
                        color: isDark ? Colors.grey[400] : Colors.grey.shade700,
                        fontWeight: FontWeight.w500,
                      ),
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