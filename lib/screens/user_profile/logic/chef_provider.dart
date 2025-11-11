// lib/logic/chef_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';

enum ProfileTab { congThuc, tieuSu, anh, danhGia }
enum MealTab { tatCa, buaSang, buaTrua, anVat }

class Recipe {
  final String title;
  final String time;
  final String difficulty;
  final String author;
  final double rating;
  final int reviews;
  final MealTab meal;
  final String imageAsset;

  Recipe({
    required this.title,
    required this.time,
    required this.difficulty,
    required this.author,
    required this.rating,
    required this.reviews,
    required this.meal,
    required this.imageAsset,
  });
}

final profileTabProvider = StateProvider<ProfileTab>((_) => ProfileTab.congThuc);
final mealTabProvider = StateProvider<MealTab>((_) => MealTab.tatCa);

final chefProvider = Provider((ref) => Chef(
  name: "Kong Fuong",
  title: "Đầu bếp chuyên nghiệp",
  recipes: 7,
  followers: "45.6k",
  following: 15,
  allRecipes: [
    Recipe(title: "Gà rán KFC", time: "30 phút", difficulty: "Dễ", author: "Kong Fuong", rating: 4.8, reviews: 1000, meal: MealTab.tatCa,imageAsset: "image/vit.png"),
    Recipe(title: "Bánh mì kẹp", time: "15 phút", difficulty: "Dễ", author: "Kong Fuong", rating: 4.9, reviews: 850, meal: MealTab.buaSang,imageAsset: "image/vit.png"),
    Recipe(title: "Phở bò", time: "45 phút", difficulty: "Trung bình", author: "Kong Fuong", rating: 5.0, reviews: 1200, meal: MealTab.buaTrua,imageAsset: "image/profile_bg.png"),
    Recipe(title: "Chè thái", time: "20 phút", difficulty: "Dễ", author: "Kong Fuong", rating: 4.7, reviews: 600, meal: MealTab.anVat,imageAsset: "image/profile_bg.png"),
  ],
));

class Chef {
  final String name;
  final String title;
  final int recipes;
  final String followers;
  final int following;
  final List<Recipe> allRecipes;
  Chef({
    required this.name,
    required this.title,
    required this.recipes,
    required this.followers,
    required this.following,
    required this.allRecipes,
  });
}