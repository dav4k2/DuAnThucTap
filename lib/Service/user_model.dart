import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String id; // Đổi từ int sang String
  final String email;
  final String? displayName;
  final String? bio;
  final String? country;
  final String? cookingLevel;
  final String? avatarUrl;
  final String? coverUrl;
  final List<String> interestedCategories;
  final bool isProfileCompleted;
  final DateTime? createdAt;

  UserModel({
    required this.id,
    required this.email,
    this.displayName,
    this.bio,
    this.country,
    this.cookingLevel,
    this.avatarUrl,
    this.coverUrl,
    this.interestedCategories = const [],
    required this.isProfileCompleted,
    this.createdAt,
  });

  // Chuyển từ Firestore Document -> Object Dart
  factory UserModel.fromSnapshot(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return UserModel(
      id: doc.id,
      email: data['email'] ?? '',
      displayName: data['display_name'],
      bio: data['bio'],
      country: data['country'],
      cookingLevel: data['cooking_level'],
      avatarUrl: data['avatar_url'],
      coverUrl: data['cover_url'],
      interestedCategories: List<String>.from(data['interested_categories'] ?? []),
      isProfileCompleted: data['is_profile_completed'] ?? false,
      createdAt: (data['created_at'] as Timestamp?)?.toDate(),
    );
  }

  // Chuyển từ Object Dart -> Map (để lưu lên Firestore)
  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'display_name': displayName,
      'bio': bio,
      'country': country,
      'cooking_level': cookingLevel,
      'avatar_url': avatarUrl,
      'cover_url': coverUrl,
      'interested_categories': interestedCategories,
      'is_profile_completed': isProfileCompleted,
    };
  }
}