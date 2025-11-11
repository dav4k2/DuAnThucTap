// lib/widgets/smart_nav_bar.dart
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
    _controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 300));
    _setupAnimations(widget.currentIndex.toDouble());
    widget.scrollController.addListener(_checkScroll);
  }

  void _setupAnimations(double targetIndex) {
    _positionAnimation = Tween<double>(begin: targetIndex, end: targetIndex).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOutCubic),
    );
  }

  @override
  void didUpdateWidget(SmartNavBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.currentIndex != widget.currentIndex) {
      final beginPos = _positionAnimation.value;
      _positionAnimation = Tween<double>(
        begin: beginPos,
        end: widget.currentIndex.toDouble(),
      ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOutCubic));

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

  double _calculateScale(double progress) {
    const double peakScale = 1.3;
    const double baseScale = 1.0;
    final double t = progress - 0.5;
    final double parabola = 1 - 4 * t * t;
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
                    AnimatedBuilder(
                      animation: _controller,
                      builder: (context, _) {
                        final progress = _controller.value;
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
                            _getIconPath(index),
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
      String iconPath,
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
            Image.asset(
              iconPath,
              width: isActive ? 30.w : 25.w,
              height: isActive ? 30.w : 25.w,
              color: isActive ? active : inactive,
            ),
            SizedBox(height: 2.h),
            Text(
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
          ],
        ),
      ),
    );
  }

  /// 🔥 Thay IconData bằng đường dẫn tới icon trong assets
  String _getIconPath(int index) {
    const icons = [
      'image/home_navbar.png',
      'image/search2.png',
      'image/new_navbar.png',
      'image/profile_navbar.png',
      'image/Setting_navbar.png',
    ];
    return icons[index];
  }

  String _getLabel(int index) {
    const labels = ["Trang chủ", "Tìm kiếm", "Tạo C.Thức", "Hồ sơ", "Cài đặt"];
    return labels[index];
  }
}
