// lib/screens/user_profile/MyUser_profile/logic/follower_provider.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../Service/user_model.dart';

// --- MODELS ---
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

// --- CORE PROVIDERS ---

// 1. Kiểm tra trạng thái: User hiện tại (A) có đang follow Target User (B) không?
final isFollowingProvider = FutureProvider.family<bool, String>((ref, targetUserId) async {
  final currentUserId = FirebaseAuth.instance.currentUser?.uid;
  if (currentUserId == null || targetUserId.isEmpty) return false;

  // Tiết kiệm chi phí đọc: Chỉ kiểm tra document tồn tại hay không
  final doc = await FirebaseFirestore.instance
      .collection('users')
      .doc(currentUserId)
      .collection('following')
      .doc(targetUserId)
      .get();

  return doc.exists;
});

// 2. Lấy danh sách (và số lượng) người đang theo dõi (Followers) của một UserID
final followersListProvider = FutureProvider.family<List<Follower>, String>((ref, userId) async {
  if (userId.isEmpty) return [];
  final firestore = FirebaseFirestore.instance;
  final currentUserId = FirebaseAuth.instance.currentUser?.uid ?? "";

  final snapshot = await firestore.collection('users').doc(userId).collection('followers').get();

  List<Follower> followers = [];
  for (var doc in snapshot.docs) {
    // Lấy thông tin chi tiết từng người follow
    final userDoc = await firestore.collection('users').doc(doc.id).get();
    if (userDoc.exists) {
      final userModel = UserModel.fromSnapshot(userDoc);

      // Kiểm tra xem User A có follow ngược lại người này không (để hiện nút trong list)
      final isFollowedBack = await firestore
          .collection('users')
          .doc(currentUserId)
          .collection('following')
          .doc(userModel.id)
          .get();

      followers.add(Follower(
        id: userModel.id,
        name: userModel.displayName ?? "Người dùng",
        avatarUrl: userModel.avatarUrl ?? "",
        recipeCount: 0, // Có thể update logic đếm recipe sau
        isFollowedByMe: isFollowedBack.exists,
      ));
    }
  }
  return followers;
});

// 3. Lấy danh sách (và số lượng) đang theo dõi (Following) của một UserID
final followingListProvider = FutureProvider.family<List<Follower>, String>((ref, userId) async {
  if (userId.isEmpty) return [];
  final firestore = FirebaseFirestore.instance;
  final currentUserId = FirebaseAuth.instance.currentUser?.uid ?? "";

  final snapshot = await firestore.collection('users').doc(userId).collection('following').get();

  List<Follower> list = [];
  for (var doc in snapshot.docs) {
    final userDoc = await firestore.collection('users').doc(doc.id).get();
    if (userDoc.exists) {
      final userModel = UserModel.fromSnapshot(userDoc);

      // Check trạng thái follow
      final isStillFollowing = await firestore
          .collection('users')
          .doc(currentUserId)
          .collection('following')
          .doc(userModel.id)
          .get();

      list.add(Follower(
        id: userModel.id,
        name: userModel.displayName ?? "Người dùng",
        avatarUrl: userModel.avatarUrl ?? "",
        recipeCount: 0,
        isFollowedByMe: isStillFollowing.exists,
      ));
    }
  }
  return list;
});