import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;

// --- API KEY ---
final _apiKey = dotenv.env['GROQ_API_KEY'] ?? '';

// --- MODEL 1: TIN NHẮN ---
class ChatMessage {
  final String text;
  final bool isUser;
  final bool isLoading;
  final Map<String, dynamic>? recipeData;

  ChatMessage({
    required this.text,
    required this.isUser,
    this.isLoading = false,
    this.recipeData,
  });
}

// --- MODEL 2: PHIÊN CHAT (SESSION) ---
class ChatSession {
  final String id;
  final String title; // Tiêu đề (lấy từ tin nhắn đầu tiên)
  final List<ChatMessage> messages;
  final DateTime createdAt;

  ChatSession({
    required this.id,
    required this.title,
    required this.messages,
    required this.createdAt,
  });
}

// --- STATE CỦA PROVIDER ---
class ChatState {
  final List<ChatSession> history; // Danh sách lịch sử
  final String? currentSessionId;  // ID cuộc hội thoại đang mở (null = chưa tạo mới)
  final List<ChatMessage> currentMessages; // Tin nhắn đang hiển thị trên màn hình

  ChatState({
    this.history = const [],
    this.currentSessionId,
    this.currentMessages = const [],
  });

  ChatState copyWith({
    List<ChatSession>? history,
    String? currentSessionId,
    List<ChatMessage>? currentMessages,
  }) {
    return ChatState(
      history: history ?? this.history,
      currentSessionId: currentSessionId, // Lưu ý: Nếu truyền null thì nó vẫn giữ cái cũ nếu không xử lý kỹ, ở đây ta gán trực tiếp
      currentMessages: currentMessages ?? this.currentMessages,
    );
  }
}

class ChatNotifier extends StateNotifier<ChatState> {
  ChatNotifier() : super(ChatState());

  // === 1. TẠO CUỘC HỘI THOẠI MỚI ===
  void startNewChat() {
    // Giữ nguyên history, xoá ID hiện tại, xoá tin nhắn hiện tại
    state = ChatState(
      history: state.history,
      currentSessionId: null,
      currentMessages: [],
    );
  }

  // === 2. LOAD LẠI CUỘC HỘI THOẠI CŨ ===
  void loadSession(String sessionId) {
    final session = state.history.firstWhere((s) => s.id == sessionId);
    state = ChatState(
      history: state.history,
      currentSessionId: sessionId,
      currentMessages: session.messages,
    );
  }

  // === 3. GỬI TIN NHẮN ===
  Future<void> sendMessage(String inputRaw) async {
    if (inputRaw.trim().isEmpty) return;

    // A. Thêm tin nhắn User vào UI tạm thời
    final userMsg = ChatMessage(text: inputRaw, isUser: true);
    final loadingMsg = ChatMessage(text: '...', isUser: false, isLoading: true);

    List<ChatMessage> newMessages = [...state.currentMessages, userMsg, loadingMsg];

    // B. Nếu chưa có Session ID (Chat mới) -> Tạo Session mới
    String sessionId = state.currentSessionId ?? DateTime.now().millisecondsSinceEpoch.toString();
    String sessionTitle = state.currentSessionId == null ? inputRaw : (state.history.firstWhere((s) => s.id == sessionId).title);

    // Cập nhật State tạm (để hiện loading)
    _updateState(sessionId, sessionTitle, newMessages);

    // D. Gọi API
    await _callGroq(sessionId, sessionTitle, inputRaw, isRefresh: false);
  }

  // === 4. ĐỔI MÓN KHÁC ===
  Future<void> requestAnotherRecipe() async {
    final lastUserMsg = state.currentMessages.lastWhere((m) => m.isUser, orElse: () => ChatMessage(text: '', isUser: true));
    final contextInput = lastUserMsg.text.isNotEmpty ? lastUserMsg.text : "món ăn bất kỳ";

    // Thêm tin nhắn vào UI
    final userRequest = ChatMessage(text: "Tìm món khác giúp tôi...", isUser: true);
    final loadingMsg = ChatMessage(text: '...', isUser: false, isLoading: true);

    List<ChatMessage> newMessages = [...state.currentMessages, userRequest, loadingMsg];

    // Đảm bảo có session ID
    if (state.currentSessionId == null) return;
    String sessionId = state.currentSessionId!;
    String sessionTitle = state.history.firstWhere((s) => s.id == sessionId).title;

    _updateState(sessionId, sessionTitle, newMessages);

    await _callGroq(sessionId, sessionTitle, contextInput, isRefresh: true);
  }

