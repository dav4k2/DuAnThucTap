// lib/logic/chef_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../widgets/review_tab.dart';

enum ProfileTab { congThuc, tieuSu, anh, danhGia }
enum MealTab { tatCa, buaSang, buaTrua, anVat }

// === RECIPE MODEL ===
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

// === CHEF MODEL ===
class Chef {
  final String id;
  final String name;
  final String title;
  final int recipes;
  final String followers;
  final int following;
  final List<Recipe> allRecipes;
  final bool isFollowing;
  final String? bio;
  final String? email;
  final String? joinedDate;

  Chef({
    required this.id,
    required this.name,
    required this.title,
    required this.recipes,
    required this.followers,
    required this.following,
    required this.allRecipes,
    required this.isFollowing,
    this.bio,
    this.email,
    this.joinedDate,
  });
}

// === PROVIDERS ===
final profileTabProvider = StateProvider<ProfileTab>((_) => ProfileTab.congThuc);
final mealTabProvider = StateProvider<MealTab>((_) => MealTab.tatCa);

// MỚI: Quản lý trạng thái theo dõi (dùng family để mở rộng nhiều chef)
final followStateProvider = StateProvider.family<bool, String>((ref, chefId) => false);

final reviewFilterProvider = StateProvider<ReviewFilter>((_) => ReviewFilter.newest);

final chefProviderbio = Provider<Chef>((ref) {
  return Chef(
    id: "chef_kong_fuong",
    name: "Kong Fuong",
    title: "Đầu bếp chuyên nghiệp",
    recipes: 7,
    followers: "45.6k",
    following: 15,
    isFollowing: ref.watch(followStateProvider("chef_kong_fuong")),
    bio: "Một đầu bếp xuất thân từ đường phố, không trải qua đào tạo bài bản, chỉ có niềm tin vào câu nói “Ai cũng có thể nấu” của Auguste Gusteau. Tôi đã thành công và thậm chí còn khiến cho Arsene Wenger phải khen món ăn của mình.",
    email: "kongfuongchef@gmail.com",
    joinedDate: "10/09/2024",
    allRecipes: [/* ... */],
  );
});

// MỚI: Chef Provider
final chefProvider = Provider<Chef>((ref) {
  return Chef(
    id: "chef_kong_fuong",
    name: "Kong Fuong",
    title: "Đầu bếp chuyên nghiệp",
    recipes: 7,
    followers: "45.6k",
    following: 15,
    isFollowing: ref.watch(followStateProvider("chef_kong_fuong")),
    allRecipes: [
      Recipe(
        title: "Gà rán KFC",
        time: "30 phút",
        difficulty: "Dễ",
        author: "Kong Fuong",
        rating: 4.8,
        reviews: 1000,
        meal: MealTab.tatCa,
        imageAsset: "image/garan.png",
      ),
      Recipe(
        title: "Bánh mì kẹp",
        time: "15 phút",
        difficulty: "Dễ",
        author: "Kong Fuong",
        rating: 4.9,
        reviews: 850,
        meal: MealTab.buaSang,
        imageAsset: "image/profile_bg.png",
      ),
      Recipe(
        title: "Phở bò",
        time: "45 phút",
        difficulty: "Trung bình",
        author: "Kong Fuong",
        rating: 5.0,
        reviews: 1200,
        meal: MealTab.buaTrua,
        imageAsset: "image/profile_bg.png",
      ),
      Recipe(
        title: "Phở bò",
        time: "45 phút",
        difficulty: "Trung bình",
        author: "Kong Fuong",
        rating: 5.0,
        reviews: 1200,
        meal: MealTab.buaTrua,
        imageAsset: "image/profile_bg.png",
      ),
      Recipe(
        title: "Phở bò",
        time: "45 phút",
        difficulty: "Trung bình",
        author: "Kong Fuong",
        rating: 5.0,
        reviews: 1200,
        meal: MealTab.buaTrua,
        imageAsset: "image/profile_bg.png",
      ),
      Recipe(
        title: "Phở bò",
        time: "45 phút",
        difficulty: "Trung bình",
        author: "Kong Fuong",
        rating: 5.0,
        reviews: 1200,
        meal: MealTab.buaTrua,
        imageAsset: "image/profile_bg.png",
      ),
      Recipe(
        title: "Phở bò",
        time: "45 phút",
        difficulty: "Trung bình",
        author: "Kong Fuong",
        rating: 5.0,
        reviews: 1200,
        meal: MealTab.buaTrua,
        imageAsset: "image/profile_bg.png",
      ),
      Recipe(
        title: "Chè thái",
        time: "20 phút",
        difficulty: "Dễ",
        author: "Kong Fuong",
        rating: 4.7,
        reviews: 600,
        meal: MealTab.anVat,
        imageAsset: "image/profile_bg.png",
      ),
    ],
  );
});