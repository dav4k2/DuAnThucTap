// lib/widgets/profile_tabs.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../logic/chef_provider.dart';

class ProfileTabs extends ConsumerStatefulWidget {
  const ProfileTabs({super.key});

  @override
  ConsumerState<ProfileTabs> createState() => _ProfileTabsState();
}

class _ProfileTabsState extends ConsumerState<ProfileTabs> {
  final Map<ProfileTab, double> _tabWidths = {};
  final Map<ProfileTab, double> _tabLefts = {};

  @override
  Widget build(BuildContext context) {
    final cur = ref.watch(profileTabProvider);
    final notifier = ref.read(profileTabProvider.notifier);

    return Stack(
      children: [
        // === CÁC TAB ===
        _buildTab('Công thức', ProfileTab.congThuc, cur, notifier),
        _buildTab('Tiểu sử', ProfileTab.tieuSu, cur, notifier),
        _buildTab('Ảnh', ProfileTab.anh, cur, notifier),
        _buildTab('Đánh giá', ProfileTab.danhGia, cur, notifier),

        // === THANH GẠCH DƯỚI ===
        if (_tabWidths[cur] != null && _tabLefts[cur] != null)
          AnimatedPositioned(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOutCubic,
            left: _tabLefts[cur]!,
            top: _getTop(cur) + 25.h, // Dịch xuống dưới chữ (khoảng cách tùy chỉnh)
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              width: _tabWidths[cur]!,
              height: 3.h,
              decoration: BoxDecoration(
                color: const Color(0xFFFFB901),
                borderRadius: BorderRadius.circular(15.r),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildTab(String text, ProfileTab tab, ProfileTab cur, StateController<ProfileTab> notifier) {
    final isActive = tab == cur;

    return Positioned(
      left: _getLeft(tab),
      top: _getTop(tab),
      child: GestureDetector(
        onTap: () => notifier.state = tab,
        child: LayoutBuilder(
          builder: (context, constraints) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              final renderBox = context.findRenderObject() as RenderBox?;
              if (renderBox != null && renderBox.hasSize) {
                final width = renderBox.size.width;
                final globalOffset = renderBox.localToGlobal(Offset.zero);
                final relativeLeft = globalOffset.dx; // DÙNG TRỰC TIẾP (không chia scale)

                if (_tabWidths[tab] != width || _tabLefts[tab] != relativeLeft) {
                  setState(() {
                    _tabWidths[tab] = width;
                    _tabLefts[tab] = relativeLeft;
                  });
                }
              }
            });

            return Text(
              text,
              style: TextStyle(
                color: isActive ? const Color(0xFFFFB901) : Colors.black,
                fontSize: 16.sp,
                fontWeight: FontWeight.w400,
                height: 1.38,
              ),
            );
          },
        ),
      ),
    );
  }

  double _getLeft(ProfileTab tab) => {
    ProfileTab.congThuc: 30.w,
    ProfileTab.tieuSu: 138.w,
    ProfileTab.anh: 224.w,
    ProfileTab.danhGia: 284.w,
  }[tab]!;

  double _getTop(ProfileTab tab) => {
    ProfileTab.congThuc: 500.h,
    ProfileTab.tieuSu: 500.h,
    ProfileTab.anh: 500.h,
    ProfileTab.danhGia: 500.h,
  }[tab]!;
}