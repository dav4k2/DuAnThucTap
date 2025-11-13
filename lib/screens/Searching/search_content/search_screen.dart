// lib/screens/search/search_content/search_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fontend/screens/Searching/search_content/recent_recipes_section.dart';
import 'package:fontend/screens/Searching/search_content/search_history_widget.dart';

import '../Search_result/search_results_screen.dart';
import '../search/explore_provider.dart';

class SearchScreen extends ConsumerStatefulWidget {
  final String? initialQuery;
  const SearchScreen({super.key, this.initialQuery});

  @override
  ConsumerState<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends ConsumerState<SearchScreen> {
  late final TextEditingController _controller;
  final FocusNode _focusNode = FocusNode();

  // DỮ LIỆU GIẢ (sau này thay bằng Hive/SharedPreferences)
  final List<String> searchHistory = [
    "Thịt bò",
    "Bò lúc lắc",
    "Phở bò",
    "Gà chiên mắm",
    "Cá kho tộ",
    "Bò xào hành tây"
  ];

  final List<Map<String, String>> recentViews = [
    {
      "title": "Bò lúc lắc",
      "author": "Sơn Tùng",
      "rating": "4.9",
      "time": "25 Phút",
      "difficulty": "Trung bình",
      "image": "https://via.placeholder.com/100x89"
    },
    {
      "title": "Phở bò tái nạm",
      "author": "Minh Thư",
      "rating": "4.8",
      "time": "2 Giờ",
      "difficulty": "Khó",
      "image": "https://via.placeholder.com/100x89"
    },
    {
      "title": "Gà chiên mắm",
      "author": "Lan Hương",
      "rating": "5.0",
      "time": "40 Phút",
      "difficulty": "Dễ",
      "image": "https://via.placeholder.com/100x89"
    },
  ];

  @override
  void initState() {
    super.initState();
    _controller = ref.read(searchProvider.notifier).controller;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (widget.initialQuery != null && widget.initialQuery!.isNotEmpty) {
        _controller.text = widget.initialQuery!;
        _controller.selection = TextSelection.fromPosition(
            TextPosition(offset: _controller.text.length));
        ref.read(searchProvider.notifier).updateQuery(widget.initialQuery!);
        _focusNode.requestFocus();
      }
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final searchState = ref.watch(searchProvider);
    final searchNotifier = ref.read(searchProvider.notifier);

    return Scaffold(
      backgroundColor: const Color(0xFFFFB901),
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(70.h),
        child: AppBar(
          backgroundColor: const Color(0xFFFFB901),
          elevation: 0,
          automaticallyImplyLeading: false,
          titleSpacing: 0,
          title: Stack(
            alignment: Alignment.center,
            children: [
              Positioned(
                left: 0.w,
                child: IconButton(
                  icon: const Icon(Icons.arrow_back, color: Colors.black),
                  onPressed: () => Navigator.pop(context),
                ),
              ),
              Center(
                child: Container(
                  height: 50.h,
                  width: 0.82.sw,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(30.r),
                    border: Border.all(color: Colors.black.withOpacity(0.3), width: 1.2),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      )
                    ],
                  ),
                  child: Row(
                    children: [
                      SizedBox(width: 16.w),
                      const Icon(Icons.search, color: Colors.black54, size: 22),
                      SizedBox(width: 12.w),
                      Expanded(
                        child: TextField(
                          controller: _controller,
                          focusNode: _focusNode,
                          autofocus: widget.initialQuery == null,
                          onChanged: searchNotifier.updateQuery,
                          onSubmitted: (_) {
                            final query = _controller.text.trim();
                            if (query.isNotEmpty) {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (_) => SearchResultsScreen(query: query)),
                              );
                            }
                          },
                          decoration: InputDecoration(
                            hintText: 'Tìm món ăn, nguyên liệu...',
                            hintStyle: TextStyle(
                                color: Colors.black45,
                                fontSize: 16.sp,
                                fontWeight: FontWeight.w500),
                            border: InputBorder.none,
                            isCollapsed: true,
                            contentPadding: EdgeInsets.zero,
                          ),
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w500),
                        ),
                      ),
                      if (searchState.query.isNotEmpty)
                        GestureDetector(
                          onTap: searchNotifier.clear,
                          child: Container(
                            padding: EdgeInsets.all(8.w),
                            child: Icon(Icons.cancel,
                                color: Colors.grey[600], size: 22.r),
                          ),
                        ),
                      SizedBox(width: 8.w),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),

      // BODY CHÍNH – SẠCH SẼ, ĐÃ TÁCH RIÊNG
      body: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(30),
            topRight: Radius.circular(30),
          ),
        ),
        child: searchState.query.isEmpty && searchState.suggestions.isEmpty
            ? _buildHistoryAndRecentView()
            : _buildSuggestionsView(searchState, searchNotifier),
      ),
    );
  }

  // TRANG LỊCH SỬ + ĐÃ XEM
  Widget _buildHistoryAndRecentView() {
    return SingleChildScrollView(
      padding: EdgeInsets.fromLTRB(16.w, 24.h, 16.w, 100.h),
      child: Column(
        children: [
          // LỊCH SỬ TÌM KIẾM
          SearchHistorySection(
            history: searchHistory,
            onHistoryTap: (query) {
              _controller.text = query;
              ref.read(searchProvider.notifier).updateQuery(query);
            },
            onRemove: (query) => setState(() => searchHistory.remove(query)),
          ),

          SizedBox(height: 40.h),

          // ĐÃ XEM – DÙNG WIDGET RIÊNG
          RecentRecipesSection(
            recentViews: recentViews,
            onItemTap: (title) {
              _controller.text = title;
              ref.read(searchProvider.notifier).updateQuery(title);
            },
          ),
        ],
      ),
    );
  }

  // DANH SÁCH GỢI Ý
  Widget _buildSuggestionsView(SearchState state, SearchNotifier notifier) {
    return ListView.separated(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      itemCount: state.suggestions.length,
      separatorBuilder: (_, __) => Divider(height: 1.h, thickness: 0.5),
      itemBuilder: (context, i) {
        final item = state.suggestions[i];
        final isRecipe = item is Recipe;

        return ListTile(
          leading: CircleAvatar(
            radius: 22.r,
            backgroundColor:
            isRecipe ? Colors.orange.withOpacity(0.15) : Colors.blue.withOpacity(0.15),
            child: Icon(
              isRecipe ? Icons.restaurant_menu : Icons.person,
              color: isRecipe ? Colors.orange : Colors.blue,
              size: 22.r,
            ),
          ),
          title: Text(
            isRecipe ? item.name : item.name,
            style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w600),
          ),
          subtitle: Text(
            isRecipe ? 'Nguyên liệu: ${item.ingredient}' : 'Đầu bếp',
            style: TextStyle(fontSize: 13.sp, color: Colors.grey[600]),
          ),
          trailing: Icon(Icons.arrow_forward_ios, size: 16.r, color: Colors.grey),
          onTap: () {
            final query = isRecipe ? item.name : item.name;
            final tabIndex = isRecipe ? 0 : 1;

            notifier.selectSuggestion(item);
            _controller.text = query;

            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (_) => SearchResultsScreen(
                  query: query,
                  initialTabIndex: tabIndex,
                ),
              ),
            );
          },
        );
      },
    );
  }
}