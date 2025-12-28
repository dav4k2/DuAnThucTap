// lib/providers/survey_provider.dart
import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SurveyState {
  final String? cookingTitle;
  final List<String> favoriteCategories;
  final String? displayName;
  final String? bio;
  final String? email;
  final String? country;
  final File? avatarFile;
  final File? coverFile;
  final String? joinedDate;

  const SurveyState({
    this.cookingTitle,
    this.favoriteCategories = const [],
    this.displayName,
    this.bio,
    this.email,
    this.country,
    this.avatarFile,
    this.coverFile,
    this.joinedDate
  });

  SurveyState copyWith({
    String? cookingTitle,
    List<String>? favoriteCategories,
    String? displayName,
    String? bio,
    String? email,
    String? country,
    File? avatarFile,
    File? coverFile,
    String? joinedDate,

  }) {
    return SurveyState(
      cookingTitle: cookingTitle ?? this.cookingTitle,
      favoriteCategories: favoriteCategories ?? this.favoriteCategories,
      displayName: displayName ?? this.displayName,
      bio: bio ?? this.bio,
      email: email ?? this.email,
      country: country ?? this.country,
      avatarFile: avatarFile ?? this.avatarFile,
      coverFile: coverFile ?? this.coverFile,
      joinedDate: joinedDate ?? this.joinedDate,
    );
  }
}

// Danh sách chip bước 2
final List<String> _categoryList = [
  "Healthy", "Đồ cay", "Đồ ngọt",
  "Đồ ăn nhanh", "Ăn sáng", "Mỳ",
  "Bánh", "Súp", "Đồ chay",
  "Ăn trưa", "Ăn tối", "Đồ chua",
  "Ăn vặt", "Salad", "Món nước",
  "Món khô", "Món trộn", "Cháo",
  "Món Âu", "Món Á", "Cơm",
];

class SurveyNotifier extends StateNotifier<SurveyState> {
  SurveyNotifier() : super(const SurveyState());

  void setCookingTitle(String title) => state = state.copyWith(cookingTitle: title);

  void toggleCategory(String category) {
    final updated = state.favoriteCategories.contains(category)
        ? state.favoriteCategories.where((c) => c != category).toList()
        : [...state.favoriteCategories, category];
    state = state.copyWith(favoriteCategories: updated);
  }

  List<String> get categories => _categoryList;

  void setDisplayName(String name) {
    state = state.copyWith(displayName: name.isEmpty ? null : name);
  }

  void setBio(String bio) {
    state = state.copyWith(bio: bio.isEmpty ? null : bio);
  }

  void setCountry(String country) {
    state = state.copyWith(country: country);
  }

  // THÊM 2 HÀM LƯU ẢNH
  void setAvatarFile(File? file) => state = state.copyWith(avatarFile: file);
  void setCoverFile(File? file) => state = state.copyWith(coverFile: file);

  void clear() => state = const SurveyState();

  // THÊM HÀM NÀY ĐỂ EDIT PROFILE GỌI
  void updateUserData({
    String? displayName,
    String? bio,
    String? email,
    String? cookingTitle,
    String? country,
    String? joinedDated,
  }) {
    state = state.copyWith(
      displayName: displayName ?? state.displayName,
      bio: bio ?? state.bio,
      email: email ?? state.email,
      cookingTitle: cookingTitle ?? state.cookingTitle,
      country: country ?? state.country,
      joinedDate: joinedDated ?? state.joinedDate,
    );
  }
}

final surveyProvider = StateNotifierProvider<SurveyNotifier, SurveyState>((ref) {
  return SurveyNotifier();
});

final surveyCategoriesProvider = Provider<List<String>>((ref) {
  return ref.read(surveyProvider.notifier).categories;
});