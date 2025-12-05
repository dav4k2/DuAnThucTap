class UserModel {
  final int id;
  final String email;
  final String? displayName;
  final String? bio;
  final String? country;
  final String? cookingLevel;
  final String? avatarUrl;
  final String? coverUrl;
  final List<String> interestedCategories;

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
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      email: json['email'],
      displayName: json['display_name'],
      bio: json['bio'],
      country: json['country'],
      cookingLevel: json['cooking_level'],
      avatarUrl: json['avatar_url'],
      coverUrl: json['cover_url'],
      interestedCategories: json['interested_categories'] != null
          ? List<String>.from(json['interested_categories'])
          : [],
    );
  }
}