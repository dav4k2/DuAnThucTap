import 'package:uuid/uuid.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class PublishRecipe{
  final String id;
  final String? authorId;
  final String title;
  final String description;
  final List<String> images;
  final String? video;
  final String? servings;
  final String? cookingTime;
  final String? difficulty;
  final List<String> ingredients;
  final List<String> steps;
  final DateTime createdAt;

  PublishRecipe({
    String? id,
    this.authorId,
    required this.title,
    this.description = '',
    this.images = const [],
    this.video,
    this.servings,
    this.cookingTime,
    this.difficulty,
    this.ingredients = const [],
    this.steps = const [],
    DateTime? createdAt,
  })  : id = id ?? const Uuid().v4(),
        createdAt = createdAt ?? DateTime.now();

  String get thumbnail => images.isNotEmpty ? images.first : 'assets/images/placeholder_recipe.jpg';

  String get timeAgo {
    final diff = DateTime.now().difference(createdAt);
    if (diff.inMinutes < 60) return 'Vừa xong';
    if (diff.inHours < 24) return '${diff.inHours} giờ trước';
    if (diff.inDays < 7) return '${diff.inDays} ngày trước';
    return '${createdAt.day}/${createdAt.month}';
  }

  PublishRecipe copyWith({
    String? authorId,
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
      authorId: authorId ?? this.authorId,
      title: title ?? this.title,
      description: description ?? this.description,
      images: images ?? this.images,
      video: video ?? this.video,
      servings: servings ?? this.servings,
      cookingTime: cookingTime ?? this.cookingTime,
      difficulty: difficulty ?? this.difficulty,
      ingredients: ingredients ?? this.ingredients,
      steps: steps ?? this.steps,
      createdAt: DateTime.now(),
    );
  }

  Map<String, dynamic> toFirestore() => {
    'id': id,
    'authorId': authorId,
    'title': title,
    'description': description,
    'images': images,
    'video': video,
    'servings': servings,
    'cookingTime': cookingTime,
    'difficulty': difficulty,
    'ingredients': ingredients,
    'steps': steps,
    'createdAt': FieldValue.serverTimestamp(),
  };

  factory PublishRecipe.fromFirestore(
      QueryDocumentSnapshot<Map<String, dynamic>> doc,
      ) {
    final data = doc.data();

    return PublishRecipe(
      id: doc.id,
      authorId: data['authorId'],
      title: data['title'] ?? 'Công thức không tên',
      description: data['description'] ?? '',
      images: List<String>.from(data['images'] ?? []),
      video: data['video'],
      servings: data['servings'],
      cookingTime: data['cookingTime'],
      difficulty: data['difficulty'],
      ingredients: List<String>.from(data['ingredients'] ?? []),
      steps: List<String>.from(data['steps'] ?? []),
      createdAt: (data['createdAt'] as Timestamp?)?.toDate() ??
          DateTime.fromMillisecondsSinceEpoch(0),
    );
  }
}