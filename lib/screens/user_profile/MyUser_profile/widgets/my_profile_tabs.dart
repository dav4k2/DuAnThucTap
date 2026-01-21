import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../logic/my_profile_provider.dart';
import 'package:easy_localization/easy_localization.dart';

// Class phụ để lưu trữ dữ liệu của từng Tab cho gọn code
class _TabItem {
  final ProfileTab tab; // Enum định danh (Công thức, Tiêu sử...)
  final String text;    // Tên hiển thị
  const _TabItem(this.tab, this.text);
}

class MyProfileTabs extends ConsumerStatefulWidget {
  const MyProfileTabs({super.key});

  @override
  ConsumerState<MyProfileTabs> createState() => _MyProfileTabsState();
}

class _MyProfileTabsState extends ConsumerState<MyProfileTabs> {
  // Lưu chiều rộng thực tế của từng Tab (để thanh gạch chân co giãn theo chữ)
  final Map<ProfileTab, double> _tabWidths = {};

  // Lưu vị trí toạ độ X (trái) của từng Tab (để thanh gạch chân biết chạy đến đâu)
  final Map<ProfileTab, double> _tabLefts = {};

  final double _tabSpacing = 30.w; // Khoảng cách giữa các Tab
  final double _tabTopPosition = 500.h; // Vị trí cố định từ trên xuống (trong Stack)

  // Danh sách các Tabs
  final List<_TabItem> _tabs = [
    _TabItem(ProfileTab.congThuc, 'Công thức'.tr()),
    _TabItem(ProfileTab.tieuSu, 'Tiểu sử'.tr()),
    _TabItem(ProfileTab.anh, 'Yêu thích'.tr()),
  ];

  @override
  void initState() {
    super.initState();
    // Khởi tạo toạ độ ban đầu là 0
    for (final item in _tabs) {
      _tabLefts[item.tab] = 0.0;
    }
  }

  // --- LOGIC TÍNH TOÁN VỊ TRÍ THANH GẠCH CHÂN ---
  void _updateTabPositions() {
    // Chỉ tính toán khi đã đo được chiều rộng của tất cả các text
    if (_tabWidths.length != _tabs.length) return;

    // 1. Tính tổng chiều rộng của cả hàng Tab (bao gồm chữ + khoảng cách)
    double totalWidth = 0.0;
    for (final item in _tabs) {
      totalWidth += _tabWidths[item.tab]! + _tabSpacing;
    }
    totalWidth -= _tabSpacing; // Trừ đi khoảng cách thừa ở cuối cùng

    // 2. Tính toán điểm bắt đầu để CĂN GIỮA (Center) hàng Tab trên màn hình
    final screenWidth = MediaQuery.of(context).size.width;
    double startLeft = (screenWidth - totalWidth) / 2;

    // 3. Gán toạ độ Left cho từng Tab cụ thể
    double currentLeft = startLeft;
    bool needsUpdate = false;

    for (final item in _tabs) {
      final tab = item.tab;
      final width = _tabWidths[tab]!;

      // Nếu vị trí thay đổi so với cũ thì mới cập nhật
      if (_tabLefts[tab] != currentLeft) {
        _tabLefts[tab] = currentLeft;
        needsUpdate = true;
      }

      // Cộng dồn để tính toạ độ cho Tab tiếp theo
      currentLeft += width + _tabSpacing;
    }

    // Nếu có thay đổi vị trí, render lại màn hình để Animation chạy
    if (needsUpdate && mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    // Lắng nghe Tab đang chọn từ Riverpod
    final cur = ref.watch(myProfileTabProvider);
    final notifier = ref.read(myProfileTabProvider.notifier);

    final textColor = Theme.of(context).textTheme.bodyMedium!.color!;
    final activeColor = const Color(0xFFFFB901); // Màu vàng khi active

    // Sau khi build xong frame, gọi hàm tính toán lại vị trí (đề phòng xoay màn hình hoặc đổi ngôn ngữ)
    if (_tabWidths.length == _tabs.length) {
      WidgetsBinding.instance.addPostFrameCallback((_) => _updateTabPositions());
    }

    return Stack(
      children: [

        // --- LỚP 1: HIỂN THỊ CHỮ (TEXT TABS) ---
        Positioned(
          top: _tabTopPosition,
          left: 0,
          right: 0,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center, // Căn giữa Text
            mainAxisSize: MainAxisSize.max,
            children: _tabs.map((item) {
              final tab = item.tab;
              final text = item.text;

              return Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _buildTab(text, tab, cur, notifier, textColor, activeColor),
                  // Thêm khoảng cách giữa các tab, trừ tab cuối cùng
                  if (tab != _tabs.last.tab) SizedBox(width: _tabSpacing),
                ],
              );
            }).toList(),
          ),
        ),

        // --- LỚP 2: THANH GẠCH DƯỚI (ANIMATED UNDERLINE) ---
        // Chỉ hiện khi đã tính toán xong vị trí và độ rộng
        if (_tabWidths[cur] != null && _tabLefts[cur] != null)
          AnimatedPositioned(
            duration: const Duration(milliseconds: 300), // Thời gian chạy animation
            curve: Curves.easeInOutCubic, // Hiệu ứng chuyển động mượt
            left: _tabLefts[cur]!, // Vị trí trái (đã tính toán ở trên)
            top: _tabTopPosition + 25.h, // Vị trí dưới chữ một chút
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300), // Thời gian co giãn width
              width: _tabWidths[cur]!, // Độ rộng bằng đúng độ rộng của chữ
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

  // Hàm build từng cái Text Tab
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
      onTap: () => notifier.state = tab, // Cập nhật state khi bấm
      child: LayoutBuilder(
        builder: (context, constraints) {
          // --- LOGIC ĐO ĐỘ RỘNG CHỮ ---
          // Callback này chạy ngay sau khi Text được vẽ xong
          WidgetsBinding.instance.addPostFrameCallback((_) {
            final renderBox = context.findRenderObject() as RenderBox?;
            final width = renderBox?.size.width ?? 0.0;

            // Nếu độ rộng đo được khác với cái đang lưu -> Cập nhật lại
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