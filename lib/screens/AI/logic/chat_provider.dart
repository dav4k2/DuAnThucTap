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
      currentSessionId: currentSessionId,
      currentMessages: currentMessages ?? this.currentMessages,
    );
  }
}

class ChatNotifier extends StateNotifier<ChatState> {
  ChatNotifier() : super(ChatState());

  // === 1. TẠO CUỘC HỘI THOẠI MỚI ===
  void startNewChat() {
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

    // A. Thêm tin nhắn User vào UI
    final userMsg = ChatMessage(text: inputRaw, isUser: true);
    final loadingMsg = ChatMessage(text: 'Đang suy nghĩ công thức...', isUser: false, isLoading: true);

    List<ChatMessage> newMessages = [...state.currentMessages, userMsg, loadingMsg];

    // B. Quản lý Session
    String sessionId = state.currentSessionId ?? DateTime.now().millisecondsSinceEpoch.toString();
    String sessionTitle = state.currentSessionId == null ? inputRaw : (state.history.firstWhere((s) => s.id == sessionId).title);

    _updateState(sessionId, sessionTitle, newMessages);

    // C. Gọi API (Lần đầu -> excludeDishName = null)
    await _callGroq(sessionId, sessionTitle, inputRaw, excludeDishName: null);
  }

  // === 4. ĐỔI MÓN KHÁC (LOGIC ĐÃ SỬA: LẤY MÓN CŨ ĐỂ NÉ) ===
  Future<void> requestAnotherRecipe() async {
    // 1. Lấy input gốc của user (tin nhắn user gần nhất)
    final lastUserMsg = state.currentMessages.lastWhere(
            (m) => m.isUser,
        orElse: () => ChatMessage(text: "Món ăn ngon", isUser: true)
    );
    final originalInput = lastUserMsg.text;

    // 2. Lấy tên món vừa gợi ý (để bảo AI đừng lặp lại)
    String? lastDishName;
    try {
      final lastBotMsg = state.currentMessages.lastWhere((m) => !m.isUser && m.recipeData != null);
      lastDishName = lastBotMsg.recipeData?['title'];
    } catch (e) {
      lastDishName = null;
    }

    // 3. Update UI
    final userRequest = ChatMessage(text: "Tìm món khác giúp tôi...", isUser: true);
    final loadingMsg = ChatMessage(text: 'Đang tìm món khác...', isUser: false, isLoading: true);

    List<ChatMessage> newMessages = [...state.currentMessages, userRequest, loadingMsg];

    if (state.currentSessionId == null) return;
    String sessionId = state.currentSessionId!;
    String sessionTitle = state.history.firstWhere((s) => s.id == sessionId).title;

    _updateState(sessionId, sessionTitle, newMessages);

    // 4. Gọi API với tham số loại trừ
    await _callGroq(sessionId, sessionTitle, originalInput, excludeDishName: lastDishName);
  }

  // === HELPER: CẬP NHẬT STATE VÀ HISTORY ===
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

