import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

// --- API KEY ---
final _apiKey = dotenv.env['GROQ_API_KEY'] ?? '';

// --- TIN NHẮN ---
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

  // Chuyển sang Map để lưu JSON
  Map<String, dynamic> toMap() {
    return {
      'text': text,
      'isUser': isUser,
      'recipeData': recipeData,
    };
  }

  // Khôi phục từ Map
  factory ChatMessage.fromMap(Map<String, dynamic> map) {
    return ChatMessage(
      text: map['text'] ?? '',
      isUser: map['isUser'] ?? true,
      recipeData: map['recipeData'],
    );
  }
}

// --- PHIÊN CHAT (SESSION) ---
class ChatSession {
  final String id;
  final String title;
  final List<ChatMessage> messages;
  final DateTime createdAt;

  ChatSession({
    required this.id,
    required this.title,
    required this.messages,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'messages': messages.map((m) => m.toMap()).toList(),
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory ChatSession.fromMap(Map<String, dynamic> map) {
    return ChatSession(
      id: map['id'],
      title: map['title'],
      messages: (map['messages'] as List)
          .map((m) => ChatMessage.fromMap(m))
          .toList(),
      createdAt: DateTime.parse(map['createdAt']),
    );
  }
}

// --- STATE CỦA PROVIDER ---
class ChatState {
  final List<ChatSession> history;
  final String? currentSessionId;
  final List<ChatMessage> currentMessages;

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
      currentSessionId: currentSessionId,
      currentMessages: currentMessages ?? this.currentMessages,
    );
  }
}

class ChatNotifier extends StateNotifier<ChatState> {
  ChatNotifier() : super(ChatState()) {
    _loadHistoryFromStorage(); // Load lại lịch sử ngay khi khởi tạo
  }

  static const String _storageKey = 'chef_ai_chat_history';

  // === 0. LOGIC LƯU TRỮ (LOCAL STORAGE) ===

