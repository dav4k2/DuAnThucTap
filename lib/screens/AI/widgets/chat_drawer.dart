import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../logic/chat_provider.dart';

class ChatDrawer extends ConsumerStatefulWidget {
  const ChatDrawer({Key? key}) : super(key: key);

  @override
  ConsumerState<ChatDrawer> createState() => _ChatDrawerState();
}

class _ChatDrawerState extends ConsumerState<ChatDrawer> {
  String _searchQuery = '';
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // 1. Tự lấy dữ liệu từ Provider
    final chatState = ref.watch(chatProvider);
    final history = chatState.history;

    // 2. Logic lọc tìm kiếm
    final filteredHistory = history.where((session) {
      final title = session.title.toLowerCase();
      final query = _searchQuery.toLowerCase();
      return title.contains(query);
    }).toList();

    // Theme darkmode
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final drawerColor = isDark ? const Color(0xFF1E1E1E) : const Color(0xFFF9F9F9);
    final textColor = isDark ? Colors.white : Colors.black87;
    final searchBg = isDark ? const Color(0xFF2C2C2C) : const Color(0xFFE0E0E0);

    return Drawer(
      backgroundColor: drawerColor,
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Nút Tạo Chat Mới
            Padding(
              padding: EdgeInsets.all(16.w),
              child: SizedBox(
                width: double.infinity,
                height: 48.h,
                child: OutlinedButton.icon(
                  onPressed: () {
                    ref.read(chatProvider.notifier).startNewChat();
                    Navigator.pop(context);
                  },
                  icon: Icon(Icons.add, color: textColor),
                  label: Text("Cuộc hội thoại mới", style: TextStyle(color: textColor, fontSize: 14.sp)),
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(color: isDark ? Colors.grey[700]! : Colors.grey[300]!),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.r)),
                    alignment: Alignment.centerLeft,
                  ),
                ),
              ),
            ),

            // Ô Tìm kiếm
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 4.h),
              child: Container(
                decoration: BoxDecoration(
                  color: searchBg,
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: TextField(
                  controller: _searchController,
                  style: TextStyle(color: textColor, fontSize: 14.sp),
                  onChanged: (value) => setState(() => _searchQuery = value),
                  decoration: InputDecoration(
                    hintText: 'Tìm kiếm...',
                    hintStyle: TextStyle(color: Colors.grey, fontSize: 13.sp),
                    prefixIcon: const Icon(Icons.search, color: Colors.grey),
                    suffixIcon: _searchQuery.isNotEmpty
                        ? GestureDetector(
                      onTap: () {
                        _searchController.clear();
                        setState(() => _searchQuery = '');
                      },
                      child: const Icon(Icons.close, color: Colors.grey, size: 20),
                    )
                        : null,
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(vertical: 12.h),
                  ),
                ),
              ),
            ),

            Padding(
              padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 8.h),
              child: Text(
                _searchQuery.isEmpty ? "Gần đây" : "Kết quả tìm kiếm",
                style: TextStyle(color: Colors.grey, fontSize: 12.sp, fontWeight: FontWeight.bold),
              ),
            ),

            // Danh sách lịch sử
            Expanded(
              child: filteredHistory.isEmpty
                  ? Center(
                child: Text(
                  history.isEmpty ? "Chưa có lịch sử" : "Không tìm thấy",
                  style: TextStyle(color: Colors.grey, fontSize: 13.sp),
                ),
              )
                  : ListView.builder(
                itemCount: filteredHistory.length,
                itemBuilder: (context, index) {
                  final session = filteredHistory[index];
                  final isSelected = session.id == chatState.currentSessionId;

                  return Container(
                    color: isSelected ? (isDark ? Colors.grey[800] : Colors.grey[300]) : null,
                    child: ListTile(
                      dense: true,
                      title: Text(
                        session.title,
                        style: TextStyle(
                          color: isDark ? Colors.white70 : Colors.black87,
                          fontSize: 13.sp,
                          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      onTap: () {
                        ref.read(chatProvider.notifier).loadSession(session.id);
                        Navigator.pop(context);
                      },
                    ),
                  );
                },
              ),
            ),

            // tên người dùng
            Padding(
              padding: EdgeInsets.all(16.w),
              child: Row(
                children: [
                  CircleAvatar(radius: 16.r, backgroundColor: Colors.grey, child: Icon(Icons.person, size: 20.r, color: Colors.white)),
                  SizedBox(width: 10.w),
                  Text("Người dùng", style: TextStyle(color: textColor, fontWeight: FontWeight.bold)),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}