import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
// Lưu ý: Import đúng các service của bạn
import '../../../Service/recipe_model.dart'; // Giả sử bạn có model này
import '../../../Service/recipe_service.dart';
import '../../Crete_recipe/logic/draft_service.dart';
import '../../Crete_recipe/logic/draft_recipe.dart';
import '../../Crete_recipe/logic/publish_recipe.dart';
import '../../Crete_recipe/logic/publish_service.dart';
import '../widgets/edit_exit_confirmation_dialog.dart';
import '../widgets/edit_missing_info_dialog.dart';

/// Model từng bước (Giữ nguyên hoặc import từ file chung)
class EditRecipeStepModel {
  final String content;
  final String? duration;
  final List<String> media;

  EditRecipeStepModel({
    this.content = '',
    this.duration,
    this.media = const [],
  });

  EditRecipeStepModel copyWith({String? content, String? duration, List<String>? media}) {
    return EditRecipeStepModel(
      content: content ?? this.content,
      duration: duration ?? this.duration,
      media: media ?? this.media,
    );
  }
}

/// State riêng cho màn hình Edit
class EditRecipeState {
  final String? id; // ID của bài viết đang sửa
  final List<String> images;
  final String? video;
  final String title;
  final String description;
  final String? servings;
  final String? cookingTime;
  final String? difficulty;
  final List<String> ingredients;
  final List<EditRecipeStepModel> steps;
  final List<String> selectedCategories;

  // Errors
  final String? nameError;
  final String? descriptionError;
  final String? servingsError;
  final String? cookingTimeError;
  final String? difficultyError;
  final List<String?> ingredientErrors;
  final List<String?> stepErrors;

  EditRecipeState({
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
    this.selectedCategories = const [],
    this.nameError,
    this.descriptionError,
    this.servingsError,
    this.cookingTimeError,
    this.difficultyError,
    List<String?>? ingredientErrors,
    List<String?>? stepErrors,
  })  : ingredientErrors = ingredientErrors ?? [],
        stepErrors = stepErrors ?? [];

