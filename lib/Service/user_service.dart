import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloudinary_public/cloudinary_public.dart'; // 1. Import thư viện mới
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:fontend/Service/recipe_model.dart';
import 'package:fontend/Service/user_model.dart';
import '../Service/user_model.dart';
import '../screens/Crete_recipe/logic/publish_recipe.dart';
import '../screens/user_profile/MyUser_profile/logic/my_profile_provider.dart';

class UserService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<UserModel?> getUserProfile() async {
    User? user = _auth.currentUser;
    if (user != null) {
      DocumentSnapshot doc = await _firestore.collection('users').doc(user.uid).get();
      if (doc.exists) {
        return UserModel.fromSnapshot(doc);
      }
    }
    return null;
  }

  Future<String?> _uploadToCloudinary(File file) async {
    try {
      final remoteConfig = FirebaseRemoteConfig.instance;

      await remoteConfig.setConfigSettings(RemoteConfigSettings(
        fetchTimeout: const Duration(minutes: 1),
        minimumFetchInterval: const Duration(hours: 1), // Chỉnh thấp xuống khi debug
      ));
      await remoteConfig.fetchAndActivate();

      // Lấy giá trị từ Remote Config
      final String cloudName = remoteConfig.getString('cloudinary_cloud_name');
      final String uploadPreset = remoteConfig.getString('cloudinary_upload_preset');

      if (cloudName.isEmpty || uploadPreset.isEmpty) {
        print("Lỗi: Không tìm thấy cấu hình Cloudinary trên Remote Config");
        return null;
      }

      // Khởi tạo Cloudinary instance với key động
      final cloudinary = CloudinaryPublic(cloudName, uploadPreset, cache: false);

      CloudinaryResponse response = await cloudinary.uploadFile(
        CloudinaryFile.fromFile(file.path, resourceType: CloudinaryResourceType.Image),
      );
      return response.secureUrl;
    } catch (e) {
      print("Lỗi upload Cloudinary: $e");
      return null;
    }
  }

  Future<bool> updateUserProfile({
    required String displayName,
    String? bio,
    String? country,
    String? cookingLevel,
    List<String>? categories,
    File? avatarFile,
    File? coverFile,
  }) async {
    User? user = _auth.currentUser;
    if (user == null) return false;

    try {
      String? avatarUrl;
      String? coverUrl;

      // a. Upload Avatar lên Cloudinary (nếu có)
      if (avatarFile != null) {
        avatarUrl = await _uploadToCloudinary(avatarFile);
      }

      // b. Upload Cover lên Cloudinary (nếu có)
      if (coverFile != null) {
        coverUrl = await _uploadToCloudinary(coverFile);
      }

      // c. Gom dữ liệu
      Map<String, dynamic> data = {
        'display_name': displayName,
        'bio': bio,
        'country': country,
        'cooking_level': cookingLevel,
        'interested_categories': categories,
        'is_profile_completed': true,
        'updated_at': FieldValue.serverTimestamp(),
      };

      if (avatarUrl != null) data['avatar_url'] = avatarUrl;
      if (coverUrl != null) data['cover_url'] = coverUrl;

      // d. Update vào Firestore
      await _firestore.collection('users').doc(user.uid).set(data, SetOptions(merge: true));

      return true;
    } catch (e) {
      print("Lỗi update profile: $e");
      return false;
    }
  }

  Future<List<UserModel>> getPopularChefsByRatings() async {
    try {
      final snapshot = await _firestore
          .collection('users')
          .where('average_rating', isGreaterThan: 3.0) // Chỉ lấy trên 3 sao
          .orderBy('average_rating', descending: true) // Sắp xếp điểm cao nhất lên đầu
          .limit(10) // Lấy top 10
          .get();

      // Map từ DocumentSnapshot sang UserModel dùng hàm fromSnapshot bạn đã viết
      return snapshot.docs.map((doc) => UserModel.fromSnapshot(doc)).toList();
    } catch (e) {
      print("Lỗi lấy Popular Chefs: $e");
      return [];
    }
  }

  Future<UserModel?> getUserById(String uid) async {
    try {
      DocumentSnapshot doc = await _firestore.collection('users').doc(uid).get();
      if (doc.exists) {
        return UserModel.fromSnapshot(doc);
      }
    } catch (e) {
      print("Lỗi khi lấy thông tin user theo ID: $e");
    }
    return null;
  }

  Future<List<PublishRecipe>> getRecipesByUserId(String uid) async {
    try {
      QuerySnapshot snapshot = await _firestore
          .collection('users')
          .doc(uid)
          .collection('published_recipes')
          .orderBy('createdAt', descending: true)
          .get();

      // Chuyển đổi từ QueryDocumentSnapshot sang PublishRecipe
      return snapshot.docs.map((doc) =>
          PublishRecipe.fromFirestore(doc as DocumentSnapshot<Map<String, dynamic>>)
      ).toList();
    } catch (e) {
      print("Lỗi lấy công thức: $e");
      return [];
    }
  }

// Hàm chuyển đổi String từ DB sang Enum MealTab trong chef_provider
  MealTab _mapCategoryToMeal(String? category) {
    switch (category) {
      case 'Bữa sáng': return MealTab.buaSang;
      case 'Bữa trưa': return MealTab.buaTrua;
      case 'Ăn vặt': return MealTab.anVat;
      default: return MealTab.tatCa;
    }
  }

  Future<void> toggleFollowUser({required String targetUserId}) async {
    final currentUserId = _auth.currentUser?.uid;
    if (currentUserId == null) return;

    final currentUserRef = _firestore.collection('users').doc(currentUserId);
    final targetUserRef = _firestore.collection('users').doc(targetUserId);

    // 1. Kiểm tra trạng thái hiện tại
    final doc = await currentUserRef.collection('following').doc(targetUserId).get();
    final isFollowing = doc.exists;

    WriteBatch batch = _firestore.batch();

    if (isFollowing) {
      // --- LÓGIC UNFOLLOW ---
      batch.delete(currentUserRef.collection('following').doc(targetUserId));
      batch.delete(targetUserRef.collection('followers').doc(currentUserId));

      batch.update(currentUserRef, {'following_count': FieldValue.increment(-1)});
      batch.update(targetUserRef, {'follower_count': FieldValue.increment(-1)});
    } else {
      // --- LOGIC FOLLOW ---
      batch.set(currentUserRef.collection('following').doc(targetUserId), {
        'followedAt': FieldValue.serverTimestamp(),
      });
      batch.set(targetUserRef.collection('followers').doc(currentUserId), {
        'followedAt': FieldValue.serverTimestamp(),
      });

      batch.update(currentUserRef, {'following_count': FieldValue.increment(1)});
      batch.update(targetUserRef, {'follower_count': FieldValue.increment(1)});
    }

    await batch.commit();
  }
}