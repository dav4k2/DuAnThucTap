import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../Service/recipe_model.dart';
import '../../../Service/recipe_service.dart';
import '../../Crete_recipe/logic/draft_service.dart';
import '../../Crete_recipe/logic/draft_recipe.dart';
import '../../Crete_recipe/logic/publish_recipe.dart';
import '../../Crete_recipe/logic/publish_service.dart';
import '../widgets/exit_confirmation_dialog.dart';
import '../widgets/missing_info_dialog.dart';

class AddRecipeState {
  final String? id;
  final List<String> images;
  final String? video;
  final String title;
  final String description;
  final String? servings;
  final String? cookingTime;
  final String? difficulty;
  final List<String> ingredients;
  final List<String> steps;
  final List<String?> stepDurations;
  final List<List<String>> stepMedia;

  final String? nameError;
  final String? descriptionError;
  final String? servingsError;
  final String? cookingTimeError;
  final String? difficultyError;
  final List<String?> ingredientErrors;
  final List<String?> stepErrors;

  AddRecipeState({
    this.id,
    this.images = const [],
    this.video,
    this.title = '',
    this.description = '',
    this.servings,
    this.cookingTime,
    this.difficulty,
    this.ingredients = const [],
    this.steps = const [],
    List<String?>? stepDurations,
    List<List<String>>? stepMedia,
    this.nameError,
    this.descriptionError,
    this.servingsError,
    this.cookingTimeError,
    this.difficultyError,
    List<String?>? ingredientErrors,
    List<String?>? stepErrors,
  })  : stepDurations = stepDurations ?? [],
        stepMedia = stepMedia ?? [],
        ingredientErrors = ingredientErrors ?? [],
        stepErrors = stepErrors ?? [];

