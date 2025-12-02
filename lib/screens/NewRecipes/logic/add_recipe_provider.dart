// lib/features/add_recipe/logic/add_recipe_provider.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../AI/logic/draft_provider.dart';
import '../../AI/logic/draft_recipe.dart';
import '../widgets/exit_confirmation_dialog.dart';
import '../widgets/missing_info_dialog.dart';

class AddRecipeState {
  final List<String> images;
  final String? video;
  final String title;
  final String description;
  final String? servings;
  final String? cookingTime;
  final String? difficulty;
  final List<String> ingredients;
  final List<String> steps;
  final List<String?> stepImages;

  final String? nameError;
  final String? descriptionError;
  final String? servingsError;
  final String? cookingTimeError;
  final String? difficultyError;
  final List<String?> ingredientErrors;
  final List<String?> stepErrors;

  AddRecipeState({
    this.images = const [],
    this.video,
    this.title = '',
    this.description = '',
    this.servings,
    this.cookingTime,
    this.difficulty,
    this.ingredients = const [],
    this.steps = const [],
    List<String?>? stepImages,
    this.nameError,
    this.descriptionError,
    this.servingsError,
    this.cookingTimeError,
    this.difficultyError,
    List<String?>? ingredientErrors,
    List<String?>? stepErrors,
  })  : stepImages = stepImages ?? [],
        ingredientErrors = ingredientErrors ?? [],
        stepErrors = stepErrors ?? [];

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
    List<String?>? stepImages,
    String? nameError,
    String? descriptionError,
    String? servingsError,
    String? cookingTimeError,
    String? difficultyError,
    List<String?>? ingredientErrors,
    List<String?>? stepErrors,
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
      stepImages: stepImages ?? this.stepImages,
      nameError: nameError ?? this.nameError,
      descriptionError: descriptionError ?? this.descriptionError,
      servingsError: servingsError ?? this.servingsError,
      cookingTimeError: cookingTimeError ?? this.cookingTimeError,
      difficultyError: difficultyError ?? this.difficultyError,
      ingredientErrors: ingredientErrors ?? this.ingredientErrors,
      stepErrors: stepErrors ?? this.stepErrors,
    );
  }
}

class AddRecipeNotifier extends StateNotifier<AddRecipeState> {
  final Ref ref; // ← cần có ref để gọi provider khác

  AddRecipeNotifier(this.ref)
      : super(AddRecipeState(
    servings: null,
    cookingTime: null,
    difficulty: null,
    stepImages: [],
    ingredientErrors: [],
    stepErrors: [],
  ));

  // ==================== HÀM BACK ====================
  Future<void> handleBackPressed(BuildContext context) async {
    final shouldExit = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (_) => const ExitConfirmationDialog(),
    );

    if (shouldExit == true || shouldExit == false) {
      if (context.mounted) {
        Navigator.of(context).pop();
      }
    }
  }

  // ==================== XOÁ NHÁP & RESET FORM ====================
