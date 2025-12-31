import 'dart:ffi';

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
  final List<String> durations;
  final List<String> tags;
  final DateTime createdAt;
  final double averageRating;
  final int totalRatings;

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
    this.durations = const [],
    this.tags = const [],
    DateTime? createdAt,
    this.averageRating = 0.0,
    this.totalRatings = 0,
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
    List<String>? durations,
    List<String>? tags,
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
      durations: durations ?? this.durations,
      tags: tags ?? this.tags,
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
    'durations': durations,
    'tags': tags,
    'createdAt': FieldValue.serverTimestamp(),
    'averageRating': averageRating,
    'totalRatings': totalRatings,
  };

  factory PublishRecipe.fromFirestore(
      DocumentSnapshot<Map<String, dynamic>> doc,
      ) {
    final data = doc.data() ?? {};

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
      durations: List<String>.from(data['durations'] ?? []),
      tags: List<String>.from(data['tags'] ?? []),
      createdAt: (data['createdAt'] as Timestamp?)?.toDate() ??
          DateTime.fromMillisecondsSinceEpoch(0),
      averageRating: (data['averageRating'] ?? 0.0).toDouble(),
      totalRatings: data['totalRatings'] ?? 0,
    );
  }
}