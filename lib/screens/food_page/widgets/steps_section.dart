import 'dart:io';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:chewie/chewie.dart';
import 'package:fontend/screens/Cooking_step/recipe_run_screen.dart';

class StepsSection extends StatelessWidget {
  final double width;
  const StepsSection({super.key, required this.width});

  final steps = const [
    {
      "number": 1,
      "text": "Hành mùi rửa sạch thái nhỏ, xương bò rửa sạch rồi cho vào nồi...",
      "type": "image",
      "path": [
        "image/p1.png",
        "image/p2.png"
      ]
    },
    {
      "number": 2,
      "text": "Thêm nước vào nồi, đun đến khi sôi thì vớt hết bọt...",
      "type": "video",
      "path": "video/naupho.mp4"
    },
    {
      "number": 3,
      "text": "Cho bánh phở vào bát, thêm hành mùi vào...",
      "type": "image",
      "path": "image/p3.png"
    }
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Text(
            "Cách làm :".tr(),
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
        ),
        const SizedBox(height: 20),

        ...steps.map((s) => _StepItem(
          number: s["number"] as int,
          text: s["text"] as String,
          path: s["path"],
          type: s["type"] as String,
        )),

        const SizedBox(height: 20),

        // Button Thực hiện món ăn
        Center(
          child: GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const RecipeRunScreen(),
                ),
              );
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 60, vertical: 20),
              decoration: BoxDecoration(
                color: const Color(0xFFFFD54F),
                borderRadius: BorderRadius.circular(32),
              ),
              child: Text(
                "Thực hiện món ăn".tr(),
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black),
              ),
            ),
          ),
        ),
        const SizedBox(height: 20),
      ],
    );
  }
}

class _StepItem extends StatelessWidget {
  final int number;
  final String text;
  final dynamic path;
  final String type;

  const _StepItem({
    required this.number,
    required this.text,
    required this.path,
    required this.type,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 20, bottom: 28, right: 20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text('$number', style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
              const SizedBox(width: 8),
              Container(width: 3, height: 50, color: Colors.green),
            ],
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  text,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.black.withOpacity(0.75),
                    height: 1.35,
                  ),
                ),
                const SizedBox(height: 10),
                _buildMediaContent(),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildMediaContent() {
    if (type == 'video') {
      return ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: SizedBox(
          height: 120,
          width: 200,
          child: _StepVideoPlayer(videoPath: path as String),
        ),
      );
    } else {
      if (path is List) {
        List<String> images = (path as List).cast<String>();
        return SizedBox(
          height: 120,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: images.length,
            separatorBuilder: (context, index) => const SizedBox(width: 10),
            itemBuilder: (context, index) {
              return ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.asset(
                  images[index],
                  width: 120,
                  height: 120,
                  fit: BoxFit.cover,
                ),
              );
            },
          ),
        );
      } else {
        return ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Image.asset(
            path as String,
            width: 120,
            height: 120,
            fit: BoxFit.cover,
          ),
        );
      }
    }
  }
}

class _StepVideoPlayer extends StatefulWidget {
  final String videoPath;
  const _StepVideoPlayer({super.key, required this.videoPath});

  @override
  State<_StepVideoPlayer> createState() => _StepVideoPlayerState();
}

class _StepVideoPlayerState extends State<_StepVideoPlayer> {
  late VideoPlayerController _videoController;
  ChewieController? _chewieController;

  @override
  void initState() {
    super.initState();
    initializePlayer();
  }

  Future<void> initializePlayer() async {
    _videoController = VideoPlayerController.asset(widget.videoPath);
    await _videoController.initialize();

    _chewieController = ChewieController(
      videoPlayerController: _videoController,
      autoPlay: false,
      looping: true,
      showControls: true,
      aspectRatio: _videoController.value.aspectRatio,
      errorBuilder: (context, errorMessage) {
        return Center(child: Text("Lỗi: $errorMessage", style: const TextStyle(fontSize: 10)));
      },
    );
    setState(() {});
  }

  @override
  void dispose() {
    _videoController.dispose();
    _chewieController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_chewieController != null && _videoController.value.isInitialized) {
      return Chewie(controller: _chewieController!);
    } else {
      return const Center(child: CircularProgressIndicator());
    }
  }
}