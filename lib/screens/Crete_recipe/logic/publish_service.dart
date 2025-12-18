import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'publish_recipe.dart';
import '../../../Service/recipe_service.dart';

class PublishService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final RecipeService _recipeService = RecipeService();

  Stream<List<PublishRecipe>> getRecipesByUser(String userId) {
    return _firestore
        .collection('users')
        .doc(userId)
        .collection('published_recipes') // Sub-collection bạn muốn dùng
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
        .map((doc) => PublishRecipe.fromJson(doc.data()))
        .toList());
  }

  Future<bool> publishToUserCollection(PublishRecipe recipe) async {
    try {
      final user = _auth.currentUser;
      if (user == null) return false;

      // 1. Upload ảnh lên Cloudinary (Dùng RecipeService có sẵn)
      List<String> uploadedUrls = await _recipeService.uploadImages(recipe.images);

      // 2. Chuyển sang Map và bổ sung thông tin hệ thống
      final data = recipe.toJson();
      data['images'] = uploadedUrls;
      data['authorId'] = user.uid; // Đảm bảo ID chính xác
      data['createdAt'] = FieldValue.serverTimestamp(); // Thời gian thực từ server
      data['name_lowercase'] = recipe.title.toLowerCase(); // Phục vụ search

      // 3. Lưu vào sub-collection của user: users/{uid}/published_recipes
      await _firestore
          .collection('users')
          .doc(user.uid)
          .collection('published_recipes')
          .doc(recipe.id)
          .set(data);

      return true;
    } catch (e) {
      print("Lỗi Publish: $e");
      return false;
    }
  }
}