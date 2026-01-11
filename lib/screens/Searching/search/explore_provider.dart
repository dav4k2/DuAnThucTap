// lib/providers/explore_provider.dart (hoặc search_notifier.dart)
import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// --- MODEL APP USER ---
class AppUser {
  final String id;
  final String name;
  final String avatarUrl;

  const AppUser({required this.id, required this.name, this.avatarUrl = ''});

  factory AppUser.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return AppUser(
      id: doc.id,
      // Đảm bảo tên trường khớp với code Đăng ký (Register) của bạn
      name: data['name'] ?? data['fullname'] ?? 'Người dùng',
      avatarUrl: data['avatarUrl'] ?? data['image'] ?? '',
    );
  }
}

// --- MODEL RECIPE ---
class Recipe {
  final String id;
  final String name;
  final String ingredient;
  const Recipe({required this.id, required this.name, required this.ingredient});
}

// --- SEARCH STATE ---
class SearchState {
  final String query;
  final List<dynamic> suggestions;
  final bool showSuggestions;

  const SearchState({
    this.query = '',
    this.suggestions = const [],
    this.showSuggestions = false
  });

  SearchState copyWith({String? query, List<dynamic>? suggestions, bool? showSuggestions}) {
    return SearchState(
      query: query ?? this.query,
      suggestions: suggestions ?? this.suggestions,
      showSuggestions: showSuggestions ?? this.showSuggestions,
    );
  }
}

// --- SEARCH NOTIFIER ---
class SearchNotifier extends StateNotifier<SearchState> {
  // Biến quản lý việc lắng nghe dữ liệu
  StreamSubscription? _userSubscription;

  // Danh sách user cục bộ luôn được cập nhật mới nhất
  List<AppUser> _firebaseUsers = [];

  // Danh sách món ăn cứng (hoặc bạn có thể làm Stream tương tự cho món ăn)
  static const List<Recipe> _allRecipes = [
    Recipe(id: '1', name: 'Bò xào hành tây', ingredient: 'thịt bò'),
    Recipe(id: '2', name: 'Bò lúc lắc', ingredient: 'thịt bò'),
    Recipe(id: '3', name: 'Phở bò', ingredient: 'thịt bò'),
    Recipe(id: '4', name: 'Bò kho', ingredient: 'thịt bò'),
    Recipe(id: '5', name: 'Gà chiên mắm', ingredient: 'gà'),
    Recipe(id: '6', name: 'Cá kho tộ', ingredient: 'cá'),
  ];

  final TextEditingController controller = TextEditingController();
  Timer? _debounce;

  SearchNotifier() : super(const SearchState()) {
    _subscribeToUsers(); // Bắt đầu lắng nghe ngay khi khởi tạo
  }

  // --- [QUAN TRỌNG] HÀM LẮNG NGHE REAL-TIME ---
  void _subscribeToUsers() {
    // Hủy đăng ký cũ nếu có để tránh memory leak
    _userSubscription?.cancel();

    // Lắng nghe collection 'users'. Bất cứ khi nào có thay đổi (thêm/sửa/xóa), hàm này sẽ chạy lại.
    _userSubscription = FirebaseFirestore.instance
        .collection('users')
        .snapshots() // Dùng snapshots thay vì get
        .listen((snapshot) {

      _firebaseUsers = snapshot.docs.map((doc) {
        return AppUser.fromFirestore(doc);
      }).toList();

      debugPrint("♻️ Đã cập nhật danh sách user: ${_firebaseUsers.length} người.");

      // Nếu đang có từ khóa tìm kiếm, hãy cập nhật lại kết quả hiển thị ngay lập tức
      if (state.query.isNotEmpty) {
        // Gọi updateQuery nhưng không cần debounce (cập nhật giao diện ngay)
        _performSearch(state.query);
      }
    }, onError: (e) {
      debugPrint("❌ Lỗi lắng nghe user: $e");
    });
  }

  // Hàm tìm kiếm nội bộ (tách ra để tái sử dụng)
  void _performSearch(String query) {
    final lower = query.toLowerCase();

    final recipeResults = _allRecipes
        .where((r) => r.name.toLowerCase().contains(lower) || r.ingredient.toLowerCase().contains(lower))
        .toList();

    final userResults = _firebaseUsers
        .where((u) => u.name.toLowerCase().contains(lower))
        .toList();

    state = state.copyWith(
      query: query,
      suggestions: [...recipeResults, ...userResults],
      showSuggestions: true,
    );
  }

  void updateQuery(String value) {
    controller.text = value;
    final trimmed = value.trim();

    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 300), () {
      if (trimmed.isEmpty) {
        state = state.copyWith(suggestions: const [], showSuggestions: false);
        return;
      }
      _performSearch(trimmed);
    });
  }

  void selectSuggestion(dynamic item) {
    final String selectedText = item is Recipe ? item.name : item.name;
    controller.text = selectedText;

    // Khi chọn, ta lọc lại chính xác theo từ đã chọn
    final lower = selectedText.toLowerCase();
    final recipeResults = _allRecipes
        .where((r) => r.name.toLowerCase().contains(lower) || r.ingredient.toLowerCase().contains(lower))
        .toList();
    final userResults = _firebaseUsers
        .where((u) => u.name.toLowerCase().contains(lower))
        .toList();

    state = state.copyWith(
      query: selectedText,
      suggestions: [...recipeResults, ...userResults],
      showSuggestions: true,
    );
  }

  void clear() {
    controller.clear();
    _debounce?.cancel();
    state = const SearchState();
  }

  @override
  void dispose() {
    _userSubscription?.cancel(); // Rất quan trọng: Hủy lắng nghe khi thoát
    _debounce?.cancel();
    controller.dispose();
    super.dispose();
  }
}

final searchProvider = StateNotifierProvider<SearchNotifier, SearchState>((ref) {
  return SearchNotifier();
});