import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:palette_generator/palette_generator.dart';

class SmartNavBar extends StatefulWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;
  final ScrollController scrollController;

  const SmartNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
    required this.scrollController,
  });

  @override
  State<SmartNavBar> createState() => _SmartNavBarState();
}

class _SmartNavBarState extends State<SmartNavBar> with SingleTickerProviderStateMixin {
  bool isDarkBackground = false;
  late AnimationController _controller;
  late Animation<double> _positionAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300), // Mượt hơn
    );
    _setupAnimations(widget.currentIndex.toDouble());
    widget.scrollController.addListener(_checkScroll);
  }

  void _setupAnimations(double targetIndex) {
    _positionAnimation = Tween<double>(
      begin: targetIndex,
      end: targetIndex,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOutCubic,
    ));
  }

  @override
  void didUpdateWidget(SmartNavBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.currentIndex != widget.currentIndex) {
      final beginPos = _positionAnimation.value;
      _positionAnimation = Tween<double>(
        begin: beginPos,
        end: widget.currentIndex.toDouble(),
      ).animate(CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOutCubic,
      ));

      _controller
        ..reset()
        ..forward();
    }
  }

  @override
  void dispose() {
    widget.scrollController.removeListener(_checkScroll);
    _controller.dispose();
    super.dispose();
  }

  void _checkScroll() async {
    try {
      final color = await PaletteGenerator.fromImageProvider(
        const AssetImage('assets/sample_bg.jpg'),
        maximumColorCount: 8,
      );
      final brightness = color.dominantColor?.color.computeLuminance() ?? 0.5;
      final dark = brightness < 0.5;
      if (dark != isDarkBackground) {
        setState(() => isDarkBackground = dark);
      }
    } catch (_) {}
  }

  // Hàm tính scale theo tiến trình (parabol, đỉnh ở giữa)
  double _calculateScale(double progress) {
    const double peakScale = 1.3;
    const double baseScale = 1.0;
    final double t = progress - 0.5;
    final double parabola = 1 - 4 * t * t; // 1 ở giữa, 0 ở hai đầu
    return baseScale + (peakScale - baseScale) * parabola;
  }

  @override
  Widget build(BuildContext context) {
    final bgColor = isDarkBackground
        ? Colors.white.withValues(alpha: 0.1)
        : Colors.black.withValues(alpha: 0.1);
    final borderColor = isDarkBackground
        ? Colors.white.withValues(alpha: 0.2)
        : Colors.black.withValues(alpha: 0.2);
    final inactiveColor = isDarkBackground ? Colors.white70 : Colors.black87;
    final activeColor = isDarkBackground ? Colors.white : Colors.black;

    return Padding(
      padding: EdgeInsets.only(bottom: 25.w, left: 8, right: 8),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(30.r),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 9, sigmaY: 9),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            height: 65.h,
            decoration: BoxDecoration(
              color: bgColor,
              borderRadius: BorderRadius.circular(30.r),
              border: Border.all(color: borderColor),
            ),
            child: LayoutBuilder(
              builder: (context, constraints) {
                final itemWidth = constraints.maxWidth / 5;

                return Stack(
                  alignment: Alignment.center,
                  children: [
                    // Highlight bubble: di chuyển + scale theo hành trình
                    AnimatedBuilder(
                      animation: _controller,
                      builder: (context, _) {
                        final progress = _controller.value; // 0.0 -> 1.0
                        final currentIndex = _positionAnimation.value;
                        final targetX = (currentIndex - 2) * itemWidth;
                        final scale = _calculateScale(progress);

                        return Transform.translate(
                          offset: Offset(targetX, 0),
                          child: Transform.scale(
                            scale: scale,
                            alignment: Alignment.center,
                            child: Container(
                              width: 75.w,
                              height: 67.h,
                              margin: EdgeInsets.symmetric(vertical: 3.h),
                              decoration: BoxDecoration(
                                color: activeColor.withValues(alpha: 0.15),
                                borderRadius: BorderRadius.circular(30.r),
                              ),
                            ),
                          ),
                        );
                      },
                    ),

                    // 5 tab items
                    Row(
                      children: List.generate(5, (index) {
                        return Expanded(
                          child: _buildItem(
                            _getIcon(index),
                            _getLabel(index),
                            index,
                            activeColor,
                            inactiveColor,
                          ),
                        );
                      }),
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildItem(
      IconData icon,
      String label,
      int index,
      Color active,
      Color inactive,
      ) {
    final isActive = index == widget.currentIndex;
    return GestureDetector(
      onTap: () => widget.onTap(index),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 8.h),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: isActive ? 30.sp : 25.sp,
              color: isActive ? active : inactive,
            ),
            SizedBox(height: 0.h),
            SizedBox(
              width: double.infinity,
              child: Text(
                label,
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: isActive ? active : inactive,
                  fontSize: 10.sp,
                  fontWeight: isActive ? FontWeight.w600 : FontWeight.normal,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  IconData _getIcon(int index) {
    const icons = [
      Icons.home_outlined,
      Icons.grid_view_rounded,
      Icons.wifi_tethering_rounded,
      Icons.library_music_rounded,
      Icons.person_outline_rounded,
    ];
    return icons[index];
  }

  String _getLabel(int index) {
    const labels = ["Home", "New", "Radio", "Library", "Profile"];
    return labels[index];
  }
}