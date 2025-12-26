// lib/screens/search/Search_result/search_results_screen.dart
import 'dart:ui';

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
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return WillPopScope(
      onWillPop: () async {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => SearchScreen(initialQuery: widget.query)),
        );
        return false;
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
                // Nút back
                Positioned(
                  left: 1.w,
                  child: IconButton(
                    icon: Icon(Icons.arrow_back, color: isDark ? Colors.white : Colors.black),
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (_) => SearchScreen(initialQuery: widget.query)),
                      );
                    },
                  ),
                ),

                // THANH TÌM KIẾM – ĐÃ ĐỒNG BỘ 100% VỚI EXPLOREAPPBAR
                Center(
                  child: GestureDetector(
                    onTap: () {
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
                          Expanded(
                            child: Text(
                              widget.query,
                              style: TextStyle(
                                color: isDark ? Colors.white : Colors.black,
                                fontSize: 14.5.sp,
                                fontWeight: FontWeight.w500,
                              ),
                              overflow: TextOverflow.ellipsis,
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

            // TAB BAR – ĐÃ FIX GẠCH NGANG + ĐẸP CHO CẢ LIGHT & DARK
              bottom: PreferredSize(
                preferredSize: Size.fromHeight(60.h),
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: 40.w, vertical: 8.h),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(30.r),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
                      child: Container(
                        decoration: BoxDecoration(

                          color: isDark
                              ? Colors.black.withOpacity(0.5)   // Dark: kính đen cực trong, sang trọng
                              : Colors.white.withOpacity(0.72),
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
                          dividerHeight: 0,
                          dividerColor: Colors.transparent,

                          overlayColor: WidgetStateProperty.all(Colors.transparent),
                          splashFactory: NoSplash.splashFactory,


                          indicator: BoxDecoration(
                            color: isDark ? Colors.orange.shade400 : Colors.orange.shade400,
                            borderRadius: BorderRadius.circular(30.r),
                          ),
                          indicatorSize: TabBarIndicatorSize.tab,
                          indicatorPadding: EdgeInsets.all(6.w),

                          labelColor: Colors.white,
                          unselectedLabelColor: isDark ? Colors.white70 : Colors.black54,
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

        // BODY – KÍN MÀN HÌNH, KHÔNG HỞ VÀNG
        body: Container(
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF121212) : Colors.white,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(30),
              topRight: Radius.circular(30),
            ),
          ),
          child: ClipRRect(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(30),
              topRight: Radius.circular(30),
            ),
            child: SearchResultsTabs(tabController: _tabController, query: widget.query,),
          ),
        ),
      ),
    );
  }
}