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

  final List<String> searchHistory = [
    "Thịt bò", "Bò lúc lắc", "Phở bò", "Gà chiên mắm", "Cá kho tộ", "Bò xào hành tây"
  ];

  final List<Map<String, String>> recentViews = [
    {
      "title": "Bò lúc lắc", "author": "Sơn Tùng", "rating": "4.9",
      "time": "25 Phút", "difficulty": "Trung bình",
      "image": "https://via.placeholder.com/100x89"
    },
    {
      "title": "Phở bò tái nạm", "author": "Minh Thư", "rating": "4.8",
      "time": "2 Giờ", "difficulty": "Khó",
      "image": "https://via.placeholder.com/100x89"
    },
    {
      "title": "Gà chiên mắm", "author": "Lan Hương", "rating": "5.0",
      "time": "40 Phút", "difficulty": "Dễ",
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
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final searchState = ref.watch(searchProvider);
    final searchNotifier = ref.read(searchProvider.notifier);

    return Scaffold(
      backgroundColor: const Color(0xFFFFB901),

      // THANH TÌM KIẾM
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
              // Nút back
              Positioned(
                left: 0.w,
                child: IconButton(
                  icon: Icon(Icons.arrow_back, color: isDark ? Colors.black : Colors.black),
                  onPressed: () => Navigator.pop(context),
                ),
              ),

              // Thanh tìm kiếm
              Center(
                child: Container(
                  height: 50.h,
                  width: 0.82.sw,
                  margin: EdgeInsets.symmetric(horizontal: 20.w),
                  decoration: BoxDecoration(
                    color: isDark ? Colors.black.withOpacity(0.2) : Colors.white,
                    borderRadius: BorderRadius.circular(50),
                    border: Border.all(
                      color: isDark ? Colors.white54 : Colors.black26,
                      width: 1.2,
                    ),
                  ),
                  child: Row(
                    children: [
                      SizedBox(width: 20.w),
                      Icon(Icons.search, color: isDark ? Colors.white70 : Colors.black54, size: 24),
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
                                MaterialPageRoute(builder: (_) => SearchResultsScreen(query: query)),
                              );
                            }
                          },
                          style: TextStyle(color: isDark ? Colors.white : Colors.black, fontSize: 14.5.sp),
                          decoration: InputDecoration(
                            hintText: 'Nhập tên món ăn hoặc nguyên liệu...',
                            hintStyle: TextStyle(color: isDark ? Colors.white70 : Colors.black54, fontSize: 14.5.sp),
                            border: InputBorder.none,
                            isCollapsed: true,
                            contentPadding: EdgeInsets.symmetric(vertical: 14.h),
                          ),
                        ),
                      ),
                      if (searchState.query.isNotEmpty)
                        GestureDetector(
                          onTap: searchNotifier.clear,
                          child: Padding(
                            padding: EdgeInsets.all(8.w),
                            child: Icon(Icons.cancel, color: isDark ? Colors.white70 : Colors.grey[600], size: 22.r),
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

      // BODY
      body: ClipRRect(
        borderRadius: const BorderRadius.only(topLeft: Radius.circular(30), topRight: Radius.circular(30)),
        child: Container(
          color: isDark ? const Color(0xFF121212) : Colors.white,
          child: SafeArea(
            top: false,
            bottom: true,
            child: searchState.query.isEmpty && searchState.suggestions.isEmpty
                ? _buildHistoryAndRecentView(isDark)
                : _buildSuggestionsView(searchState, searchNotifier, isDark),
          ),
        ),
      ),
    );
  }

  Widget _buildHistoryAndRecentView(bool isDark) {
    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            padding: EdgeInsets.fromLTRB(16.w, 24.h, 16.w, 24.h),
            child: Column(
              children: [
                SearchHistorySection(
                  history: searchHistory,
                  onHistoryTap: (query) {
                    _controller.text = query;
                    ref.read(searchProvider.notifier).updateQuery(query);
                  },
                  onRemove: (query) => setState(() => searchHistory.remove(query)),
                ),
                SizedBox(height: 40.h),
                RecentRecipesSection(
                  recentViews: recentViews,
                  onItemTap: (title) {
                    _controller.text = title;
                    ref.read(searchProvider.notifier).updateQuery(title);
                  },
                ),
                SizedBox(height: MediaQuery.of(context).padding.bottom + 20.h),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSuggestionsView(SearchState state, SearchNotifier notifier, bool isDark) {
    return ListView.separated(
      padding: EdgeInsets.fromLTRB(16.w, 24.h, 16.w, 24.h + MediaQuery.of(context).padding.bottom),
      itemCount: state.suggestions.length,
      separatorBuilder: (_, __) => Divider(height: 1.h, thickness: 0.5, color: isDark ? Colors.white24 : Colors.black12),
      itemBuilder: (context, i) {
        final item = state.suggestions[i];
        final isRecipe = item is Recipe;
        return ListTile(
          leading: CircleAvatar(
            radius: 22.r,
            backgroundColor: (isRecipe ? Colors.orange : Colors.blue).withOpacity(isDark ? 0.22 : 0.15),
            child: Icon(isRecipe ? Icons.restaurant_menu : Icons.person, color: isRecipe ? Colors.orange : Colors.blue, size: 22.r),
          ),
          title: Text(isRecipe ? item.name : item.name,
              style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w600, color: isDark ? Colors.white : Colors.black)),
          subtitle: Text(isRecipe ? 'Nguyên liệu: ${item.ingredient}' : 'Đầu bếp',
              style: TextStyle(fontSize: 13.sp, color: isDark ? Colors.white70 : Colors.grey[600])),
          trailing: Icon(Icons.arrow_forward_ios, size: 16.r, color: isDark ? Colors.white38 : Colors.grey),
          onTap: () {
            final query = isRecipe ? item.name : item.name;
            final tabIndex = isRecipe ? 0 : 1;
            notifier.selectSuggestion(item);
            _controller.text = query;
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => SearchResultsScreen(query: query, initialTabIndex: tabIndex)),
            );
          },
        );
      },
    );
  }
}