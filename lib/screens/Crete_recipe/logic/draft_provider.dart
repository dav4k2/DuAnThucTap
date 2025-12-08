import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'draft_recipe.dart';

// Riverpod provider
final recipeDraftProvider =
StateNotifierProvider<RecipeDraftNotifier, List<DraftRecipe>>((ref) {
  return RecipeDraftNotifier();
});

class RecipeDraftNotifier extends StateNotifier<List<DraftRecipe>> {
  RecipeDraftNotifier() : super([]) {
    _loadFromStorage();
  }

  static const String _key = 'recipe_drafts';

  // Load danh sách nháp từ SharedPreferences
  Future<void> _loadFromStorage() async {
    final prefs = await SharedPreferences.getInstance();
    final String? data = prefs.getString(_key);
    if (data != null) {
      final List jsonList = jsonDecode(data);
      state = jsonList
          .map((e) => DraftRecipe.fromJson(e))
          .toList()
        ..sort((a, b) => b.savedAt.compareTo(a.savedAt));
    }
  }

  // Lưu danh sách nháp vào SharedPreferences
  Future<void> _saveToStorage() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonList = state.map((e) => e.toJson()).toList();
    await prefs.setString(_key, jsonEncode(jsonList));
  }

  // Lưu hoặc cập nhật bản nháp
  Future<void> saveDraft(DraftRecipe draft) async {
    final existingIndex = state.indexWhere((d) => d.id == draft.id);
    List<DraftRecipe> newList;

    if (existingIndex >= 0) {
      // Cập nhật bản nháp đã tồn tại
      newList = state.map((d) => d.id == draft.id ? draft : d).toList();
    } else {
      // Thêm bản nháp mới
      newList = [draft, ...state];
    }

    state = newList..sort((a, b) => b.savedAt.compareTo(a.savedAt));
    await _saveToStorage();
  }

  // Xoá bản nháp theo id
  Future<void> deleteDraft(String id) async {
    state = state.where((d) => d.id != id).toList();
    await _saveToStorage();
  }
}
