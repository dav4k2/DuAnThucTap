// lib/providers/search_notifier.dart
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class Recipe {
  final String id;
  final String name;
  final String ingredient;
  const Recipe({required this.id, required this.name, required this.ingredient});
}

class AppUser {
  final String id;
  final String name;
  final String avatarUrl;
  const AppUser({required this.id, required this.name, this.avatarUrl = ''});
}

class SearchState {
  final String query;
  final List<dynamic> suggestions;
  final bool showSuggestions;
  const SearchState({this.query = '', this.suggestions = const [], this.showSuggestions = false});

  SearchState copyWith({String? query, List<dynamic>? suggestions, bool? showSuggestions}) {
    return SearchState(
      query: query ?? this.query,
      suggestions: suggestions ?? this.suggestions,
      showSuggestions: showSuggestions ?? this.showSuggestions,
    );
  }
}

class SearchNotifier extends StateNotifier<SearchState> {
  SearchNotifier() : super(const SearchState());
  final TextEditingController controller = TextEditingController();
  Timer? _debounce;

  static const List<Recipe> _allRecipes = [
    Recipe(id: '1', name: 'Bò xào hành tây', ingredient: 'thịt bò'),
    Recipe(id: '2', name: 'Bò lúc lắc', ingredient: 'thịt bò'),
    Recipe(id: '3', name: 'Phở bò', ingredient: 'thịt bò'),
    Recipe(id: '4', name: 'Bò kho', ingredient: 'thịt bò'),
    Recipe(id: '5', name: 'Gà chiên mắm', ingredient: 'gà'),
    Recipe(id: '6', name: 'Cá kho tộ', ingredient: 'cá'),
  ];

  static const List<AppUser> _allUsers = [
    AppUser(id: 'u1', name: 'Nguyễn Văn A', avatarUrl: ''),
    AppUser(id: 'u2', name: 'Trần Thị B', avatarUrl: ''),
    AppUser(id: 'u3', name: 'Lê Văn C', avatarUrl: ''),
  ];

  void updateQuery(String value) {
    controller.text = value;
    final trimmed = value.trim();

    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 300), () {
      if (trimmed.isEmpty) {
        state = state.copyWith(suggestions: const [], showSuggestions: false);
        return;
      }

      final lower = trimmed.toLowerCase();
      final recipeResults = _allRecipes
          .where((r) => r.name.toLowerCase().contains(lower) || r.ingredient.toLowerCase().contains(lower))
          .toList();
      final userResults = _allUsers.where((u) => u.name.toLowerCase().contains(lower)).toList();

      state = state.copyWith(
        query: trimmed,
        suggestions: [...recipeResults, ...userResults],
        showSuggestions: true,
      );
    });
  }

  // ĐÃ SỬA: GIỮ LẠI GỢI Ý KHI CLICK VÀO GỢI Ý
  void selectSuggestion(dynamic item) {
    final String selectedText = item is Recipe ? item.name : item.name;
    controller.text = selectedText;

    state = state.copyWith(
      query: selectedText,
      suggestions: _getCurrentSuggestions(selectedText),
      showSuggestions: true, // QUAN TRỌNG: GIỮ HIỆN GỢI Ý
    );

    // Không gọi performSearch() ở đây → tránh reset state
  }

  List<dynamic> _getCurrentSuggestions(String query) {
    final lower = query.toLowerCase();
    final recipeResults = _allRecipes
        .where((r) => r.name.toLowerCase().contains(lower) || r.ingredient.toLowerCase().contains(lower))
        .toList();
    final userResults = _allUsers.where((u) => u.name.toLowerCase().contains(lower)).toList();
    return [...recipeResults, ...userResults];
  }

  void clear() {
    controller.clear();
    _debounce?.cancel();
    state = const SearchState();
  }

  @override
  void dispose() {
    _debounce?.cancel();
    controller.dispose();
    super.dispose();
  }
}

final searchProvider = StateNotifierProvider<SearchNotifier, SearchState>((ref) {
  return SearchNotifier();
});