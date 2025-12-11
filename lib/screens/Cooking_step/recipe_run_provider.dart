import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fontend/screens/Cooking_step/recipe_step_model.dart';

final recipeStepsProvider = Provider<List<RecipeStep>>((ref) {
  return [
    // BƯỚC 1: Sơ chế
    RecipeStep(
      title: "Sơ chế nguyên liệu",
      description: "Rửa sạch rau củ, thái nhỏ thịt bò, chuẩn bị gia vị cần thiết.",
      imagePath: "image/p1.png",
      prepTime: 5,        // 5s chuẩn bị
      cookingTime: 900,   // <--- SỬA Ở ĐÂY: 900 giây = 15 phút (Để hiện nút Bắt đầu)
    ),

    // BƯỚC 2: Ninh nước dùng
    RecipeStep(
      title: "Chế nước dùng",
      description: "Thêm nước vào nồi, đun đến khi sôi thì vớt hết bọt, thêm gói vị phở rồi ninh 30p.",
      imagePath: "image/p3.png",
      prepTime: 5,
      cookingTime: 1800,   // 30 phút
    ),

    // BƯỚC 3: Trần bánh phở
    RecipeStep(
      title: "Trần bánh phở",
      description: "Đun nước sôi, trần bánh phở trong 1 phút rồi vớt ra để ráo.",
      imagePath: "image/p2.png",
      prepTime: 5,
      cookingTime: 60,    // 1 phút
    ),
  ];
});

final currentStepIndexProvider = StateProvider<int>((ref) => 0);