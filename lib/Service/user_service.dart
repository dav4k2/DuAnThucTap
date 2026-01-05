import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloudinary_public/cloudinary_public.dart'; // 1. Import thư viện mới
import 'package:fontend/Service/recipe_model.dart';
import 'package:fontend/Service/user_model.dart';
import '../Service/user_model.dart';
import '../screens/Crete_recipe/logic/publish_recipe.dart';
import '../screens/user_profile/MyUser_profile/logic/my_profile_provider.dart';

class UserService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  final cloudinary = CloudinaryPublic('dzysold5b', 'cookinghub_preset', cache: false);

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

      // c. Gom dữ liệu (Giữ nguyên logic cũ)
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

  Future<List<UserModel>> getPopularChefsByRatings({int limit = 5}) async {
    try {
      // 1. Lấy tất cả công thức từ tất cả người dùng có averageRating >= 4.0
      // Lưu ý: Cần tạo Index cho averageRating trong Firebase Console nếu chưa có
      QuerySnapshot recipeSnapshot = await _firestore
          .collectionGroup('published_recipes')
          .where('averageRating', isGreaterThanOrEqualTo: 4.0)
          .get();

      // 2. Thống kê số lượng công thức đạt chuẩn của mỗi Author
      Map<String, int> authorCount = {};
      for (var doc in recipeSnapshot.docs) {
        final data = doc.data() as Map<String, dynamic>;
        final authorId = data['authorId'] as String?;

        if (authorId != null) {
          authorCount[authorId] = (authorCount[authorId] ?? 0) + 1;
        }
      }

      // 3. Sắp xếp AuthorId theo số lượng công thức giảm dần
      var sortedAuthorIds = authorCount.keys.toList()
        ..sort((a, b) => authorCount[b]!.compareTo(authorCount[a]!));

      // 4. Lấy thông tin chi tiết UserModel từ danh sách AuthorId
      List<UserModel> popularChefs = [];
      final topIds = sortedAuthorIds.take(limit).toList();

      for (String uid in topIds) {
        DocumentSnapshot userDoc = await _firestore.collection('users').doc(uid).get();
        if (userDoc.exists) {
          popularChefs.add(UserModel.fromSnapshot(userDoc));
        }
      }

      return popularChefs;
    } catch (e) {
      print("Lỗi khi lấy người dùng phổ biến: $e");
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
}