// ==================== XOÁ NHÁP & RESET FORM ====================
  Future<void> clearDraftAndReset() async {
    // Nếu đã lưu draft trước đó (dùng title làm key)
    final draftKey = state.title.isEmpty ? 'Công thức chưa đặt tên' : state.title;

    // Xoá draft qua provider, truyền key (String)
    await ref.read(recipeDraftProvider.notifier).deleteDraft(draftKey);

    // Reset form
    state = AddRecipeState(
      servings: null,
      cookingTime: null,
      difficulty: null,
      stepImages: [],
      ingredientErrors: [],
      stepErrors: [],
    );
  }




  // ==================== LƯU NHÁP ====================
  Future<void> saveAsDraft(BuildContext context) async {
    final draft = DraftRecipe(
      title: state.title.trim().isEmpty ? 'Công thức chưa đặt tên' : state.title,
      description: state.description,
      images: state.images,
      video: state.video,
      servings: state.servings,
      cookingTime: state.cookingTime,
      difficulty: state.difficulty,
      ingredients: state.ingredients.where((e) => e.trim().isNotEmpty).toList(),
      steps: state.steps.where((e) => e.trim().isNotEmpty).toList(),
    );

    // Lưu nháp vào provider nháp
    await ref.read(recipeDraftProvider.notifier).saveDraft(draft);

    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Đã lưu bản nháp!'),
          backgroundColor: Colors.green,
        ),
      );
      Navigator.of(context).pop();
    }
  }

  // ==================== LOAD TỪ NHÁP ====================
  void loadFromDraft(DraftRecipe draft) {
    state = state.copyWith(
      title: draft.title == 'Công thức chưa đặt tên' ? '' : draft.title,
      description: draft.description,
      images: draft.images,
      video: draft.video,
      servings: draft.servings,
      cookingTime: draft.cookingTime,
      difficulty: draft.difficulty,
      ingredients: draft.ingredients,
      steps: draft.steps,
      // reset lỗi
      nameError: null,
      descriptionError: null,
      servingsError: null,
      cookingTimeError: null,
      difficultyError: null,
      ingredientErrors: List.filled(draft.ingredients.length, null),
      stepErrors: List.filled(draft.steps.length, null),
    );
  }

  // ==================== CẬP NHẬT DỮ LIỆU ====================
  void updateTitle(String title) => state = state.copyWith(title: title, nameError: null);

  void updateDescription(String description) =>
      state = state.copyWith(description: description, descriptionError: null);

  void updateServings(String? value) => state = state.copyWith(servings: value, servingsError: null);

  void updateCookingTime(String? value) =>
      state = state.copyWith(cookingTime: value, cookingTimeError: null);

  void updateDifficulty(String? value) =>
      state = state.copyWith(difficulty: value, difficultyError: null);

  void addImage(String path) {
    if (state.images.length < 6) state = state.copyWith(images: [...state.images, path]);
  }

  void removeImage(int index) {
    final newList = [...state.images]..removeAt(index);
    state = state.copyWith(images: newList);
  }

  void updateVideo(String path) => state = state.copyWith(video: path);

  void clearVideo() => state = state.copyWith(video: null);

  void addIngredient() {
    state = state.copyWith(
      ingredients: [...state.ingredients, ''],
      ingredientErrors: [...state.ingredientErrors, null],
    );
  }

  void updateIngredient(int index, String value) {
    final newList = [...state.ingredients];
    final newErrors = [...state.ingredientErrors];
    newList[index] = value;
    newErrors[index] = null;
    state = state.copyWith(ingredients: newList, ingredientErrors: newErrors);
  }

  void addStep() {
    state = state.copyWith(
      steps: [...state.steps, ''],
      stepImages: [...state.stepImages, null],
      stepErrors: [...state.stepErrors, null],
    );
  }

  void updateStep(int index, String value) {
    final newList = [...state.steps];
    final newErrors = [...state.stepErrors];
    newList[index] = value;
    newErrors[index] = null;
    state = state.copyWith(steps: newList, stepErrors: newErrors);
  }

  void removeStep(int index) {
    final newSteps = List<String>.from(state.steps)..removeAt(index);
    final newImages = List<String?>.from(state.stepImages)..removeAt(index);
    final newErrors = List<String?>.from(state.stepErrors)..removeAt(index);
    state = state.copyWith(steps: newSteps, stepImages: newImages, stepErrors: newErrors);
  }

  void updateStepImage(int index, String path) {
    final newImages = [...state.stepImages];
    newImages[index] = path;
    state = state.copyWith(stepImages: newImages);
  }

  void clearStepImage(int index) {
    final newImages = [...state.stepImages];
    newImages[index] = null;
    state = state.copyWith(stepImages: newImages);
  }


  // ==================== VALIDATE & SUBMIT ====================
  Future<bool> validateAndSubmit(BuildContext context) async {
    final errors = <String>[];
    final ingredientErrors = <String?>[];
    final stepErrors = <String?>[];

    state = state.copyWith(
      nameError: null,
      descriptionError: null,
      servingsError: null,
      cookingTimeError: null,
      difficultyError: null,
      ingredientErrors: List.filled(state.ingredients.length, null),
      stepErrors: List.filled(state.steps.length, null),
    );

    if (state.title.trim().isEmpty) {
      state = state.copyWith(nameError: 'Vui lòng nhập tên công thức');
      errors.add('tên công thức');
    }
    if (state.description.trim().isEmpty) {
      state = state.copyWith(descriptionError: 'Vui lòng nhập mô tả');
      errors.add('mô tả');
    }
    if (state.images.isEmpty) errors.add('ảnh minh hoạ');
    if (state.video == null || state.video!.isEmpty) errors.add('video minh hoạ');

    if (state.servings == null) {
      state = state.copyWith(servingsError: 'Vui lòng chọn khẩu phần');
      errors.add('khẩu phần');
    }
    if (state.cookingTime == null) {
      state = state.copyWith(cookingTimeError: 'Vui lòng chọn thời gian nấu');
      errors.add('thời gian nấu');
    }
    if (state.difficulty == null) {
      state = state.copyWith(difficultyError: 'Vui lòng chọn độ khó');
      errors.add('độ khó');
    }

    // Nguyên liệu
    if (state.ingredients.isEmpty) {
      errors.add('nguyên liệu');
    } else {
      for (int i = 0; i < state.ingredients.length; i++) {
        if (state.ingredients[i].trim().isEmpty) {
          ingredientErrors.add('Vui lòng nhập nguyên liệu');
          errors.add('nguyên liệu');
        } else {
          ingredientErrors.add(null);
        }
      }
      state = state.copyWith(ingredientErrors: ingredientErrors);
    }

    // Bước làm
    if (state.steps.isEmpty) {
      errors.add('bước làm');
    } else {
      for (int i = 0; i < state.steps.length; i++) {
        if (state.steps[i].trim().isEmpty) {
          stepErrors.add('Vui lòng nhập mô tả bước này');
          errors.add('bước làm');
        } else {
          stepErrors.add(null);
        }
      }
      state = state.copyWith(stepErrors: stepErrors);
    }

    if (errors.isNotEmpty) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) => MissingInfoDialog(missingFields: errors.toSet()),
      );
      return false;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Đăng bài thành công!'), backgroundColor: Colors.green),
    );
    return true;
  }
}

final addRecipeProvider = StateNotifierProvider<AddRecipeNotifier, AddRecipeState>((ref) {
  return AddRecipeNotifier(ref);
});
