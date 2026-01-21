// lib/screens/search/Search_result/search_results_screen.dart
import 'dart:ui'; // Cần thiết cho ImageFilter (hiệu ứng mờ)

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fontend/screens/Searching/Search_result/widgets/search_results_tabs.dart';
import 'package:fontend/screens/Searching/search_content/search_screen.dart';

class SearchResultsScreen extends StatefulWidget {
  final String query;          // Từ khóa tìm kiếm (ví dụ: "Phở")
  final int initialTabIndex;   // Tab mặc định muốn mở (0: Công thức, 1: Đầu bếp)

  const SearchResultsScreen({
    super.key,
    required this.query,
    this.initialTabIndex = 0,
  });

  @override
  State<SearchResultsScreen> createState() => _SearchResultsScreenState();
}

// SingleTickerProviderStateMixin cần thiết để tạo Animation cho TabController
class _SearchResultsScreenState extends State<SearchResultsScreen>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    // Khởi tạo controller cho 2 tab
    _tabController = TabController(length: 2, vsync: this);

    // Logic: Đợi frame đầu tiên vẽ xong thì mới chuyển tab (để tránh lỗi layout)
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_tabController.index != widget.initialTabIndex) {
        _tabController.animateTo(widget.initialTabIndex);
      }
    });
  }

  @override
  void dispose() {
    _tabController.dispose(); // Giải phóng bộ nhớ controller khi thoát màn hình
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Kiểm tra chế độ Sáng/Tối
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // WillPopScope: Bắt sự kiện nút Back vật lý trên Android hoặc vuốt back trên iOS
    return WillPopScope(
      onWillPop: () async {
        // Khi back, thay vì pop thông thường, ta chuyển về trang SearchScreen
        // để người dùng có thể tiếp tục tìm kiếm từ khóa khác
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => SearchScreen(initialQuery: widget.query)),
        );
        return false; // Chặn hành động back mặc định
      },
      child: Scaffold(
        backgroundColor: const Color(0xFFFFB901), // Nền màu vàng chủ đạo

        // AppBar tùy chỉnh kích thước
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(120.h), // Chiều cao bao gồm cả thanh search và tab bar
          child: AppBar(
            backgroundColor: const Color(0xFFFFB901),
            elevation: 0, // Bỏ bóng đổ
            automaticallyImplyLeading: false, // Tắt nút back mặc định
            titleSpacing: 0,

            // --- PHẦN 1: THANH TÌM KIẾM VÀ NÚT BACK ---
            title: Stack(
              alignment: Alignment.center,
              children: [
                // Nút Back nhỏ bên trái
                Positioned(
                  left: 1.w,
                  child: IconButton(
                    icon: Icon(Icons.arrow_back, color: isDark ? Colors.white : Colors.black),
                    onPressed: () {
                      // Quay lại màn hình nhập liệu
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (_) => SearchScreen(initialQuery: widget.query)),
                      );
                    },
                  ),
                ),

                // Thanh hiển thị từ khóa (Giả lập Input)
                Center(
                  child: GestureDetector(
                    onTap: () {
                      // Khi bấm vào thanh này -> Quay lại màn hình nhập liệu để sửa từ khóa
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (_) => SearchScreen(initialQuery: widget.query)),
                      );
                    },
                    child: Container(
                      height: 50.h,
                      margin: EdgeInsets.symmetric(horizontal: 42.w),
                      decoration: BoxDecoration(
                        color: isDark ? Colors.black.withOpacity(0.2) : Colors.white,
                        border: Border.all(
                          color: isDark ? Colors.white54 : Colors.black26,
                          width: 1.2,
                        ),
                        borderRadius: BorderRadius.circular(50),
                      ),
                      child: Row(
                        children: [
                          SizedBox(width: 20.w),
                          Icon(
                            Icons.search,
                            color: isDark ? Colors.white70 : Colors.black54,
                            size: 24,
                          ),
                          SizedBox(width: 16.w),
                          // Hiển thị từ khóa hiện tại
                          Expanded(
                            child: Text(
                              widget.query,
                              style: TextStyle(
                                color: isDark ? Colors.white : Colors.black,
                                fontSize: 14.5.sp,
                                fontWeight: FontWeight.w500,
                              ),
                              overflow: TextOverflow.ellipsis, // Cắt bớt nếu chữ quá dài (...)
                            ),
                          ),
                          SizedBox(width: 20.w),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),

            // --- PHẦN 2: TAB BAR (CÔNG THỨC / ĐẦU BẾP) ---
            bottom: PreferredSize(
              preferredSize: Size.fromHeight(60.h),
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 40.w, vertical: 8.h),
                // ClipRRect để bo tròn hiệu ứng mờ
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(30.r),
                  // BackdropFilter: Tạo hiệu ứng kính mờ (Blur background)
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
                    child: Container(
                      decoration: BoxDecoration(
                        color: isDark
                            ? Colors.black.withOpacity(0.5)   // Dark mode: Kính đen trong suốt
                            : Colors.white.withOpacity(0.72), // Light mode: Kính trắng trong suốt
                        borderRadius: BorderRadius.circular(30.r),
                        border: Border.all(
                          color: isDark
                              ? Colors.white.withOpacity(0.18)
                              : Colors.white.withOpacity(0.9),
                          width: 1.1,
                        ),
                      ),
                      child: TabBar(
                        controller: _tabController,
                        dividerHeight: 0, // Bỏ gạch chân mặc định của TabBar mới
                        dividerColor: Colors.transparent,
                        overlayColor: WidgetStateProperty.all(Colors.transparent), // Bỏ hiệu ứng loang màu khi bấm
                        splashFactory: NoSplash.splashFactory, // Bỏ hiệu ứng giọt nước

                        // Trang trí nút đang chọn (Indicator)
                        indicator: BoxDecoration(
                          color: isDark ? Colors.orange.shade400 : Colors.orange.shade400,
                          borderRadius: BorderRadius.circular(30.r),
                        ),
                        indicatorSize: TabBarIndicatorSize.tab, // Indicator phủ kín tab
                        indicatorPadding: EdgeInsets.all(6.w),  // Padding để indicator nhỏ hơn khung viền một chút

                        labelColor: Colors.white, // Màu chữ khi chọn
                        unselectedLabelColor: isDark ? Colors.white70 : Colors.black54, // Màu chữ khi chưa chọn
                        labelStyle: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.w700),
                        unselectedLabelStyle: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w500),

                        tabs: const [
                          Tab(text: 'Công thức'),
                          Tab(text: 'Đầu bếp'),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),

        // --- PHẦN BODY: NỘI DUNG TABS ---
        body: Container(
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF121212) : Colors.white,
            // Bo tròn góc trên để tạo hiệu ứng "Card sheet" đè lên nền vàng
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(30),
              topRight: Radius.circular(30),
            ),
          ),
          // ClipRRect để nội dung bên trong (List) không bị tràn ra ngoài góc bo
          child: ClipRRect(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(30),
              topRight: Radius.circular(30),
            ),
            // Widget con hiển thị danh sách kết quả (được tách ra file riêng)
            child: SearchResultsTabs(
              tabController: _tabController,
              query: widget.query,
            ),
          ),
        ),
      ),
    );
  }
}