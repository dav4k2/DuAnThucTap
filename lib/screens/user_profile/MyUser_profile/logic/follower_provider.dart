import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../Service/user_model.dart';

// Model helper để UI hiển thị
class Follower {
  final String id;
  final String name;
  final String avatarUrl;
  final int recipeCount;
  final bool isFollowedByMe;

  Follower({
    required this.id,
    required this.name,
    required this.avatarUrl,
    required this.recipeCount,
    this.isFollowedByMe = false,
  });
}

// Helper function để convert từ UserModel sang Follower
Future<Follower> _mapUserToFollower(UserModel user, String currentUserId) async {
  final firestore = FirebaseFirestore.instance;

  // Kiểm tra xem mình có đang follow người này không
  final followDoc = await firestore
      .collection('users')
      .doc(currentUserId)
      .collection('following')
      .doc(user.id)
      .get();

  // Đếm số công thức (nếu bạn không lưu recipe_count trên UserModel)
  final recipesSpec = await firestore
      .collection('users')
      .doc(user.id)
      .collection('published_recipes')
      .get();

  return Follower(
    id: user.id,
    name: user.displayName ?? "Người dùng CookingHub",
    avatarUrl: user.avatarUrl ?? "",
    recipeCount: recipesSpec.docs.length,
    isFollowedByMe: followDoc.exists,
  );
}

// Provider lấy danh sách Đang theo dõi (Following)
final followingListProvider = FutureProvider.family<List<Follower>, String>((ref, userId) async {
  final firestore = FirebaseFirestore.instance;
  final currentUserId = FirebaseAuth.instance.currentUser?.uid ?? "";

  final snapshot = await firestore.collection('users').doc(userId).collection('following').get();

  List<Follower> followers = [];
  for (var doc in snapshot.docs) {
    final userDoc = await firestore.collection('users').doc(doc.id).get();
    if (userDoc.exists) {
      final userModel = UserModel.fromSnapshot(userDoc);
      followers.add(await _mapUserToFollower(userModel, currentUserId));
    }
  }
  return followers;
});

// Provider lấy danh sách Người theo dõi (Followers)
final followersListProvider = FutureProvider.family<List<Follower>, String>((ref, userId) async {
  final firestore = FirebaseFirestore.instance;
  final currentUserId = FirebaseAuth.instance.currentUser?.uid ?? "";

  final snapshot = await firestore.collection('users').doc(userId).collection('followers').get();

  List<Follower> followers = [];
  for (var doc in snapshot.docs) {
    final userDoc = await firestore.collection('users').doc(doc.id).get();
    if (userDoc.exists) {
      final userModel = UserModel.fromSnapshot(userDoc);
      followers.add(await _mapUserToFollower(userModel, currentUserId));
    }
  }
  return followers;
});

final isFollowingProvider = FutureProvider.family<bool, String>((ref, targetUserId) async {
  final currentUserId = FirebaseAuth.instance.currentUser?.uid;
  if (currentUserId == null) return false;

  final doc = await FirebaseFirestore.instance
      .collection('users')
      .doc(currentUserId)
      .collection('following')
      .doc(targetUserId)
      .get();

  return doc.exists;
});