import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../logic/my_profile_provider.dart';
import 'package:easy_localization/easy_localization.dart';

// Helper class for tab item data
class _TabItem {
  final ProfileTab tab;
  final String text;
  const _TabItem(this.tab, this.text);
}

class MyProfileTabs extends ConsumerStatefulWidget {
  const MyProfileTabs({super.key});

  @override
  ConsumerState<MyProfileTabs> createState() => _MyProfileTabsState();
}

class _MyProfileTabsState extends ConsumerState<MyProfileTabs> {
  final Map<ProfileTab, double> _tabWidths = {};
  final Map<ProfileTab, double> _tabLefts = {};

  final double _tabSpacing = 30.w;
  final double _tabTopPosition = 500.h;

  final List<_TabItem> _tabs = [
    _TabItem(ProfileTab.congThuc, 'Công thức'.tr()),
    _TabItem(ProfileTab.tieuSu, 'Tiểu sử'.tr()),
    _TabItem(ProfileTab.anh, 'Chờ duyệt'.tr()),
    _TabItem(ProfileTab.danhGia, 'Đánh giá'.tr()),
  ];

  @override
  void initState() {
    super.initState();
    for (final item in _tabs) {
      _tabLefts[item.tab] = 0.0;
    }
  }

  void _updateTabPositions() {
    if (_tabWidths.length != _tabs.length) return;

    double totalWidth = 0.0;
    for (final item in _tabs) {
      totalWidth += _tabWidths[item.tab]! + _tabSpacing;
    }
    totalWidth -= _tabSpacing; // bỏ spacing cuối cùng

    final screenWidth = MediaQuery.of(context).size.width;
    double startLeft = (screenWidth - totalWidth) / 2; //  CĂN GIỮA Ở ĐÂY

    double currentLeft = startLeft;
    bool needsUpdate = false;

    for (final item in _tabs) {
      final tab = item.tab;
      final width = _tabWidths[tab]!;

      if (_tabLefts[tab] != currentLeft) {
        _tabLefts[tab] = currentLeft;
        needsUpdate = true;
      }

      currentLeft += width + _tabSpacing;
    }

    if (needsUpdate && mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    final cur = ref.watch(myProfileTabProvider);
    final notifier = ref.read(myProfileTabProvider.notifier);

    final textColor = Theme.of(context).textTheme.bodyMedium!.color!;
    final activeColor = const Color(0xFFFFB901);

    if (_tabWidths.length == _tabs.length) {
      WidgetsBinding.instance.addPostFrameCallback((_) => _updateTabPositions());
    }

    return Stack(
      children: [

        //  DÃY TAB (CĂN GIỮA)

        Positioned(
          top: _tabTopPosition,
          left: 0,
          right: 0,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center, //  CHỈNH Ở ĐÂY
            mainAxisSize: MainAxisSize.max,
            children: _tabs.map((item) {
              final tab = item.tab;
              final text = item.text;

              return Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _buildTab(text, tab, cur, notifier, textColor, activeColor),
                  if (tab != _tabs.last.tab) SizedBox(width: _tabSpacing),
                ],
              );
            }).toList(),
          ),
        ),


        // THANH GẠCH DƯỚI ANIMATION

        if (_tabWidths[cur] != null && _tabLefts[cur] != null)
          AnimatedPositioned(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOutCubic,
            left: _tabLefts[cur]!,
            top: _tabTopPosition + 25.h,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              width: _tabWidths[cur]!,
              height: 3.h,
              decoration: BoxDecoration(
                color: activeColor,
                borderRadius: BorderRadius.circular(15.r),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildTab(
      String text,
      ProfileTab tab,
      ProfileTab cur,
      StateController<ProfileTab> notifier,
      Color textColor,
      Color activeColor,
      ) {
    final isActive = tab == cur;

    return GestureDetector(
      onTap: () => notifier.state = tab,
      child: LayoutBuilder(
        builder: (context, constraints) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            final renderBox = context.findRenderObject() as RenderBox?;
            final width = renderBox?.size.width ?? 0.0;

            if (_tabWidths[tab] != width && width > 0) {
              setState(() {
                _tabWidths[tab] = width;
              });
            }
          });

          return Text(
            text,
            style: TextStyle(
              color: isActive ? activeColor : textColor,
              fontSize: 16.sp,
              fontWeight: FontWeight.w600,
              height: 1.38,
            ),
          );
        },
      ),
    );
  }
}