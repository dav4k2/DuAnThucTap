// lib/logic/my_profile_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';

// === ENUMS (giữ nguyên, dùng chung toàn app) ===
enum ProfileTab { congThuc, tieuSu, anh, danhGia }
enum MealTab { tatCa, buaSang, buaTrua, anVat }
enum ReviewFilter { newest, oldest, all }

// === MODEL (giữ nguyên 100%) ===
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

class Review {
  final String name;
  final String comment;
  final int rating;
  final String timeAgo;
  final String avatar;

  Review({
    required this.name,
    required this.comment,
    required this.rating,
    required this.timeAgo,
    required this.avatar,
  });
}

// Model chính của "Tôi" (user đã đăng nhập)
class MyChef {
  final String id;
  final String name;
  final String title;
  final int recipes;
  final String followers;
  final int following;
  final List<Recipe> allRecipes;
  final List<Review> allReviews;
  final String? bio;
  final String? email;
  final String? joinedDate;
  final String avatarUrl;

  MyChef({
    required this.id,
    required this.name,
    required this.title,
    required this.recipes,
    required this.followers,
    required this.following,
    required this.allRecipes,
    required this.allReviews,
    this.bio,
    this.email,
    this.joinedDate,
    this.avatarUrl = "image/avatar.png",
  });
}

// ====================== PROVIDERS RIÊNG CHO TRANG CÁ NHÂN ======================
final myProfileTabProvider = StateProvider<ProfileTab>((_) => ProfileTab.congThuc);
final myMealTabProvider = StateProvider<MealTab>((_) => MealTab.tatCa);
final myReviewFilterProvider = StateProvider<ReviewFilter>((_) => ReviewFilter.newest);