  EditRecipeState copyWith({
    String? id,
    List<String>? images,
    String? video,
    String? title,
    String? description,
    String? servings,
    String? cookingTime,
    String? difficulty,
    List<String>? ingredients,
    List<EditRecipeStepModel>? steps,
    List<String>? selectedCategories,
    String? nameError,
    String? descriptionError,
    String? servingsError,
    String? cookingTimeError,
    String? difficultyError,
    List<String?>? ingredientErrors,
    List<String?>? stepErrors,
  }) {
    return EditRecipeState(
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

/// Notifier quản lý logic Edit
class EditRecipeNotifier extends StateNotifier<EditRecipeState> {
  final Ref ref;
  final _publishService = PublishService();

  final List<String> allCategories = [
    'Bữa trưa', 'Món khô', 'Món Á', 'Bữa sáng', 'Phở', 'Trà',
    'Bữa tối', 'Cơm', 'Healthy', 'Ăn vặt', 'Món trộn', 'Đồ ăn nhanh',
    'Món nước', 'Món Âu', 'Hải sản'
  ];

  static const List<String> validServings = ['1 người', '2 người', '3-4 người', '5-6 người', '7+ người'];
  static const List<String> validTime = ['Dưới 15 phút', '15-30 phút', '30-60 phút', 'Trên 1 tiếng'];
  static const List<String> validDifficulty = ['Dễ', 'Trung bình', 'Khó'];

  EditRecipeNotifier(this.ref) : super(EditRecipeState());

  // --- 1. HÀM INIT DỮ LIỆU (Mapping từ PublishRecipe -> State) ---
  void initializeData(PublishRecipe oldRecipe) {
    // Mapping danh sách steps, durations và stepImages thành List<EditRecipeStepModel>
    List<EditRecipeStepModel> mappedSteps = [];
    int maxSteps = oldRecipe.steps.length;

    for (int i = 0; i < maxSteps; i++) {
      String content = oldRecipe.steps[i];
      String? duration = (i < oldRecipe.durations.length) ? oldRecipe.durations[i] : null;

      // Xử lý ảnh bước: Backend lưu List<String> tương ứng index
      List<String> media = [];
      if (i < oldRecipe.stepImages.length && oldRecipe.stepImages[i].isNotEmpty) {
        media.add(oldRecipe.stepImages[i]);
      }

      mappedSteps.add(EditRecipeStepModel(
        content: content,
        duration: duration,
        media: media,
      ));
    }

    // Cập nhật State
    state = state.copyWith(
      id: oldRecipe.id,
      title: oldRecipe.title,
      description: oldRecipe.description,
      images: List.from(oldRecipe.images), // Copy list để tránh tham chiếu
      video: oldRecipe.video,
      servings: oldRecipe.servings,
      cookingTime: oldRecipe.cookingTime,
      difficulty: oldRecipe.difficulty,
      ingredients: List.from(oldRecipe.ingredients),
      steps: mappedSteps,
      // Mapping categories/tags nếu có
      selectedCategories: List.from(oldRecipe.tags),

      // Reset lỗi
      ingredientErrors: List.filled(oldRecipe.ingredients.length, null),
      stepErrors: List.filled(mappedSteps.length, null),
    );
  }

  void toggleCategory(String category) {
    final current = state.selectedCategories;
    if (current.contains(category)) {
      state = state.copyWith(selectedCategories: current.where((t) => t != category).toList());
    } else {
      state = state.copyWith(selectedCategories: [...current, category]);
    }
  }

  Future<void> handleBackPressed(BuildContext context) async {
    final shouldExit = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (_) => const EditExitConfirmationDialog(),
    );
    if (shouldExit == true && context.mounted) {
      Navigator.of(context).pop();
    }
  }

  // --- CÁC HÀM UPDATE (GIỮ NGUYÊN LOGIC) ---
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

  void addStep() {
    state = state.copyWith(
      steps: [...state.steps, EditRecipeStepModel()],
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

  // --- LƯU NHÁP (CHO EDIT) ---
  Future<bool> saveAsDraft(BuildContext context) async {
    // Logic lưu nháp cho Edit (nếu cần)
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Chức năng đang phát triển')));
    }
    return true;
  }

  // --- CẬP NHẬT BÀI VIẾT ---
  Future<String?> validateAndUpdate() async {
    // 1. Validate dữ liệu
    if (state.title.trim().isEmpty) return 'Vui lòng nhập tên công thức';
    if (state.description.trim().isEmpty) return 'Vui lòng nhập mô tả';
    if (state.ingredients.isEmpty || state.ingredients.every((e) => e.trim().isEmpty)) {
      return 'Cần ít nhất 1 nguyên liệu';
    }
    if (state.steps.isEmpty || state.steps.every((e) => e.content.trim().isEmpty)) {
      return 'Cần ít nhất 1 bước thực hiện';
    }

    try {
      // 2. Chuẩn bị dữ liệu để update
      // Tách EditRecipeStepModel thành các List riêng lẻ cho Backend
      List<String> stepsContent = [];
      List<String> stepsDuration = [];
      List<String> stepsImages = [];

      for (var step in state.steps) {
        stepsContent.add(step.content);
        stepsDuration.add(step.duration ?? "");
        // Logic hiện tại: Mỗi bước chỉ lưu 1 ảnh trên Backend
        if (step.media.isNotEmpty) {
          stepsImages.add(step.media.first);
        } else {
          stepsImages.add(""); // Giữ chỗ index nếu không có ảnh
        }
      }

      // Tạo object PublishRecipe mới từ State
      final updatedRecipe = PublishRecipe(
        id: state.id, // ID cũ
        authorId: null, // Service sẽ tự lấy current user
        title: state.title,
        description: state.description,
        images: state.images,
        video: state.video,
        servings: state.servings,
        cookingTime: state.cookingTime,
        difficulty: state.difficulty,
        ingredients: state.ingredients.where((e) => e.trim().isNotEmpty).toList(),
        steps: stepsContent,
        durations: stepsDuration,
        stepImages: stepsImages,
        tags: state.selectedCategories,
        // rating giữ nguyên, backend sẽ xử lý logic update
      );

      // 3. Gọi Service (Service đã có logic upload ảnh)
      final success = await _publishService.updatePublishRecipe(updatedRecipe);

      if (success) {
        return null; // Thành công
      } else {
        return "Cập nhật thất bại. Vui lòng thử lại.";
      }
    } catch (e) {
      return "Lỗi hệ thống: $e";
    }
  }
}

// KHAI BÁO PROVIDER RIÊNG
final editRecipeProvider = StateNotifierProvider.autoDispose<EditRecipeNotifier, EditRecipeState>((ref) => EditRecipeNotifier(ref));