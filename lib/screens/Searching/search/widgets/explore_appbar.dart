// lib/screens/search/widgets/explore_appbar.dart
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ExploreAppBar extends StatefulWidget {
  final double width;
  final TextEditingController? controller; // Nhận controller từ bên ngoài nếu cần
  final Function(String)? onSubmitted;

  const ExploreAppBar({super.key, required this.width, this.controller, this.onSubmitted});

  @override
  State<ExploreAppBar> createState() => _ExploreAppBarState();
}

class _ExploreAppBarState extends State<ExploreAppBar> {
  late TextEditingController _internalController;

  @override
  void initState() {
    super.initState();
    // Sử dụng controller truyền vào hoặc tạo mới
    _internalController = widget.controller ?? TextEditingController();
    // Lắng nghe để cập nhật giao diện (hiện/ẩn nút X) khi gõ chữ
    _internalController.addListener(() => setState(() {}));
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Container(
      width: widget.width,
      color: const Color(0xFFFFC221),
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top,
        left: 16.w,
        right: 16.w,
        bottom: 10.h,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  'Khám phá'.tr(),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 20.sp,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ),
              const SizedBox(width: 40),
            ],
          ),
          SizedBox(height: 12.h),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 20.w),
            decoration: BoxDecoration(
              color: isDarkMode ? Colors.black.withOpacity(0.2) : Colors.white,
              border: Border.all(
                color: isDarkMode ? Colors.white54 : Colors.black26,
                width: 1.2,
              ),
              borderRadius: BorderRadius.circular(50),
            ),
            child: TextField(
              controller: _internalController,
              onSubmitted: widget.onSubmitted,
              textInputAction: TextInputAction.search,
              style: TextStyle(
                color: isDarkMode ? Colors.white : Colors.black,
                fontSize: 14.5.sp,
              ),
              decoration: InputDecoration(
                hintText: 'Nhập tên món ăn hoặc nguyên liệu...'.tr(),
                hintStyle: TextStyle(
                  color: isDarkMode ? Colors.white70 : Colors.black54,
                  fontSize: 14.5.sp,
                ),
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 14.h),
                prefixIcon: Icon(
                  Icons.search,
                  color: isDarkMode ? Colors.white70 : Colors.black54,
                  size: 24,
                ),
                // Nút X: Chỉ hiện khi có chữ
                suffixIcon: _internalController.text.isNotEmpty
                    ? IconButton(
                  icon: Icon(Icons.cancel, color: isDarkMode ? Colors.white70 : Colors.black54),
                  onPressed: () {
                    _internalController.clear();
                    setState(() {});
                  },
                )
                    : null,
              ),
            ),
          ),
        ],
      ),
    );
  }
}