    state = ChatState(
      history: newHistory,
      currentSessionId: sessionId,
      currentMessages: messages,
    );
  }

  // === LOGIC GỌI GROQ API (ĐÃ TỐI ƯU PROMPT) ===
  Future<void> _callGroq(String sessionId, String sessionTitle, String userInput, {String? excludeDishName}) async {
    try {
      final url = Uri.parse('https://api.groq.com/openai/v1/chat/completions');

      // --- PROMPT "SENIOR" ---
      // Dùng kỹ thuật Chain-of-Thought (Chuỗi suy luận) để AI không bị ngu ngơ
      final systemPrompt = '''
      Bạn là "Chef AI" - Đầu bếp 5 sao chuyên nghiệp, am hiểu ẩm thực Việt Nam.
      
      NHIỆM VỤ:
      Phân tích input: "$userInput" và tạo ra 1 công thức nấu ăn JSON.

      QUY TẮC SUY LUẬN (BẮT BUỘC):
      1. NẾU input là TÊN MÓN (vd: "Phở bò"): Trả về công thức chuẩn của món đó.
      2. NẾU input là NGUYÊN LIỆU (vd: "Trứng, Cà chua"): Gợi ý món ăn ngon nhất kết hợp được các nguyên liệu này.
      3. NẾU input là GIA VỊ hoặc ĐỒ ĂN KÈM (vd: "Muối", "Nước mắm", "Cơm", "Chanh"): 
         - TUYỆT ĐỐI KHÔNG làm món chính từ gia vị (Không làm "Muối chiên", "Chanh luộc").
         - HÃY gợi ý món mặn chính sử dụng gia vị đó làm điểm nhấn (vd: Input "Muối" -> Output "Gà rang muối"; Input "Nước mắm" -> Output "Cánh gà chiên nước mắm").
      4. KHỐI LƯỢNG: Phải thực tế (vd: Muối tính bằng thìa/gram nhỏ, Thịt tính bằng gram/kg).
      ${excludeDishName != null ? '5. YÊU CẦU ĐẶC BIỆT: Người dùng KHÔNG thích món "$excludeDishName". Hãy gợi ý một món KHÁC HOÀN TOÀN (khác cách chế biến hoặc nguyên liệu chính).' : ''}

      OUTPUT FORMAT (JSON ONLY - NO MARKDOWN):
      {
        "title": "Tên món ăn (Tiếng Việt)",
        "description": "Mô tả ngắn gọn hương vị và điểm đặc sắc (2-3 câu).",
        "servings": "Số người ăn (vd: 2 người)",
        "cookingTime": "Thời gian (vd: 30 phút)",
        "difficulty": "Độ khó (Dễ/Trung bình/Khó)",
        "ingredients": [
          "Tên nguyên liệu 1 - Số lượng",
          "Tên nguyên liệu 2 - Số lượng"
        ],
        "steps": [
          "Bước 1: Sơ chế...",
          "Bước 2: Chế biến..."
        ]
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
          "temperature": 0.6, // Giảm temperature để AI bớt ảo, tập trung vào logic
          "response_format": {"type": "json_object"}
        }),
      );

      if (response.statusCode == 200) {
        final responseBody = jsonDecode(utf8.decode(response.bodyBytes));
        final content = responseBody['choices'][0]['message']['content'];

        // Parse JSON an toàn
        Map<String, dynamic> data;
        try {
          data = jsonDecode(content);
        } catch (e) {
          // Fallback nếu AI trả về lỗi format (hiếm khi xảy ra với JSON mode)
          throw Exception("AI trả về dữ liệu không đúng định dạng.");
        }

        // Xoá loading message
        final currentMsgs = List<ChatMessage>.from(state.currentMessages);
        if (currentMsgs.isNotEmpty && currentMsgs.last.isLoading) {
          currentMsgs.removeLast();
        }

        final title = data['title'] ?? 'Món ăn';

        // Tạo câu dẫn dắt tự nhiên hơn
        String botIntroText;
        if (excludeDishName != null) {
          botIntroText = "Nếu bạn không thích **$excludeDishName**, tôi nghĩ món **$title** này sẽ hợp ý bạn:";
        } else {
          botIntroText = "Với **$userInput**, Bếp trưởng đề xuất món **$title**:";
        }

        currentMsgs.add(ChatMessage(
          text: botIntroText,
          isUser: false,
          recipeData: data,
        ));

        _updateState(sessionId, sessionTitle, currentMsgs);

      } else {
        throw Exception('Lỗi API: ${response.statusCode}');
      }
    } catch (e) {
      final currentMsgs = List<ChatMessage>.from(state.currentMessages);
      // Xoá loading nếu có lỗi
      if (currentMsgs.isNotEmpty && currentMsgs.last.isLoading) {
        currentMsgs.removeLast();
      }
      currentMsgs.add(ChatMessage(text: "Xin lỗi, bếp đang gặp trục trặc ($e). Bạn thử lại nhé!", isUser: false));
      _updateState(sessionId, sessionTitle, currentMsgs);
    }
  }
}

final chatProvider = StateNotifierProvider<ChatNotifier, ChatState>((ref) {
  return ChatNotifier();
});