  Future<void> _saveHistoryToStorage() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final String encodedData = jsonEncode(
        state.history.map((s) => s.toMap()).toList(),
      );
      await prefs.setString(_storageKey, encodedData);
    } catch (e) {
      print("Lỗi khi lưu lịch sử: $e");
    }
  }

  Future<void> _loadHistoryFromStorage() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final String? encodedData = prefs.getString(_storageKey);

      if (encodedData != null) {
        final List<dynamic> decodedData = jsonDecode(encodedData);
        final history = decodedData.map((s) => ChatSession.fromMap(s)).toList();
        state = state.copyWith(history: history);
      }
    } catch (e) {
      print("Lỗi khi tải lịch sử: $e");
    }
  }

  // === 1. TẠO CUỘC HỘI THOẠI MỚI ===
  void startNewChat() {
    state = state.copyWith(
      currentSessionId: null,
      currentMessages: [],
    );
  }

  // === 2. LOAD LẠI CUỘC HỘI THOẠI CŨ ===
  void loadSession(String sessionId) {
    final session = state.history.firstWhere((s) => s.id == sessionId);
    state = state.copyWith(
      currentSessionId: sessionId,
      currentMessages: session.messages,
    );
  }

  // === 3. GỬI TIN NHẮN ===
  Future<void> sendMessage(String inputRaw) async {
    if (inputRaw.trim().isEmpty) return;

    final userMsg = ChatMessage(text: inputRaw, isUser: true);
    List<ChatMessage> newMessages = [...state.currentMessages, userMsg];

    String sessionId = state.currentSessionId ?? DateTime.now().millisecondsSinceEpoch.toString();

    // Tạo title từ tin nhắn đầu tiên nếu là session mới
    String sessionTitle;
    if (state.currentSessionId == null) {
      sessionTitle = inputRaw.length > 20 ? "${inputRaw.substring(0, 20)}..." : inputRaw;
    } else {
      sessionTitle = state.history.firstWhere((s) => s.id == sessionId).title;
    }

    _updateState(sessionId, sessionTitle, newMessages);
    await _callGroq(sessionId, sessionTitle, inputRaw);
  }

  // === 4. ĐỔI MÓN KHÁC ===
  Future<void> requestAnotherRecipe() async {
    final lastUserMsg = state.currentMessages.lastWhere(
          (m) => m.isUser,
      orElse: () => ChatMessage(text: "Gợi ý món ăn", isUser: true),
    );

    String? lastDishName;
    try {
      final lastBotMsg = state.currentMessages.lastWhere((m) => !m.isUser && m.recipeData != null);
      lastDishName = lastBotMsg.recipeData?['title'];
    } catch (_) {}

    final userRequest = ChatMessage(text: "Tìm món khác giúp tôi", isUser: true);
    List<ChatMessage> newMessages = [...state.currentMessages, userRequest];

    if (state.currentSessionId == null) return;
    String sessionId = state.currentSessionId!;
    String sessionTitle = state.history.firstWhere((s) => s.id == sessionId).title;

    _updateState(sessionId, sessionTitle, newMessages);
    await _callGroq(sessionId, sessionTitle, lastUserMsg.text, excludeDishName: lastDishName);
  }

  // === CẬP NHẬT STATE VÀ LƯU VÀO MÁY ===
  void _updateState(String sessionId, String title, List<ChatMessage> messages) {
    final index = state.history.indexWhere((s) => s.id == sessionId);
    List<ChatSession> newHistory = [...state.history];

    final updatedSession = ChatSession(
      id: sessionId,
      title: title,
      messages: messages,
      createdAt: DateTime.now(),
    );

    if (index == -1) {
      newHistory.insert(0, updatedSession);
    } else {
      newHistory.removeAt(index);
      newHistory.insert(0, updatedSession);
    }

    state = state.copyWith(
      history: newHistory,
      currentSessionId: sessionId,
      currentMessages: messages,
    );

    // Lưu xuống bộ nhớ máy mỗi khi có cập nhật
    _saveHistoryToStorage();
  }

  // === LOGIC GỌI GROQ API ===
  Future<void> _callGroq(String sessionId, String sessionTitle, String userInput, {String? excludeDishName}) async {
    // Thêm tin nhắn Loading
    final loadingMsg = ChatMessage(text: "...", isUser: false, isLoading: true);
    _updateState(sessionId, sessionTitle, [...state.currentMessages, loadingMsg]);

    try {
      final url = Uri.parse('https://api.groq.com/openai/v1/chat/completions');

      final systemPrompt = '''
      Bạn là "Chef AI" - Đầu bếp chuyên nghiệp.
      Phân tích input: "$userInput" và tạo 1 công thức nấu ăn JSON.
      ${excludeDishName != null ? 'KHÔNG gợi ý món "$excludeDishName". Hãy gợi ý một món KHÁC.' : ''}
      
      OUTPUT JSON (NO MARKDOWN):
      {
        "title": "Tên món",
        "description": "Mô tả",
        "servings": "1-2 người",
        "cookingTime": "30 phút",
        "difficulty": "Dễ",
        "ingredients": ["Nguyên liệu - SL"],
        "steps": ["Bước 1..."]
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
            {"role": "user", "content": "Gợi ý món từ: $userInput"}
          ],
          "temperature": 0.7,
          "response_format": {"type": "json_object"}
        }),
      );

      List<ChatMessage> currentMsgs = List.from(state.currentMessages);
      currentMsgs.removeWhere((m) => m.isLoading); // Xóa loading

      if (response.statusCode == 200) {
        final data = jsonDecode(utf8.decode(response.bodyBytes));
        final content = jsonDecode(data['choices'][0]['message']['content']);

        final title = content['title'] ?? 'Món ăn';
        String intro = excludeDishName != null
            ? "Thay vì $excludeDishName, bạn thử món $title này nhé:"
            : "Đề xuất cho bạn món $title:";

        currentMsgs.add(ChatMessage(
          text: intro,
          isUser: false,
          recipeData: content,
        ));
      } else {
        currentMsgs.add(ChatMessage(text: "Lỗi kết nối bếp, vui lòng thử lại!", isUser: false));
      }
      _updateState(sessionId, sessionTitle, currentMsgs);

    } catch (e) {
      List<ChatMessage> currentMsgs = List.from(state.currentMessages);
      currentMsgs.removeWhere((m) => m.isLoading);
      currentMsgs.add(ChatMessage(text: "Có lỗi xảy ra: $e", isUser: false));
      _updateState(sessionId, sessionTitle, currentMsgs);
    }
  }

  // Thêm: Xóa lịch sử nếu cần
  Future<void> deleteSession(String sessionId) async {
    final newHistory = state.history.where((s) => s.id != sessionId).toList();
    state = state.copyWith(
      history: newHistory,
      currentSessionId: state.currentSessionId == sessionId ? null : state.currentSessionId,
      currentMessages: state.currentSessionId == sessionId ? [] : state.currentMessages,
    );
    _saveHistoryToStorage();
  }
}

final chatProvider = StateNotifierProvider<ChatNotifier, ChatState>((ref) {
  return ChatNotifier();
});