  // === HELPER: CẬP NHẬT STATE VÀ HISTORY ===
  void _updateState(String sessionId, String title, List<ChatMessage> messages) {
    // 1. Tìm xem session đã có trong history chưa
    final index = state.history.indexWhere((s) => s.id == sessionId);
    List<ChatSession> newHistory = [...state.history];

    final updatedSession = ChatSession(
      id: sessionId,
      title: title,
      messages: messages,
      createdAt: DateTime.now(),
    );

    if (index == -1) {
      // Chưa có -> Thêm mới vào đầu danh sách
      newHistory.insert(0, updatedSession);
    } else {
      // Đã có -> Cập nhật nội dung và đưa lên đầu
      newHistory.removeAt(index);
      newHistory.insert(0, updatedSession);
    }

    state = ChatState(
      history: newHistory,
      currentSessionId: sessionId,
      currentMessages: messages,
    );
  }

  // === LOGIC GỌI GROQ API ===
  Future<void> _callGroq(String sessionId, String sessionTitle, String userInput, {required bool isRefresh}) async {
    try {
      final url = Uri.parse('https://api.groq.com/openai/v1/chat/completions');

      final systemPrompt = '''
      Bạn là Chef AI, đầu bếp 5 sao.
      Nhiệm vụ: Tạo công thức nấu ăn từ yêu cầu: "$userInput".
      ${isRefresh ? 'Yêu cầu: Đưa ra món KHÁC hoàn toàn so với thông thường.' : ''}
      
      QUY ĐỊNH:
      1. Tên món: Tiếng Việt.
      2. Mô tả: Dài 3-5 câu, hấp dẫn, tả kỹ hương vị.
      
      OUTPUT JSON (Không Markdown):
      {
        "title": "Tên món",
        "description": "Mô tả...",
        "servings": "Chọn 1: ['1 người', '2 người', '3-4 người', '5-6 người', '7+ người']",
        "cookingTime": "Chọn 1: ['Dưới 15 phút', '15-30 phút', '30-60 phút', 'Trên 1 tiếng']",
        "difficulty": "Chọn 1: ['Dễ', 'Trung bình', 'Khó']",
        "ingredients": ["Nguyên liệu 1", "Nguyên liệu 2"],
        "steps": ["Bước 1...", "Bước 2..."]
      }
      ''';

      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json; charset=utf-8',
          'Authorization': 'Bearer $_apiKey',
        },
        body: jsonEncode({
          "model": "llama-3.3-70b-versatile",
          "messages": [
            {"role": "system", "content": systemPrompt},
            {"role": "user", "content": "Nguyên liệu/Món: $userInput"},
          ],
          "temperature": 0.8,
          "response_format": {"type": "json_object"}
        }),
      );

      if (response.statusCode == 200) {
        final responseBody = jsonDecode(utf8.decode(response.bodyBytes));
        final content = responseBody['choices'][0]['message']['content'];
        final Map<String, dynamic> data = jsonDecode(content);

        // Xoá loading, thêm kết quả
        final currentMsgs = List<ChatMessage>.from(state.currentMessages)..removeLast();
        final title = data['title'];

        currentMsgs.add(ChatMessage(
          text: isRefresh
              ? "Tôi tìm được món khác là **$title**. Bạn xem thử nhé:"
              : "Với **$userInput**, tôi đề xuất món **$title** hấp dẫn này:",
          isUser: false,
          recipeData: data,
        ));

        // Cập nhật lại State và History
        _updateState(sessionId, sessionTitle, currentMsgs);

      } else {
        throw Exception('Lỗi API: ${response.statusCode}');
      }
    } catch (e) {
      final currentMsgs = List<ChatMessage>.from(state.currentMessages)..removeLast();
      currentMsgs.add(ChatMessage(text: "Lỗi: $e", isUser: false));
      _updateState(sessionId, sessionTitle, currentMsgs);
    }
  }
}

final chatProvider = StateNotifierProvider<ChatNotifier, ChatState>((ref) {
  return ChatNotifier();
});