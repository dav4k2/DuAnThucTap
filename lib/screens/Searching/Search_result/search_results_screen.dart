// lib/screens/search/Search_result/search_results_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fontend/screens/Searching/Search_result/widgets/search_results_tabs.dart';
import 'package:fontend/screens/Searching/search_content/search_screen.dart';

class SearchResultsScreen extends StatefulWidget {
  final String query;
  final int initialTabIndex;

  const SearchResultsScreen({
    super.key,
    required this.query,
    this.initialTabIndex = 0,
  });

  @override
  State<SearchResultsScreen> createState() => _SearchResultsScreenState();
}

class _SearchResultsScreenState extends State<SearchResultsScreen>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_tabController.index != widget.initialTabIndex) {
        _tabController.animateTo(widget.initialTabIndex);
      }
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        // KHI BẤM NÚT BACK (HỆ THỐNG HOẶC NÚT TRÁI) → BACK VỀ TRANG TÌM KIẾM
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => SearchScreen(initialQuery: widget.query),
          ),
        );
        return false; // ngăn pop mặc định
      },
      child: Scaffold(
        backgroundColor: const Color(0xFFFFB901),
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(120.h),
          child: AppBar(
            backgroundColor: const Color(0xFFFFB901),
            elevation: 0,
            automaticallyImplyLeading: false,
            titleSpacing: 0,
            title: Stack(
              alignment: Alignment.center,
              children: [
                // NÚT BACK TRÁI → CŨNG BACK VỀ TRANG TÌM KIẾM
                Positioned(
                  left: 1.w,
                  child: IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.black),
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (_) => SearchScreen(initialQuery: widget.query),
                        ),
                      );
                    },
                  ),
                ),

                // THANH TÌM KIẾM → MỞ LẠI TRANG TÌM KIẾM (GIỮ GỢI Ý)
                Center(
                  child: GestureDetector(
                    onTap: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (_) => SearchScreen(initialQuery: widget.query),
                        ),
                      );
                    },
                    child: Container(
                      height: 50.h,
                      width: 0.8.sw,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(30.r),
                        border: Border.all(color: Colors.black.withOpacity(0.3), width: 1.2),
                        boxShadow: [
                          BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 8, offset: const Offset(0, 2)),
                        ],
                      ),
                      child: Row(
                        children: [
                          SizedBox(width: 16.w),
                          const Icon(Icons.search, color: Colors.black54, size: 22),
                          SizedBox(width: 12.w),
                          Expanded(
                            child: Text(
                              widget.query,
                              style: TextStyle(color: Colors.black, fontSize: 16.sp, fontWeight: FontWeight.w500),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          SizedBox(width: 8.w),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            bottom: TabBar(
              controller: _tabController,
              labelColor: Colors.black,
              unselectedLabelColor: Colors.black54,
              indicatorColor: Colors.black,
              indicatorWeight: 3, // tăng độ dày của line
              labelStyle: TextStyle(fontSize: 22.sp, fontWeight: FontWeight.w600), // chữ to hơn khi active
              unselectedLabelStyle: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w500), // chữ tab bình thường
              tabs: const [
                Tab(text: 'Công thức'),
                Tab(text: 'Đầu bếp'),
              ],
            ),

          ),
        ),

        body: Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(topLeft: Radius.circular(30), topRight: Radius.circular(30)),
          ),
          child: SearchResultsTabs(tabController: _tabController),
        ),
      ),
    );
  }
}