  AddRecipeState copyWith({
    String? id,
    List<String>? images,
    String? video,
    String? title,
    String? description,
    String? servings,
    String? cookingTime,
    String? difficulty,
    List<String>? ingredients,
    List<String>? steps,
    List<String?>? stepDurations,
    List<List<String>>? stepMedia,
    String? nameError,
    String? descriptionError,
    String? servingsError,
    String? cookingTimeError,
    String? difficultyError,
    List<String?>? ingredientErrors,
    List<String?>? stepErrors,
  }) {
    return AddRecipeState(
      id: id ?? this.id,
      images: images ?? this.images,
      video: video ?? this.video,
      title: title ?? this.title,
      description: description ?? this.description,
      servings: servings ?? this.servings,
      cookingTime: cookingTime ?? this.cookingTime,
      difficulty: difficulty ?? this.difficulty,
      ingredients: ingredients ?? this.ingredients,
      steps: steps ?? this.steps,
      stepDurations: stepDurations ?? this.stepDurations,
      stepMedia: stepMedia ?? this.stepMedia,
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
  final Ref ref;
  final _publishService = PublishService();

  static const List<String> validServings = [
    '1 người', '2 người', '3-4 người', '5-6 người', '7+ người'
  ];
  static const List<String> validTime = [
    'Dưới 15 phút', '15-30 phút', '30-60 phút', 'Trên 1 tiếng'
  ];
  static const List<String> validDifficulty = ['Dễ', 'Trung bình', 'Khó'];

  AddRecipeNotifier(this.ref)
      : super(AddRecipeState(
    servings: null,
    cookingTime: null,
    difficulty: null,
    stepDurations: [],
    stepMedia: [],
    ingredientErrors: [],
    stepErrors: [],
  ));

  void fillDataFromAI({
    required String title,
    required String description,
    required String servings,
    required String cookingTime,
    required String difficulty,
    required List<String> ingredients,
    required List<String> steps,
  }) {
    final safeServings = validServings.contains(servings) ? servings : null;
    final safeCookingTime = validTime.contains(cookingTime) ? cookingTime : null;
    final safeDifficulty = validDifficulty.contains(difficulty) ? difficulty : null;

    state = state.copyWith(
      title: title,
      description: description,
      servings: safeServings,
      cookingTime: safeCookingTime,
      difficulty: safeDifficulty,
      ingredients: ingredients,
      steps: steps,
      stepDurations: List<String?>.filled(steps.length, null),
      stepMedia: List<List<String>>.generate(steps.length, (_) => []),
      ingredientErrors: List<String?>.filled(ingredients.length, null),
      stepErrors: List<String?>.filled(steps.length, null),
    );
  }

  // SỬA LỖI ĐIỀU HƯỚNG TẠI ĐÂY
  Future<void> handleBackPressed(BuildContext context) async {
    final shouldExit = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (_) => const ExitConfirmationDialog(),
    );

    // Nếu shouldExit khác null (là true hoặc false) thì thực hiện thoát
    if (shouldExit != null) {
      if (context.mounted) Navigator.of(context).pop();
    }
  }

  Future<void> clearDraftAndReset() async {
    if (state.images.isNotEmpty) {
      final recipeService = RecipeService();
      final onlineImages = state.images.where((img) => img.startsWith('http')).toList();
      if (onlineImages.isNotEmpty) await recipeService.deleteImages(onlineImages);
    }
    if (state.id != null) {
      try {
        await ref.read(draftServiceProvider).deleteDraft(state.id!);
      } catch (e) {
        print("Lỗi xóa nháp: $e");
      }
    }
    state = AddRecipeState(
      servings: null,
      cookingTime: null,
      difficulty: null,
      stepDurations: [],
      stepMedia: [],
      ingredientErrors: [],
      stepErrors: [],
    );
  }

  Future<void> saveAsDraft(BuildContext context) async {
    final draft = DraftRecipe(
      id: state.id,
      title: state.title.trim().isEmpty ? 'Công thức chưa đặt tên' : state.title,
      description: state.description,
      images: state.images,
      video: state.video,
      servings: state.servings,
      cookingTime: state.cookingTime,
      difficulty: state.difficulty,
      ingredients: state.ingredients.where((e) => e.trim().isNotEmpty).toList(),
      steps: state.steps.where((e) => e.trim().isNotEmpty).toList(),
      stepDurations: state.stepDurations,
      stepMedia: state.stepMedia,
    );

    await ref.read(draftServiceProvider).saveDraft(draft);

    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Đã lưu bản nháp!'), backgroundColor: Colors.green)
      );
      state = AddRecipeState(
          servings: null,
          cookingTime: null,
          difficulty: null,
          stepDurations: [],
          stepMedia: [],
          ingredientErrors: [],
          stepErrors: []
      );
      // Không gọi Navigator.pop ở đây để handleBackPressed xử lý tập trung
    }
  }

  void loadFromDraft(DraftRecipe draft) {
    state = state.copyWith(
      id: draft.id,
      title: draft.title == 'Công thức chưa đặt tên' ? '' : draft.title,
      description: draft.description,
      images: draft.images,
      video: draft.video,
      servings: draft.servings,
      cookingTime: draft.cookingTime,
      difficulty: draft.difficulty,
      ingredients: draft.ingredients,
      steps: draft.steps,
      stepDurations: draft.stepDurations,
      stepMedia: draft.stepMedia,
      ingredientErrors: List.filled(draft.ingredients.length, null),
      stepErrors: List.filled(draft.steps.length, null),
    );
  }

  void updateTitle(String title) => state = state.copyWith(title: title, nameError: null);
  void updateDescription(String description) => state = state.copyWith(description: description, descriptionError: null);
  void updateServings(String? value) => state = state.copyWith(servings: value, servingsError: null);
  void updateCookingTime(String? value) => state = state.copyWith(cookingTime: value, cookingTimeError: null);
  void updateDifficulty(String? value) => state = state.copyWith(difficulty: value, difficultyError: null);

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
      stepDurations: [...state.stepDurations, null],
      stepMedia: [...state.stepMedia, []],
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

  void updateStepDuration(int index, String? value) {
    final newList = [...state.stepDurations];
    newList[index] = value;
    state = state.copyWith(stepDurations: newList);
  }

  void addStepMedia(int index, String path) {
    final newMedia = [...state.stepMedia];
    newMedia[index] = [...newMedia[index], path];
    state = state.copyWith(stepMedia: newMedia);
  }

  void removeStepMedia(int stepIndex, int mediaIndex) {
    final newMedia = [...state.stepMedia];
    final stepList = [...newMedia[stepIndex]];
    stepList.removeAt(mediaIndex);
    newMedia[stepIndex] = stepList;
    state = state.copyWith(stepMedia: newMedia);
  }

  void removeStep(int index) {
    final newSteps = [...state.steps]..removeAt(index);
    final newDurations = [...state.stepDurations]..removeAt(index);
    final newMedia = [...state.stepMedia]..removeAt(index);
    final newErrors = [...state.stepErrors]..removeAt(index);
    state = state.copyWith(steps: newSteps, stepDurations: newDurations, stepMedia: newMedia, stepErrors: newErrors);
  }

  Future<bool> validateAndPublish(BuildContext context) async {
    final Set<String> missingFields = {};
    if (state.title.trim().isEmpty) missingFields.add('Tên công thức');
    if (state.description.trim().isEmpty) missingFields.add('Mô tả');
    if (state.servings == null) missingFields.add('Khẩu phần');
    if (state.cookingTime == null) missingFields.add('Thời gian nấu');
    if (state.difficulty == null) missingFields.add('Độ khó');

    if (missingFields.isNotEmpty) {
      showDialog(context: context, builder: (_) => MissingInfoDialog(missingFields: missingFields));
      return false;
    }

    showDialog(context: context, barrierDismissible: false, builder: (_) => const Center(child: CircularProgressIndicator(color: Color(0xFFFFB901))));

    try {
      final publishData = PublishRecipe(
        title: state.title,
        description: state.description,
        images: state.images,
        servings: state.servings,
        cookingTime: state.cookingTime,
        difficulty: state.difficulty,
        ingredients: state.ingredients,
        steps: state.steps,
      );
      final success = await _publishService.publishToUserCollection(publishData);
      if (context.mounted) {
        Navigator.pop(context);
        if (success) {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Đăng bài thành công!'), backgroundColor: Colors.green));
          if (state.id != null) await ref.read(draftServiceProvider).deleteDraft(state.id!);
          state = AddRecipeState(servings: null, cookingTime: null, difficulty: null, stepDurations: [], stepMedia: [], ingredientErrors: [], stepErrors: []);
          Navigator.pop(context);
          return true;
        }
      }
      return false;
    } catch (e) {
      if (context.mounted) Navigator.pop(context);
      return false;
    }
  }
}

final addRecipeProvider = StateNotifierProvider<AddRecipeNotifier, AddRecipeState>((ref) => AddRecipeNotifier(ref));