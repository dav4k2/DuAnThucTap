import 'package:uuid/uuid.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DraftRecipe {
  final String id;
  final String title;
  final String description;
  final List<String> images; // Ảnh đại diện của cả bài
  final String? video;
  final String? servings;
  final String? cookingTime;
  final String? difficulty;
  final List<String> ingredients;
  final List<String> steps;
  final List<String?> stepDurations; // [MỚI] Lưu số phút từng bước
  final List<List<String>> stepMedia; // [MỚI] Lưu danh sách ảnh/video từng bước
  final DateTime savedAt;

  DraftRecipe({
    String? id,
    required this.title,
    this.description = '',
    this.images = const [],
    this.video,
    this.servings,
    this.cookingTime,
    this.difficulty,
    this.ingredients = const [],
    this.steps = const [],
    this.stepDurations = const [],
    this.stepMedia = const [],
    DateTime? savedAt,
  })  : id = id ?? const Uuid().v4(),
        savedAt = savedAt ?? DateTime.now();

  String get thumbnail => images.isNotEmpty ? images.first : 'assets/images/placeholder_recipe.jpg';

  String get timeAgo {
    final diff = DateTime.now().difference(savedAt);
    if (diff.inMinutes < 60) return 'Vừa xong';
    if (diff.inHours < 24) return '${diff.inHours} giờ trước';
    if (diff.inDays < 7) return '${diff.inDays} ngày trước';
    return '${savedAt.day}/${savedAt.month}';
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'description': description,
    'images': images,
    'video': video,
    'servings': servings,
    'cookingTime': cookingTime,
    'difficulty': difficulty,
    'ingredients': ingredients,
    'steps': steps,
    'stepDurations': stepDurations,
    'stepMedia': stepMedia,
    'savedAt': savedAt.toIso8601String(),
  };

  factory DraftRecipe.fromJson(Map<String, dynamic> json) {
    DateTime date;
    if (json['savedAt'] is Timestamp) {
      date = (json['savedAt'] as Timestamp).toDate();
    } else if (json['savedAt'] is String) {
      date = DateTime.parse(json['savedAt']);
    } else {
      date = DateTime.now();
    }

    return DraftRecipe(
      id: json['id'] ?? const Uuid().v4(),
      title: json['title'] ?? 'Công thức không tên',
      description: json['description'] ?? '',
      images: List<String>.from(json['images'] ?? []),
      video: json['video'],
      servings: json['servings'],
      cookingTime: json['cookingTime'],
      difficulty: json['difficulty'],
      ingredients: List<String>.from(json['ingredients'] ?? []),
      steps: List<String>.from(json['steps'] ?? []),
      // Parse List<String?> từ Firestore
      stepDurations: List<String?>.from(json['stepDurations'] ?? []),
      // Parse List<List<String>> từ Firestore
      stepMedia: (json['stepMedia'] as List?)
          ?.map((e) => List<String>.from(e as List))
          .toList() ?? [],
      savedAt: date,
    );
  }
}