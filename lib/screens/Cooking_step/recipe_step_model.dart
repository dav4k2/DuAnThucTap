// lib/screens/Cooking_step/recipe_step_model.dart

class RecipeStep {
  final String title;       // Tên bước
  final String description; // Hướng dẫn
  final String imagePath;   // Ảnh
  final int prepTime;       // Thời gian đếm ngược vòng tròn (VD: 5 giây)
  final int cookingTime;    // Thời gian đếm ngược nấu ăn (VD: 30 phút = 1800 giây)

  RecipeStep({
    required this.title,
    required this.description,
    required this.imagePath,
    this.prepTime = 5,      // Mặc định chuẩn bị 5s
    this.cookingTime = 0,   // Mặc định 0 (không cần bấm giờ)
  });
}