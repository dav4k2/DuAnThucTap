// lib/features/add_recipe/logic/add_recipe_provider.dart

import 'package:flutter_riverpod/flutter_riverpod.dart';

class AddRecipeState {
  final List<String> images;
  final String? video;
  final String title;
  final String description;
  final String servings;
  final String cookingTime;
  final String difficulty;
  final List<String> ingredients;
  final List<String> steps;

  AddRecipeState({
    this.images = const [],
    this.video,
    this.title = '',
    this.description = '',
    this.servings = '2 người',
    this.cookingTime = '15-30 phút',
    this.difficulty = 'Dễ',
    this.ingredients = const [],
    this.steps = const [],
  });

  AddRecipeState copyWith({
    List<String>? images,
    String? video,
    String? title,
    String? description,
    String? servings,
    String? cookingTime,
    String? difficulty,
    List<String>? ingredients,
    List<String>? steps,
  }) {
    return AddRecipeState(
      images: images ?? this.images,
      video: video ?? this.video,
      title: title ?? this.title,
      description: description ?? this.description,
      servings: servings ?? this.servings,
      cookingTime: cookingTime ?? this.cookingTime,
      difficulty: difficulty ?? this.difficulty,
      ingredients: ingredients ?? this.ingredients,
      steps: steps ?? this.steps,
    );
  }
}

class AddRecipeNotifier extends StateNotifier<AddRecipeState> {
  AddRecipeNotifier() : super(AddRecipeState());

  // === CÁI MÀY CẦN – 3 HÀM MỚI ĐÃ ĐƯỢC THÊM ===
  void updateServings(String value) {
    state = state.copyWith(servings: value);
  }

  void updateCookingTime(String value) {
    state = state.copyWith(cookingTime: value);
  }

  void updateDifficulty(String value) {
    state = state.copyWith(difficulty: value);
  }
  // ==========================================

  void updateTitle(String title) {
    state = state.copyWith(title: title);
  }

  void updateDescription(String description) {
    state = state.copyWith(description: description);
  }

  void addImage(String path) {
    if (state.images.length < 5) {
      state = state.copyWith(images: [...state.images, path]);
    }
  }

  void removeImage(int index) {
    final newList = [...state.images]..removeAt(index);
    state = state.copyWith(images: newList);
  }

  void addIngredient() {
    state = state.copyWith(ingredients: [...state.ingredients, '']);
  }

  void updateIngredient(int index, String value) {
    final newList = [...state.ingredients];
    newList[index] = value;
    state = state.copyWith(ingredients: newList);
  }

  void addStep() {
    state = state.copyWith(steps: [...state.steps, '']);
  }

  void updateStep(int index, String value) {
    final newList = [...state.steps];
    newList[index] = value;
    state = state.copyWith(steps: newList);
  }
}

final addRecipeProvider = StateNotifierProvider<AddRecipeNotifier, AddRecipeState>((ref) {
  return AddRecipeNotifier();
});