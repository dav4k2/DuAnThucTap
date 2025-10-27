import 'package:flutter/material.dart';

class CustomNavBar extends StatefulWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const CustomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  State<CustomNavBar> createState() => _CustomNavBarState();
}

class _CustomNavBarState extends State<CustomNavBar> {
  final List<IconData> icons = [
    Icons.home_rounded,
    Icons.search_rounded,
    Icons.add_circle_outline_rounded,
    Icons.notifications_rounded,
    Icons.person_rounded,
  ];

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double barHeight = 66;
    final double highlightWidth = 30;
    final double iconSize = 36;
    final double sidePadding = 16; // responsive padding hai bên

    return Container(
      width: double.infinity, // full width màn hình
      height: barHeight,
      margin: EdgeInsets.symmetric(horizontal: sidePadding),
      decoration: ShapeDecoration(
        color: const Color(0xCCE6E6E6),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(48),
        ),
        shadows: const [
          BoxShadow(
            color: Color(0x3F000000),
            blurRadius: 4,
            offset: Offset(0, 4),
          )
        ],
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final double totalWidth = constraints.maxWidth;
          final double sectionWidth = totalWidth / icons.length;

          // Tính trung tâm của ô hiện tại
          final double centerX =
              (widget.currentIndex * sectionWidth) + sectionWidth / 2;

          return Stack(
            alignment: Alignment.center,
            children: [
              // animation thanh highlight
              AnimatedPositioned(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeOutCubic,
                left: centerX - (highlightWidth / 2),
                bottom: 10,
                child: Container(
                  width: highlightWidth,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(100),
                  ),
                ),
              ),

              // Row chứa icon
              Row(
                children: List.generate(icons.length, (index) {
                  final bool isActive = widget.currentIndex == index;
                  return Expanded(
                    child: Center(
                      child: GestureDetector(
                        onTap: () => widget.onTap(index),
                        child: AnimatedScale(
                          scale: isActive ? 1.15 : 1.0,
                          duration: const Duration(milliseconds: 180),
                          curve: Curves.easeOut,
                          child: Icon(
                            icons[index],
                            color: isActive ? Colors.black : Colors.grey,
                            size: iconSize,
                          ),
                        ),
                      ),
                    ),
                  );
                }),
              ),
            ],
          );
        },
      ),
    );
  }
}
