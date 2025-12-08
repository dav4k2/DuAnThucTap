/*import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';


import '../NewRecipes/add_recipe_screen.dart';
import '../NewRecipes/logic/add_recipe_provider.dart';
import 'logic/chat_provider.dart';

class ChatScreen extends ConsumerStatefulWidget {
  const ChatScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends ConsumerState<ChatScreen> {
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent + 100,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  // === TẠO CHAT MỚI ===
  void _startNewChat() {
    ref.read(chatProvider.notifier).startNewChat();
    _controller.clear();
    if (_scaffoldKey.currentState?.isDrawerOpen ?? false) {
      Navigator.pop(context); // Đóng drawer
    }
  }

  // === CHỌN LỊCH SỬ CŨ ===
  void _loadHistory(String sessionId) {
    ref.read(chatProvider.notifier).loadSession(sessionId);
    if (_scaffoldKey.currentState?.isDrawerOpen ?? false) {
      Navigator.pop(context);
    }
    // Delay xíu để UI cập nhật xong mới scroll
    Future.delayed(const Duration(milliseconds: 200), _scrollToBottom);
  }

  void _onCookNow(Map<String, dynamic> data) {
    ref.read(addRecipeProvider.notifier).fillDataFromAI(
      title: data['title'] ?? '',
      description: data['description'] ?? '',
      servings: data['servings'] ?? '',
      cookingTime: data['cookingTime'] ?? '',
      difficulty: data['difficulty'] ?? '',
      ingredients: List<String>.from(data['ingredients'] ?? []),
      steps: List<String>.from(data['steps'] ?? []),
    );
    Navigator.push(context, MaterialPageRoute(builder: (context) => const AddRecipeScreen()));
  }

  void _handleSend() {
    final text = _controller.text;
    if (text.isEmpty) return;
    ref.read(chatProvider.notifier).sendMessage(text);
    _controller.clear();
  }

  @override
  Widget build(BuildContext context) {
    // Lấy toàn bộ state (gồm history và tin nhắn hiện tại)
    final chatState = ref.watch(chatProvider);
    final messages = chatState.currentMessages;
    final history = chatState.history;

    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final bgColor = isDark ? const Color(0xFF121212) : Colors.white;
    final drawerColor = isDark ? const Color(0xFF1E1E1E) : const Color(0xFFF9F9F9);
    final textColor = isDark ? Colors.white : Colors.black87;
    final inputColor = isDark ? Colors.grey[800] : Colors.grey[100];

    // Auto scroll listener
    ref.listen(chatProvider, (previous, next) {
      // Chỉ scroll khi số lượng tin nhắn tăng lên (tránh scroll khi chỉ đổi history)
      if (next.currentMessages.length > (previous?.currentMessages.length ?? 0)) {
        Future.delayed(const Duration(milliseconds: 100), _scrollToBottom);
      }
    });

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: bgColor,
      // === DRAWER LỊCH SỬ ĐỘNG ===
      drawer: Drawer(
        backgroundColor: drawerColor,
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.all(16.w),
                child: SizedBox(
                  width: double.infinity,
                  height: 48.h,
                  child: OutlinedButton.icon(
                    onPressed: _startNewChat,
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

              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                child: Text("Gần đây", style: TextStyle(color: Colors.grey, fontSize: 12.sp, fontWeight: FontWeight.bold)),
              ),

              // LIST VIEW LỊCH SỬ THẬT
              Expanded(
                child: history.isEmpty
                    ? Center(child: Text("Chưa có lịch sử", style: TextStyle(color: Colors.grey, fontSize: 12.sp)))
                    : ListView.builder(
                  itemCount: history.length,
                  itemBuilder: (context, index) {
                    final session = history[index];
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
                              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        onTap: () => _loadHistory(session.id),
                      ),
                    );
                  },
                ),
              ),

              // User Info
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
      ),
      appBar: AppBar(
        title: Text('Chef AI', style: TextStyle(color: textColor, fontSize: 18.sp, fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: bgColor,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.menu, color: textColor),
          onPressed: () => _scaffoldKey.currentState?.openDrawer(),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.edit_square, color: textColor),
            onPressed: _startNewChat,
            tooltip: 'Đoạn chat mới',
          ),
          SizedBox(width: 8.w),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: messages.isEmpty
                ? _buildEmptyState(isDark)
                : ListView.builder(
              controller: _scrollController,
              padding: EdgeInsets.all(16.w),
              itemCount: messages.length,
              itemBuilder: (context, index) {
                final msg = messages[index];
                return _buildMessageBubble(msg, isDark);
              },
            ),
          ),
          Container(
            padding: EdgeInsets.all(16.w),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: inputColor,
                      borderRadius: BorderRadius.circular(24.r),
                    ),
                    child: TextField(
                      controller: _controller,
                      style: TextStyle(color: textColor),
                      maxLines: null,
                      textInputAction: TextInputAction.send,
                      decoration: InputDecoration(
                        hintText: 'Nhập nguyên liệu hoặc món ăn...',
                        hintStyle: const TextStyle(color: Colors.grey),
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 14.h),
                      ),
                      onSubmitted: (_) => _handleSend(),
                    ),
                  ),
                ),
                SizedBox(width: 10.w),
                GestureDetector(
                  onTap: _handleSend,
                  child: CircleAvatar(
                    radius: 22.r,
                    backgroundColor: const Color(0xFFFFB901),
                    child: const Icon(Icons.arrow_upward, color: Colors.black),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // --- CÁC WIDGET PHỤ (Giữ nguyên hoặc copy lại từ code cũ nếu thiếu) ---
  Widget _buildEmptyState(bool isDark) {
    final textColor = isDark ? Colors.white : Colors.black87;
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.restaurant, size: 48.r, color: Colors.grey),
          SizedBox(height: 16.h),
          Text(
            "Tôi có thể giúp gì cho bạn hôm nay?",
            style: TextStyle(fontSize: 16.sp, color: textColor, fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }

  Widget _buildMessageBubble(ChatMessage msg, bool isDark) {
    final isUser = msg.isUser;
    final hasRecipe = !isUser && msg.recipeData != null;

    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Column(
        crossAxisAlignment: isUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Container(
            margin: EdgeInsets.symmetric(vertical: 6.h),
            constraints: BoxConstraints(maxWidth: 0.85.sw),
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
            decoration: BoxDecoration(
              color: isUser ? const Color(0xFFFFB901) : Colors.transparent,
              borderRadius: BorderRadius.circular(16.r),
            ),
            child: msg.isLoading
                ? SizedBox(width: 20.w, height: 20.w, child: CircularProgressIndicator(strokeWidth: 2, color: isDark ? Colors.white : Colors.black54))
                : Text(msg.text, style: TextStyle(color: isUser ? Colors.black : (isDark ? Colors.white : Colors.black87), fontSize: 15.sp, height: 1.5)),
          ),
          if (hasRecipe) _buildRecipePreviewCard(msg.recipeData!, isDark),
        ],
      ),
    );
  }

  Widget _buildRecipePreviewCard(Map<String, dynamic> data, bool isDark) {
    final cardBg = isDark ? const Color(0xFF1E1E1E) : Colors.white;
    final borderColor = isDark ? Colors.grey[700]! : Colors.grey[300]!;
    final textColor = isDark ? Colors.white : Colors.black87;
    final subColor = isDark ? Colors.grey[400] : Colors.grey[600];

    return Container(
      width: 0.9.sw,
      margin: EdgeInsets.only(top: 4.h, bottom: 16.h),
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: cardBg,
        border: Border.all(color: borderColor),
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 4))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(data['title'] ?? 'Món ăn', style: TextStyle(fontSize: 19.sp, fontWeight: FontWeight.bold, color: textColor)),
          SizedBox(height: 12.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildIconText(Icons.timer_outlined, data['cookingTime'], subColor),
              _buildIconText(Icons.people_outline, data['servings'], subColor),
              _buildIconText(Icons.bar_chart_rounded, data['difficulty'], subColor),
            ],
          ),
          Divider(height: 24.h, color: borderColor),
          Text("Mô tả món ăn:", style: TextStyle(fontWeight: FontWeight.w600, color: textColor, fontSize: 14.sp)),
          SizedBox(height: 6.h),
          Text(data['description'] ?? '', style: TextStyle(fontSize: 15.sp, color: subColor, height: 1.5)),
          SizedBox(height: 20.h),
          Row(
            children: [
              Expanded(child: SizedBox(height: 44.h, child: OutlinedButton(onPressed: () => ref.read(chatProvider.notifier).requestAnotherRecipe(), style: OutlinedButton.styleFrom(side: BorderSide(color: isDark ? Colors.white54 : Colors.grey), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))), child: Text("Đổi món khác", style: TextStyle(color: textColor, fontWeight: FontWeight.w500))))),
              SizedBox(width: 12.w),
              Expanded(child: SizedBox(height: 44.h, child: ElevatedButton(onPressed: () => _onCookNow(data), style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFFFB901), foregroundColor: Colors.black, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))), child: const Text("Nấu ngay", style: TextStyle(fontWeight: FontWeight.bold))))),
            ],
          )
        ],
      ),
    );
  }

  Widget _buildIconText(IconData icon, String? text, Color? color) {
    if (text == null) return const SizedBox.shrink();
    return Row(children: [Icon(icon, size: 16.sp, color: color), SizedBox(width: 4.w), Text(text, style: TextStyle(fontSize: 13.sp, color: color))]);
  }
}


 */