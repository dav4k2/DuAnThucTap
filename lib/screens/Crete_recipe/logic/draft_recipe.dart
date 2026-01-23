import 'package:uuid/uuid.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DraftRecipe {
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
  final List<String?> stepDurations;
  final List<List<String>> stepMedia;
  final List<String> tags;
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
    this.tags = const [],
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
    'tags': tags,
    // Chuyển List<List<String>> thành Map để tránh lỗi Nested Array
    'stepMedia': stepMedia.asMap().map((index, list) => MapEntry(index.toString(), list)),
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

    final stepMediaRaw = json['stepMedia'];
    List<List<String>> parsedStepMedia = [];

    if (stepMediaRaw is Map) {
      // Nếu dữ liệu là Map (định dạng mới để tránh lỗi Firestore)
      // Chúng ta lấy các key, sắp xếp theo số thứ tự và chuyển về List<List>
      final sortedKeys = stepMediaRaw.keys.toList()
        ..sort((a, b) => int.parse(a).compareTo(int.parse(b)));

      parsedStepMedia = sortedKeys.map((k) {
        return List<String>.from(stepMediaRaw[k] as List? ?? []);
      }).toList();
    } else if (stepMediaRaw is List) {
      // Nếu dữ liệu vẫn là List (định dạng cũ nếu có)
      parsedStepMedia = stepMediaRaw.map((e) => List<String>.from(e as List)).toList();
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
      tags: List<String>.from(json['tags'] ?? []),
      // Parse List<List<String>> từ Firestore
      stepMedia: parsedStepMedia,
      savedAt: date,
    );
  }
}