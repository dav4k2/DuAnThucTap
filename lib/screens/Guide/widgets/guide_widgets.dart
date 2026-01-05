import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:video_player/video_player.dart';
import '../model/guide_model.dart';
import '../logic/guide_provider.dart';

const Color kPrimaryYellow = Color(0xFFFFB901);

// --- WIDGET 1: Hộp hiển thị Media ---
class GuideMediaBox extends ConsumerWidget {
  final int index;
  final String path;
  final MediaType type;
  final bool isDark;

  const GuideMediaBox({
    Key? key,
    required this.index,
    required this.path,
    required this.type,
    required this.isDark,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Lấy index trang hiện tại
    final currentIndex = ref.watch(guideProvider);

    // Logic: Chỉ render VideoPlayer khi index trùng khớp
    final bool isFocused = (index == currentIndex);

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
          fit: BoxFit.contain,
          errorBuilder: (_, __, ___) => Center(
            child: Icon(Icons.image_not_supported, size: 40.sp, color: Colors.grey),
          ),
        )
            : (isFocused
            ? _SingletonVideoPlayer(videoPath: path) // Dùng Widget Video mới
            : _VideoPlaceholder(isDark: isDark)),
      ),
    );
  }
}

// --- WIDGET VIDEO PLACEHOLDER ---
class _VideoPlaceholder extends StatelessWidget {
  final bool isDark;
  const _VideoPlaceholder({required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black12,
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.movie_creation_outlined,
                size: 50.sp, color: isDark ? Colors.white24 : Colors.black26),
            SizedBox(height: 8.h),
            Text("Đang chuẩn bị...".tr(),
                style: TextStyle(
                    fontSize: 12.sp, color: isDark ? Colors.white24 : Colors.black26))
          ],
        ),
      ),
    );
  }
}

// --- WIDGET VIDEO PLAYER  ---
class _SingletonVideoPlayer extends StatefulWidget {
  final String videoPath;
  const _SingletonVideoPlayer({required this.videoPath});

  @override
  State<_SingletonVideoPlayer> createState() => _SingletonVideoPlayerState();
}

class _SingletonVideoPlayerState extends State<_SingletonVideoPlayer> {
  VideoPlayerController? _controller;
  bool _isInitialized = false;
  Timer? _debounceTimer;

  @override
  void initState() {
    super.initState();
    _debounceTimer = Timer(const Duration(milliseconds: 300), () {
      if (mounted) {
        _initializeVideo();
      }
    });
  }

  Future<void> _initializeVideo() async {
    // Tạo controller mới
    final controller = VideoPlayerController.asset(
      widget.videoPath,
      videoPlayerOptions: VideoPlayerOptions(mixWithOthers: true),
    );

    try {
      await controller.initialize();
      await controller.setVolume(0.0);
      await controller.setLooping(true);

      if (mounted) {
        setState(() {
          _controller = controller;
          _isInitialized = true;
        });
        await controller.play();
      } else {
        // Nếu widget bị unmount trong lúc đang init -> dispose ngay
        await controller.dispose();
      }
    } catch (e) {
      debugPrint("Lỗi khởi tạo video: $e");
      // Nếu có lỗi, cố gắng dispose để không leak
      try {
        await controller.dispose();
      } catch (_) {}
    }
  }

  @override
  void dispose() {
    // 1. Hủy timer nếu widget bị tắt trước khi kịp load video (fix lỗi lướt nhanh)
    _debounceTimer?.cancel();

    // 2. Dispose controller hiện tại một cách an toàn
    final oldController = _controller;
    _controller = null;
    oldController?.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Trong lúc chờ debounce hoặc đang load, hiện loading
    if (!_isInitialized || _controller == null) {
      return const Center(
          child: SizedBox(
              width: 30,
              height: 30,
              child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: kPrimaryYellow
              )
          )
      );
    }

    return Stack(
      alignment: Alignment.center,
      children: [
        AspectRatio(
          aspectRatio: _controller!.value.aspectRatio,
          child: VideoPlayer(_controller!),
        ),
        // Overlay nút Play/Pause
        Positioned.fill(
          child: GestureDetector(
            onTap: () {
              if (_controller != null && _controller!.value.isInitialized) {
                setState(() {
                  _controller!.value.isPlaying
                      ? _controller!.pause()
                      : _controller!.play();
                });
              }
            },
            child: Container(
              color: Colors.transparent,
              child: !_controller!.value.isPlaying
                  ? Icon(Icons.play_circle_fill,
                  size: 50.sp, color: kPrimaryYellow.withOpacity(0.8))
                  : null,
            ),
          ),
        ),
      ],
    );
  }
}

// --- GuidePageIndicator & GuideActionButton (Giữ nguyên) ---
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
      mainAxisAlignment: MainAxisAlignment.center,
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
            isLastPage ? "Bắt đầu".tr() : "Tiếp theo".tr(),
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: 16.sp,
            ),
          ),
          if (!isLastPage) ...[SizedBox(width: 8.w)],
        ],
      ),
    );
  }
}