// Dữ liệu của chính mình (sau này sẽ lấy từ auth + firestore)
final myChefProvider = Provider<MyChef>((ref) {
  final rawReviews = [
    Review(name: 'Gordon Ramsay', comment: 'Một đầu bếp tuyệt vời!!', rating: 5, timeAgo: '1 tuần trước', avatar: 'https://placehold.co/45x45'),
    Review(name: 'Remy', comment: 'Ông là idol của tôi', rating: 5, timeAgo: '2 ngày trước', avatar: 'https://placehold.co/45x45'),
    Review(name: 'User A', comment: 'Công thức dễ làm, cảm ơn chef!', rating: 4, timeAgo: '3 ngày trước', avatar: 'https://placehold.co/45x45'),
    Review(name: 'User B', comment: 'Tuyệt vời! Gà rán ngon nhất từng ăn.', rating: 5, timeAgo: '1 tháng trước', avatar: 'https://placehold.co/45x45'),
    Review(name: 'User C', comment: 'Học được nhiều kỹ thuật hay!', rating: 5, timeAgo: '1 giờ trước', avatar: 'https://placehold.co/45x45'),
    Review(name: 'User D', comment: 'Video rõ ràng, dễ hiểu.', rating: 4, timeAgo: '2 giờ trước', avatar: 'https://placehold.co/45x45'),
    Review(name: 'User E', comment: 'Món ăn đẹp mắt, ngon miệng!', rating: 5, timeAgo: '3 giờ trước', avatar: 'https://placehold.co/45x45'),
    Review(name: 'User F', comment: 'Rất sáng tạo!', rating: 5, timeAgo: '4 giờ trước', avatar: 'https://placehold.co/45x45'),
    Review(name: 'User G', comment: 'Cần thêm video chi tiết.', rating: 3, timeAgo: '5 giờ trước', avatar: 'https://placehold.co/45x45'),
  ];

  return MyChef(
    id: "my_chef_id",               // sau này thay = currentUser.uid
    name: "Kong Fuong",
    title: "Đầu bếp chuyên nghiệp",
    recipes: 7,
    followers: "45.6k",
    following: 15,
    bio: "Một đầu bếp xuất thân từ đường phố, không trải qua đào tạo bài bản, chỉ có niềm tin vào câu nói “Ai cũng có thể nấu” của Auguste Gusteau. Tôi đã thành công và thậm chí còn khiến cho Arsene Wenger phải khen món ăn của mình.",
    email: "kongfuongchef@gmail.com",
    joinedDate: "10/09/2024",
    allRecipes: [
      Recipe(title: "Gà rán KFC", time: "30 phút", difficulty: "Dễ", author: "Kong Fuong", rating: 4.8, reviews: 1000, meal: MealTab.tatCa, imageAsset: "image/garan.png"),
      Recipe(title: "Bánh mì kẹp", time: "15 phút", difficulty: "Dễ", author: "Kong Fuong", rating: 4.9, reviews: 850, meal: MealTab.buaSang, imageAsset: "image/profile_bg.png"),
      Recipe(title: "Bánh mì kẹp", time: "15 phút", difficulty: "Dễ", author: "Kong Fuong", rating: 4.9, reviews: 850, meal: MealTab.buaSang, imageAsset: "image/profile_bg.png"),
      Recipe(title: "Bánh mì kẹp", time: "15 phút", difficulty: "Dễ", author: "Kong Fuong", rating: 4.9, reviews: 850, meal: MealTab.buaSang, imageAsset: "image/profile_bg.png"),
      Recipe(title: "Bánh mì kẹp", time: "15 phút", difficulty: "Dễ", author: "Kong Fuong", rating: 4.9, reviews: 850, meal: MealTab.buaSang, imageAsset: "image/profile_bg.png"),
      Recipe(title: "Bánh mì kẹp", time: "15 phút", difficulty: "D ễ", author: "Kong Fuong", rating: 4.9, reviews: 850, meal: MealTab.buaSang, imageAsset: "image/profile_bg.png"),
      Recipe(title: "Phở bò", time: "45 phút", difficulty: "Trung bình", author: "Kong Fuong", rating: 5.0, reviews: 1200, meal: MealTab.buaTrua, imageAsset: "image/profile_bg.png"),
      Recipe(title: "Phở bò", time: "45 phút", difficulty: "Trung bình", author: "Kong Fuong", rating: 5.0, reviews: 1200, meal: MealTab.buaTrua, imageAsset: "image/profile_bg.png"),
      Recipe(title: "Phở bò", time: "45 phút", difficulty: "Trung bình", author: "Kong Fuong", rating: 5.0, reviews: 1200, meal: MealTab.buaTrua, imageAsset: "image/profile_bg.png"),
      Recipe(title: "Phở bò", time: "45 phút", difficulty: "Trung bình", author: "Kong Fuong", rating: 5.0, reviews: 1200, meal: MealTab.buaTrua, imageAsset: "image/profile_bg.png"),
      Recipe(title: "Phở bò", time: "45 phút", difficulty: "Trung bình", author: "Kong Fuong", rating: 5.0, reviews: 1200, meal: MealTab.buaTrua, imageAsset: "image/profile_bg.png"),
      Recipe(title: "Phở bò", time: "45 phút", difficulty: "Trung bình", author: "Kong Fuong", rating: 5.0, reviews: 1200, meal: MealTab.buaTrua, imageAsset: "image/profile_bg.png"),
      Recipe(title: "Phở bò", time: "45 phút", difficulty: "Trung bình", author: "Kong Fuong", rating: 5.0, reviews: 1200, meal: MealTab.buaTrua, imageAsset: "image/profile_bg.png"),
      Recipe(title: "Chè thái", time: "20 phút", difficulty: "Dễ", author: "Kong Fuong", rating: 4.7, reviews: 600, meal: MealTab.anVat, imageAsset: "image/profile_bg.png"),
    ],
    allReviews: rawReviews,
  );
});

// Lọc review cho trang cá nhân
final myFilteredReviewsProvider = Provider<List<Review>>((ref) {
  final chef = ref.watch(myChefProvider);
  final filter = ref.watch(myReviewFilterProvider);

  final sorted = List<Review>.from(chef.allReviews);

  switch (filter) {
    case ReviewFilter.newest:
      sorted.sort((a, b) => b.timeAgo.compareTo(a.timeAgo));
      break;
    case ReviewFilter.oldest:
      sorted.sort((a, b) => a.timeAgo.compareTo(b.timeAgo));
      break;
    case ReviewFilter.all:
    default:
      break;
  }
  return sorted;
});