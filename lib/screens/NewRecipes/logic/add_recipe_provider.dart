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

/// Sơn /// Model từng bước nấu ăn - Đã gộp để tránh lỗi "Nested arrays" trên Firebase
class RecipeStepModel {
  final String content;
  final String? duration;
  final List<String> media;

  RecipeStepModel({
    this.content = '',
    this.duration,
    this.media = const [],
  });

  Map<String, dynamic> toMap() => {
    'content': content,
    'duration': duration,
    'media': media,
  };

  RecipeStepModel copyWith({String? content, String? duration, List<String>? media}) {
    return RecipeStepModel(
      content: content ?? this.content,
      duration: duration ?? this.duration,
      media: media ?? this.media,
    );
  }
}

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
  final List<RecipeStepModel> steps;

  // === THÊM MỚI: DANH MỤC ĐÃ CHỌN ===
  final List<String> selectedCategories;

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
    this.selectedCategories = const [], // Mặc định chưa chọn tag nào
    this.nameError,
    this.descriptionError,
    this.servingsError,
    this.cookingTimeError,
    this.difficultyError,
    List<String?>? ingredientErrors,
    List<String?>? stepErrors,
  })  : ingredientErrors = ingredientErrors ?? [],
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
    List<RecipeStepModel>? steps,
    List<String>? selectedCategories,
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
      selectedCategories: selectedCategories ?? this.selectedCategories,
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

  // --- DANH SÁCH TAG MẪU (KHỚP VỚI HÌNH) ---
  final List<String> allCategories = [
    'Bữa trưa', 'Món khô', 'Món Á', 'Bữa sáng', 'Phở', 'Trà',
    'Bữa tối', 'Cơm', 'Healthy', 'Ăn vặt', 'Món trộn', 'Đồ ăn nhanh',
    'Món nước', 'Món Âu', 'Hải sản'
  ];

  static const List<String> validServings = ['1 người', '2 người', '3-4 người', '5-6 người', '7+ người'];
  static const List<String> validTime = ['Dưới 15 phút', '15-30 phút', '30-60 phút', 'Trên 1 tiếng'];
  static const List<String> validDifficulty = ['Dễ', 'Trung bình', 'Khó'];

  AddRecipeNotifier(this.ref) : super(AddRecipeState());

  // --- LOGIC DANH MỤC (TAGS) ---
  void toggleCategory(String category) {
    final current = state.selectedCategories;
    if (current.contains(category)) {
      state = state.copyWith(
        selectedCategories: current.where((t) => t != category).toList(),
      );
    } else {
      state = state.copyWith(
        selectedCategories: [...current, category],
      );
    }
  }

  // --- LOGIC AI ---
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
      steps: steps.map((s) => RecipeStepModel(content: s)).toList(),
      ingredientErrors: List<String?>.filled(ingredients.length, null),
      stepErrors: List<String?>.filled(steps.length, null),
    );
  }

  // --- HỆ THỐNG & LƯU TRỮ ---
  Future<void> handleBackPressed(BuildContext context) async {
    final shouldExit = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (_) => const ExitConfirmationDialog(),
    );
    if (shouldExit == true && context.mounted) {
      Navigator.of(context).pop();
    }
  }

  Future<void> clearDraftAndReset() async {
    if (state.id != null) {
      try {
        await ref.read(draftServiceProvider).deleteDraft(state.id!);
      } catch (e) {
        debugPrint("Lỗi xóa nháp: $e");
      }
    }
    state = AddRecipeState();
  }

  Future<bool> saveAsDraft(BuildContext context) async {
    final validSteps = state.steps.where((s) => s.content.trim().isNotEmpty).toList();

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
      steps: validSteps.map((s) => s.content).toList(),
      stepDurations: validSteps.map((s) => s.duration).toList(),
      stepMedia: validSteps.map((s) => s.media).toList(),
      tags: state.selectedCategories,
    );

    try {
      await ref.read(draftServiceProvider).saveDraft(draft);
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Đã lưu bản nháp!'), backgroundColor: Colors.green)
        );
        state = AddRecipeState();
        return true;
      }
      return false;
    } catch (e) {
      debugPrint("Lỗi Firestore: $e");
      return false;
    }
  }

  void loadFromDraft(DraftRecipe draft) {
    final List<RecipeStepModel> loadedSteps = [];
    for (int i = 0; i < draft.steps.length; i++) {
      loadedSteps.add(RecipeStepModel(
        content: draft.steps[i],
        duration: draft.stepDurations.length > i ? draft.stepDurations[i] : null,
        media: draft.stepMedia.length > i ? draft.stepMedia[i] : [],
      ));
    }

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
      steps: loadedSteps,
      selectedCategories: draft.tags, // Load lại tags vào UI
      ingredientErrors: List.filled(draft.ingredients.length, null),
      stepErrors: List.filled(draft.steps.length, null),
    );
  }

  // --- CẬP NHẬT TRƯỜNG DỮ LIỆU ---
  void updateTitle(String title) => state = state.copyWith(title: title, nameError: null);
  void updateDescription(String desc) => state = state.copyWith(description: desc, descriptionError: null);
  void updateServings(String? val) => state = state.copyWith(servings: val);
  void updateCookingTime(String? val) => state = state.copyWith(cookingTime: val);
  void updateDifficulty(String? val) => state = state.copyWith(difficulty: val);

  void updateVideo(String path) => state = state.copyWith(video: path);
  void clearVideo() => state = state.copyWith(video: null);

  void addImage(String path) {
    if (state.images.length < 6) state = state.copyWith(images: [...state.images, path]);
  }
  void removeImage(int index) {
    final newList = [...state.images]..removeAt(index);
    state = state.copyWith(images: newList);
  }

  // --- QUẢN LÝ BƯỚC NẤU ---
  void addStep() {
    state = state.copyWith(
      steps: [...state.steps, RecipeStepModel()],
      stepErrors: [...state.stepErrors, null],
    );
  }

  void updateStep(int index, String value) {
    final newList = [...state.steps];
    newList[index] = newList[index].copyWith(content: value);
    state = state.copyWith(steps: newList);
  }

  void updateStepDuration(int index, String? value) {
    final newList = [...state.steps];
    newList[index] = newList[index].copyWith(duration: value);
    state = state.copyWith(steps: newList);
  }

  void addStepMedia(int index, String path) {
    final newList = [...state.steps];
    final updatedMedia = [...newList[index].media, path];
    newList[index] = newList[index].copyWith(media: updatedMedia);
    state = state.copyWith(steps: newList);
  }

  void removeStepMedia(int stepIdx, int mediaIdx) {
    final newList = [...state.steps];
    final updatedMedia = [...newList[stepIdx].media]..removeAt(mediaIdx);
    newList[stepIdx] = newList[stepIdx].copyWith(media: updatedMedia);
    state = state.copyWith(steps: newList);
  }

  void removeStep(int index) {
    final newList = [...state.steps]..removeAt(index);
    final newErrors = [...state.stepErrors]..removeAt(index);
    state = state.copyWith(steps: newList, stepErrors: newErrors);
  }

  // --- NGUYÊN LIỆU ---
  void addIngredient() {
    state = state.copyWith(
      ingredients: [...state.ingredients, ''],
      ingredientErrors: [...state.ingredientErrors, null],
    );
  }
  void updateIngredient(int index, String value) {
    final newList = [...state.ingredients];
    newList[index] = value;
    state = state.copyWith(ingredients: newList);
  }
  void removeIngredient(int index) {
    final newList = [...state.ingredients]..removeAt(index);
    final newErrors = [...state.ingredientErrors]..removeAt(index);
    state = state.copyWith(ingredients: newList, ingredientErrors: newErrors);
  }

  // --- ĐĂNG CÔNG THỨC ---
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
      // Tách lấy ảnh đại diện cho từng bước (lấy ảnh đầu tiên trong mảng media của bước đó)
      // Nếu bước đó không có ảnh, gán chuỗi rỗng ''
      List<String> extractedStepImages = state.steps.map((s) {
        return s.media.isNotEmpty ? s.media.first : '';
      }).toList();

      final publishData = PublishRecipe(
        title: state.title,
        description: state.description,
        images: state.images,
        servings: state.servings,
        cookingTime: state.cookingTime,
        difficulty: state.difficulty,
        ingredients: state.ingredients,
        steps: state.steps.map((s) => s.content).toList(),
        durations: state.steps.map((s) => s.duration ?? '0 phút').toList(),

        stepImages: extractedStepImages, // <--- TRUYỀN DỮ LIỆU ẢNH BƯỚC VÀO ĐÂY

        tags: state.selectedCategories,
      );

      final success = await _publishService.publishToUserCollection(publishData);

      if (context.mounted) {
        Navigator.pop(context);
        if (success) {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Đăng bài thành công!'), backgroundColor: Colors.green));
          if (state.id != null) await ref.read(draftServiceProvider).deleteDraft(state.id!);
          state = AddRecipeState();
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