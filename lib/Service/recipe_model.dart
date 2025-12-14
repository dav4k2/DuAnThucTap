import 'package:cloud_firestore/cloud_firestore.dart';

class RecipeModel {
  final String id;
  final String authorId;
  final String title;
  final String description;
  final List<String> images;
  final String? video;
  final String servings;
  final String cookingTime;
  final String difficulty;
  final List<String> ingredients;
  final List<String> steps;
  final int likesCount;
  final DateTime createdAt;

  RecipeModel({
    required this.id,
    required this.authorId,
    required this.title,
    required this.description,
    required this.images,
    this.video,
    required this.servings,
    required this.cookingTime,
    required this.difficulty,
    required this.ingredients,
    required this.steps,
    this.likesCount = 0,
    required this.createdAt,
  });

  Map<String, dynamic> toJson() {
    return {
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
      'likesCount': likesCount,
      'createdAt': FieldValue.serverTimestamp(),
    };
  }

  factory RecipeModel.fromSnapshot(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return RecipeModel(
      id: doc.id,
      authorId: data['authorId'] ?? '',
      title: data['title'] ?? '',
      description: data['description'] ?? '',
      images: List<String>.from(data['images'] ?? []),
      video: data['video'],
      servings: data['servings'] ?? '',
      cookingTime: data['cookingTime'] ?? '',
      difficulty: data['difficulty'] ?? '',
      ingredients: List<String>.from(data['ingredients'] ?? []),
      steps: List<String>.from(data['steps'] ?? []),
      likesCount: data['likesCount'] ?? 0,
      createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }
}