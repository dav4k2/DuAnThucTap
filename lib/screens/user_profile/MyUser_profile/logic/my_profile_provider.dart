// lib/providers/my_chef_provider.dart
import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../survey/logic/survey_provider.dart'; // sửa lại đúng đường dẫn nếu khác

// ====================== ENUM & MODEL (GIỮ NGUYÊN) ======================
enum ProfileTab { congThuc, tieuSu, anh, danhGia }
enum MealTab { tatCa, buaSang, buaTrua, anVat }
enum ReviewFilter { newest, oldest, all }

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

class MyChef {
  final String id;
  final String name;
  final String title;
  // THÊM 2 TRƯỜNG NÀY
  final String? country;
  final String? cookingTitle;

  final int recipes;
  final String followers;
  final int following;
  final List<Recipe> allRecipes;
  final List<Review> allReviews;
  final String? bio;
  final String? email;
  final String? joinedDate;
  final String avatarUrl;
  final String headerImage;

  MyChef({
    required this.id,
    required this.name,
    required this.title,
    this.country,        // Thêm vào constructor
    this.cookingTitle,   // Thêm vào constructor
    required this.recipes,
    required this.followers,
    required this.following,
    required this.allRecipes,
    required this.allReviews,
    this.bio,
    this.email,
    this.joinedDate,
    required this.avatarUrl,
    required this.headerImage,
  });
}

// ====================== PROVIDERS ======================
final myProfileTabProvider = StateProvider<ProfileTab>((_) => ProfileTab.congThuc);
final myMealTabProvider = StateProvider<MealTab>((_) => MealTab.tatCa);
final myReviewFilterProvider = StateProvider<ReviewFilter>((_) => ReviewFilter.newest);

// ====================== DỮ LIỆU CHÍNH – ĐỒNG BỘ 100% VỚI SURVEY ======================
final myChefProvider = Provider<MyChef>((ref) {
  final survey = ref.watch(surveyProvider);

  // Danh sách review mẫu (giữ nguyên như bạn đã có)
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

  // Danh sách công thức mẫu (giữ nguyên như bạn đã viết)
  final allRecipes = [
    Recipe(title: "Gà rán KFC", time: "30 phút", difficulty: "Dễ", author: "Kong Fuong", rating: 4.8, reviews: 1000, meal: MealTab.tatCa, imageAsset: "image/garan.png"),
    Recipe(title: "Bánh mì kẹp", time: "15 phút", difficulty: "Dễ", author: "Kong Fuong", rating: 4.9, reviews: 850, meal: MealTab.buaSang, imageAsset: "image/profile_bg.png"),
    Recipe(title: "Phở bò", time: "45 phút", difficulty: "Trung bình", author: "Kong Fuong", rating: 5.0, reviews: 1200, meal: MealTab.buaTrua, imageAsset: "image/profile_bg.png"),
    Recipe(title: "Chè thái", time: "20 phút", difficulty: "Dễ", author: "Kong Fuong", rating: 4.7, reviews: 600, meal: MealTab.anVat, imageAsset: "image/profile_bg.png"),
    // bạn có thể thêm thoải mái ở đây
  ];

  return MyChef(
    id: "my_chef_id",
    name: survey.displayName?.trim().isNotEmpty == true ? survey.displayName! : "Kong Fuong",
    title: survey.cookingTitle ?? "Đầu bếp đam mê",

    country: survey.country ?? "Việt Nam",
    cookingTitle: survey.cookingTitle ?? "Đầu bếp tại gia",

    bio: survey.bio?.trim().isNotEmpty == true ? survey.bio : "Mô tả mặc định...",
    email: survey.email ?? "chua_cap_nhat@gmail.com",
    joinedDate: survey.joinedDate ?? "Đang cập nhật",
    avatarUrl: survey.avatarFile?.path ?? "image/profile_bg.png",
    headerImage: survey.coverFile?.path ?? "image/profile_bg.png",
    recipes: allRecipes.length,
    followers: "45.6k",
    following: 15,
    allRecipes: allRecipes,
    allReviews: rawReviews,
  );
});

// Lọc review (giữ nguyên)
final myFilteredReviewsProvider = Provider<List<Review>>((ref) {
  final chef = ref.watch(myChefProvider);
  final filter = ref.watch(myReviewFilterProvider);
  final sorted = List<Review>.from(chef.allReviews);

  switch (filter) {
    case ReviewFilter.newest:
    // giả sử timeAgo dạng text, bạn có thể thay bằng DateTime thật sau
    // tạm thời để nguyên
      break;
    case ReviewFilter.oldest:
      break;
    case ReviewFilter.all:
    default:
      break;
  }
  return sorted;
});


//Danh sách chờ duyệt
final pendingRecipesSample = [
  Recipe(
    title: "Bánh cuốn thanh trì nhân tôm",
    time: "40 phút",
    difficulty: "Khó",
    author: "Kong Fuong",
    rating: 0.0,        // chưa có đánh giá vì đang chờ duyệt
    reviews: 0,
    meal: MealTab.buaSang,
    imageAsset: "image/profile_bg.png",
  ),
  Recipe(
    title: "Cá kho tộ kiểu miền Tây",
    time: "1 giờ",
    difficulty: "Trung bình",
    author: "Kong Fuong",
    rating: 0.0,
    reviews: 0,
    meal: MealTab.buaTrua,
    imageAsset: "image/garan.png",
  ),
  Recipe(
    title: "Sinh tố bơ dừa hạt chia",
    time: "10 phút",
    difficulty: "Dễ",
    author: "Kong Fuong",
    rating: 0.0,
    reviews: 0,
    meal: MealTab.anVat,
    imageAsset: "image/profile_bg.png",
  ),
];
final myPendingRecipesProvider = Provider<List<Recipe>>((ref) {
  // TODO: Sau này bạn thay bằng Firestore query:
  // final userId = ref.watch(currentUserProvider).id;
  // return await fetchPendingRecipesFromFirestore(userId);

  // Hiện tại dùng dữ liệu mẫu
  return pendingRecipesSample;
});