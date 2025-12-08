import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../NewRecipes/add_recipe_screen.dart';
import '../NewRecipes/logic/add_recipe_provider.dart';
import 'logic/chat_provider.dart';

// Import các widget con
import 'widgets/chat_appbar.dart';
import 'widgets/chat_drawer.dart';
import 'widgets/chat_input_bar.dart';
import 'widgets/empty_chat_state.dart';
import 'widgets/message_bubble.dart';

class ChatScreen extends ConsumerStatefulWidget {
  const ChatScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends ConsumerState<ChatScreen> {
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  // ============================================================
  // THÊM ĐOẠN NÀY ĐỂ TỰ ĐỘNG TẠO CHAT MỚI KHI MỞ MÀN HÌNH
  // ============================================================
  @override
  void initState() {
    super.initState();
    // Dùng addPostFrameCallback để gọi provider sau khi widget đã dựng xong
    // Tránh lỗi "setState() or markNeedsBuild() called during build"
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(chatProvider.notifier).startNewChat();
    });
  }
  // ============================================================

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

  void _startNewChat() {
    ref.read(chatProvider.notifier).startNewChat();
    _controller.clear();
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
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const AddRecipeScreen()),
    );
  }

  void _handleSend() {
    final text = _controller.text.trim();
    if (text.isEmpty) return;
    ref.read(chatProvider.notifier).sendMessage(text);
    _controller.clear();
  }

  @override
  Widget build(BuildContext context) {
    final chatState = ref.watch(chatProvider);
    final messages = chatState.currentMessages;

    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final bgColor = isDark ? const Color(0xFF121212) : Colors.white;

    ref.listen(chatProvider, (previous, next) {
      if (next.currentMessages.length > (previous?.currentMessages.length ?? 0)) {
        Future.delayed(const Duration(milliseconds: 100), _scrollToBottom);
      }
    });

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: bgColor,

      drawer: const ChatDrawer(),

      appBar: ChatAppBar(
        isDark: isDark,
        onNewChat: _startNewChat,
      ),

      body: Column(
        children: [
          Expanded(
            child: messages.isEmpty
                ? EmptyChatState(isDark: isDark)
                : ListView.builder(
              controller: _scrollController,
              padding: EdgeInsets.all(16.w),
              itemCount: messages.length,
              itemBuilder: (context, index) {
                final msg = messages[index];
                return MessageBubble(
                  msg: msg,
                  isDark: isDark,
                  onCookNow: _onCookNow,
                  onRequestAnother: () => ref.read(chatProvider.notifier).requestAnotherRecipe(),
                );
              },
            ),
          ),

          ChatInputBar(
            controller: _controller,
            onSend: _handleSend,
            isDark: isDark,
          ),
        ],
      ),
    );
  }
}