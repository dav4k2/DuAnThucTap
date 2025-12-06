// lib/features/user_guide/widgets/guide_widgets.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:video_player/video_player.dart'; // Import thư viện video
import '../model/guide_model.dart';

const Color kPrimaryYellow = Color(0xFFFFB901);

// --- WIDGET 1: Hộp hiển thị Media (Đã nâng cấp Video) ---
class GuideMediaBox extends StatelessWidget {
  final String path;
  final MediaType type;
  final bool isDark;

  const GuideMediaBox({
    Key? key,
    required this.path,
    required this.type,
    required this.isDark,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 400.h,
      width: double.infinity,
      decoration: BoxDecoration(
        color: isDark ? Colors.black26 : Colors.grey[100],
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16.r),
        child: type == MediaType.image
            ? Image.asset(
          path,
          fit: BoxFit.contain, // Đổi thành contain để thấy toàn bộ ảnh nếu ảnh dài
          errorBuilder: (_, __, ___) => Center(
              child: Icon(Icons.image_not_supported, size: 40.sp, color: Colors.grey)),
        )
            : _SimpleVideoPlayer(videoPath: path),
      ),
    );
  }
}

// --- WIDGET VIDEO RIÊNG (Mới thêm) ---
class _SimpleVideoPlayer extends StatefulWidget {
  final String videoPath;
  const _SimpleVideoPlayer({required this.videoPath});

  @override
  State<_SimpleVideoPlayer> createState() => _SimpleVideoPlayerState();
}

class _SimpleVideoPlayerState extends State<_SimpleVideoPlayer> {
  late VideoPlayerController _controller;
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    // Khởi tạo video từ assets
    _controller = VideoPlayerController.asset(widget.videoPath)
      ..initialize().then((_) {
        // Load xong thì cập nhật UI và chạy luôn
        setState(() {
          _isInitialized = true;
        });
        _controller.setLooping(true); // Lặp lại liên tục
        _controller.setVolume(0.0);   // Tắt tiếng mặc định (cho đỡ ồn)
        _controller.play();           // Tự động chạy
      });
  }

  @override
  void dispose() {
    _controller.dispose(); // Giải phóng bộ nhớ khi tắt dialog hoặc lướt qua
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_isInitialized) {
      return const Center(child: CircularProgressIndicator(color: kPrimaryYellow));
    }

    return Stack(
      alignment: Alignment.center,
      children: [
        // Video
        AspectRatio(
          aspectRatio: _controller.value.aspectRatio,
          child: VideoPlayer(_controller),
        ),

        // Nút Play/Pause ảo (chạm vào để dừng/chạy)
        Positioned.fill(
          child: GestureDetector(
            onTap: () {
              setState(() {
                _controller.value.isPlaying ? _controller.pause() : _controller.play();
              });
            },
            child: Container(
              color: Colors.transparent,
              child: _controller.value.isPlaying
                  ? null // Đang chạy thì không hiện icon
                  : Icon(Icons.play_circle_fill, size: 50.sp, color: kPrimaryYellow.withOpacity(0.8)),
            ),
          ),
        ),
      ],
    );
  }
}

// --- WIDGET 2: Dấu chấm chỉ trang (Indicator) - (Giữ nguyên) ---
class GuidePageIndicator extends StatelessWidget {
  final int count;
  final int currentIndex;
  final bool isDark;

  const GuidePageIndicator({
    Key? key,
    required this.count,
    required this.currentIndex,
    required this.isDark,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center, // Căn giữa cho đẹp
      children: List.generate(
        count,
            (index) => AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          margin: EdgeInsets.symmetric(horizontal: 4.w),
          height: 8.h,
          width: currentIndex == index ? 24.w : 8.w,
          decoration: BoxDecoration(
            color: currentIndex == index
                ? kPrimaryYellow
                : (isDark ? Colors.grey[700] : Colors.grey[300]),
            borderRadius: BorderRadius.circular(4.r),
          ),
        ),
      ),
    );
  }
}

// --- WIDGET 3: Nút Next/Start - (Giữ nguyên) ---
class GuideActionButton extends StatelessWidget {
  final bool isLastPage;
  final VoidCallback onPressed;

  const GuideActionButton({
    Key? key,
    required this.isLastPage,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: kPrimaryYellow,
        padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 12.h),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30.r),
        ),
        elevation: 4,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            isLastPage ? "Bắt đầu" : "Tiếp theo",
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: 16.sp,
            ),
          ),
          if (!isLastPage) ...[
            SizedBox(width: 8.w),
          ]
        ],
      ),
    );
  }
}