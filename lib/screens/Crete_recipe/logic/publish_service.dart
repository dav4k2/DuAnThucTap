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

      // Lấy thông tin người dùng hiện tại
      final userDoc = await getUserInfo(user.uid);
      final authorName = userDoc?['display_name'] ?? 'Người dùng';

      List<String> uploadedUrls = await _recipeService.uploadImages(recipe.images);

      final data = recipe.toFirestore();
      data['images'] = uploadedUrls;
      data['authorId'] = user.uid;
      data['authorName'] = authorName;
      data['createdAt'] = FieldValue.serverTimestamp();
      data['name_lowercase'] = recipe.title.toLowerCase();

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

  Stream<List<PublishRecipe>> searchRecipes(String query) {
    final lowercaseQuery = query.toLowerCase();

    return _firestore
        .collectionGroup('published_recipes')
        .snapshots()
        .asyncMap((snapshot) async {
      List<PublishRecipe> results = [];

      for (var doc in snapshot.docs) {
        final data = doc.data();
        final recipe = PublishRecipe.fromFirestore(doc);

        // 1. Kiểm tra theo tên công thức (đã có lowercase trong DB)
        bool matchTitle = recipe.title.toLowerCase().contains(lowercaseQuery);

        // 2. Kiểm tra theo tên tác giả (Cần lấy thông tin User)
        bool matchAuthor = false;
        if (recipe.authorId != null) {
          final authorInfo = await getUserInfo(recipe.authorId!);
          final authorName = authorInfo?['display_name']?.toString().toLowerCase() ?? '';
          if (authorName.contains(lowercaseQuery)) {
            matchAuthor = true;
          }
        }

        if (matchTitle || matchAuthor) {
          results.add(recipe);
        }
      }
      return results;
    });
  }

  Future<int> getRecipeCount(String userId) async {
    try {
      final snapshot = await _firestore
          .collectionGroup('published_recipes')
          .where('authorId', isEqualTo: userId)
          .count()
          .get();
      return snapshot.count ?? 0;
    } catch (e) {
      return 0;
    }
  }

  Future<void> toggleFollow(String targetUserId) async {
    final currentUser = _auth.currentUser;
    if (currentUser == null) return;

    final userRef = _firestore.collection('users').doc(currentUser.uid);
    final doc = await userRef.get();

    // Lấy danh sách đang theo dõi hiện tại
    final List<String> following = List<String>.from(doc.data()?['following'] ?? []);

    if (following.contains(targetUserId)) {
      await userRef.update({'following': FieldValue.arrayRemove([targetUserId])});
    } else {
      await userRef.update({'following': FieldValue.arrayUnion([targetUserId])});
    }
  }

  Stream<bool> isFollowingStream(String targetUserId) {
    final currentUser = _auth.currentUser;
    if (currentUser == null) return Stream.value(false);

    return _firestore.collection('users').doc(currentUser.uid).snapshots().map((snapshot) {
      final List<String> following = List<String>.from(snapshot.data()?['following'] ?? []);
      return following.contains(targetUserId);
    });
  }

  //Hàm đánh giá
  Future<void> submitRating(String authorId, String recipeId, int rating) async {
    final user = _auth.currentUser;
    if (user == null) return;

    // Đường dẫn tới tài liệu đánh giá của người dùng hiện tại trong món ăn này
    final ratingRef = _firestore
        .collection('users')
        .doc(authorId)
        .collection('published_recipes')
        .doc(recipeId)
        .collection('ratings')
        .doc(user.uid);

    final recipeRef = _firestore
        .collection('users')
        .doc(authorId)
        .collection('published_recipes')
        .doc(recipeId);

    await _firestore.runTransaction((transaction) async {
      DocumentSnapshot ratingSnapshot = await transaction.get(ratingRef);
      DocumentSnapshot recipeSnapshot = await transaction.get(recipeRef);

      if (!recipeSnapshot.exists) return;

      Map<String, dynamic> recipeData = recipeSnapshot.data() as Map<String, dynamic>;
      double oldAverage = (recipeData['averageRating'] ?? 0.0).toDouble();
      int oldTotal = recipeData['totalRatings'] ?? 0;

      if (ratingSnapshot.exists) {
        // TRƯỜNG HỢP: Đã đánh giá trước đó -> Cập nhật lại điểm trung bình (thay thế điểm cũ)
        int previousRating = ratingSnapshot.get('score');

        // Công thức cập nhật: (Tổng điểm cũ - Điểm cũ + Điểm mới) / Tổng lượt đánh giá
        double newAverage = ((oldAverage * oldTotal) - previousRating + rating) / oldTotal;

        transaction.update(recipeRef, {'averageRating': newAverage});
        transaction.update(ratingRef, {
          'score': rating,
          'updatedAt': FieldValue.serverTimestamp(),
        });
      } else {
        // TRƯỜNG HỢP: Đánh giá lần đầu -> Thêm mới và tăng tổng lượt đánh giá
        int newTotal = oldTotal + 1;
        double newAverage = ((oldAverage * oldTotal) + rating) / newTotal;

        transaction.update(recipeRef, {
          'averageRating': newAverage,
          'totalRatings': newTotal,
        });
        transaction.set(ratingRef, {
          'userId': user.uid,
          'score': rating,
          'createdAt': FieldValue.serverTimestamp(),
        });
      }
    });
  }

  Stream<List<PublishRecipe>> getRecommendedRecipes() {
    return _firestore
        .collectionGroup('published_recipes')
        .where('averageRating', isGreaterThanOrEqualTo: 4.0)
        .orderBy('averageRating', descending: true)
        .limit(10)
        .snapshots()
        .map((snapshot) => snapshot.docs
        .map((doc) => PublishRecipe.fromFirestore(doc))
        .toList());
  }

  // Hàm để lấy điểm mà người dùng hiện tại đã đánh giá cho món ăn này
  Future<int> getUserRatingForRecipe(String authorId, String recipeId) async {
    final user = _auth.currentUser;
    if (user == null) return 0;

    final doc = await _firestore
        .collection('users')
        .doc(authorId)
        .collection('published_recipes')
        .doc(recipeId)
        .collection('ratings')
        .doc(user.uid)
        .get();

    return doc.exists ? (doc.data()?['score'] ?? 0) : 0;
  }
}