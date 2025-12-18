import 'package:uuid/uuid.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class PublishRecipe{
  final String id;
  final String title;
  final String description;
  final List<String> images;
  final String? video;
  final String? servings;
  final String? cookingTime;
  final String? difficulty;
  final List<String> ingredients;
  final List<String> steps;
  final DateTime savedAt;

  PublishRecipe({
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

  PublishRecipe copyWith({
    String? title,
    String? description,
    List<String>? images,
    String? video,
    String? servings,
    String? cookingTime,
    String? difficulty,
    List<String>? ingredients,
    List<String>? steps,
  }) {
    return PublishRecipe(
      id: id,
      title: title ?? this.title,
      description: description ?? this.description,
      images: images ?? this.images,
      video: video ?? this.video,
      servings: servings ?? this.servings,
      cookingTime: cookingTime ?? this.cookingTime,
      difficulty: difficulty ?? this.difficulty,
      ingredients: ingredients ?? this.ingredients,
      steps: steps ?? this.steps,
      savedAt: DateTime.now(),
    );
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
    'savedAt': savedAt.toIso8601String(),
  };

  factory PublishRecipe.fromJson(Map<String, dynamic> json) {
    DateTime date;

    if (json['savedAt'] is Timestamp) {
      date = (json['savedAt'] as Timestamp).toDate();
    } else if (json['savedAt'] is String) {
      date = DateTime.parse(json['savedAt']);
    } else {
      date = DateTime.now();
    }

    return PublishRecipe(
      id: json['id'],
      title: json['title'] ?? 'Công thức không tên',
      description: json['description'] ?? '',
      images: List<String>.from(json['images'] ?? []),
      video: json['video'],
      servings: json['servings'],
      cookingTime: json['cookingTime'],
      difficulty: json['difficulty'],
      ingredients: List<String>.from(json['ingredients'] ?? []),
      steps: List<String>.from(json['steps'] ?? []),
      savedAt: date, // Gán giá trị date đã xử lý ở trên
    );
  }
}