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
        .collection('published_recipes')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
        .map((doc) => PublishRecipe.fromFirestore(doc))
        .toList());
  }

  Future<bool> publishToUserCollection(PublishRecipe recipe) async {
    try {
      final user = _auth.currentUser;
      if (user == null) return false;

      // Upload ảnh
      final uploadedUrls =
      await _recipeService.uploadImages(recipe.images);

      final data = recipe.toFirestore();
      data['images'] = uploadedUrls;
      data['authorId'] = user.uid;

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

  Future<bool> deletePublishedRecipe(String userId, PublishRecipe recipe) async {
    try {
      // 1. Xóa ảnh trên Cloudinary trước để tránh rác dữ liệu
      if (recipe.images.isNotEmpty) {
        await _recipeService.deleteImages(recipe.images);
      }

      // 2. Xóa document trong sub-collection của user
      await _firestore
          .collection('users')
          .doc(userId)
          .collection('published_recipes')
          .doc(recipe.id)
          .delete();

      return true;
    } catch (e) {
      print("Lỗi khi xóa bài đăng: $e");
      return false;
    }
  }

  Stream<List<PublishRecipe>> getAllRecipesRealtime() {
    return FirebaseFirestore.instance
        .collectionGroup('published_recipes')
        .snapshots()
        .map((snapshot) {
      print('🔥 SNAPSHOT SIZE = ${snapshot.docs.length}');
      for (var doc in snapshot.docs) {
        print('📄 DOC PATH = ${doc.reference.path}');
        print('📄 DATA = ${doc.data()}');
      }
      return snapshot.docs
          .map((doc) => PublishRecipe.fromFirestore(doc))
          .toList();
    });
  }

  Future<Map<String, dynamic>?> getUserInfo(String uid) async {
    final doc = await _firestore.collection('users').doc(uid).get();
    return doc.data();
  }
}