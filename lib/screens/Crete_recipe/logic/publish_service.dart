import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../notification/logic/notification_service.dart';
import 'publish_recipe.dart';
import '../../../Service/recipe_service.dart';

class PublishService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final RecipeService _recipeService = RecipeService();

  final NotificationService _notificationService = NotificationService();

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

      // 1. Upload ảnh bìa chính (Code cũ - Giữ nguyên)
      List<String> uploadedMainUrls = await _recipeService.uploadImages(recipe.images);

      // 2. --- LOGIC MỚI: Upload ảnh từng bước lên Cloudinary ---
      // Duyệt qua danh sách đường dẫn ảnh local của các bước
      List<String> uploadedStepUrls = [];

      for (String path in recipe.stepImages) {
        if (path.isEmpty) {
          // Nếu bước này không có ảnh, lưu chuỗi rỗng để giữ đúng thứ tự index
          uploadedStepUrls.add("");
        } else {
          // Nếu có ảnh, thực hiện upload
          // Lưu ý: Hàm uploadImages nhận vào List và trả về List
          List<String> result = await _recipeService.uploadImages([path]);

          if (result.isNotEmpty) {
            uploadedStepUrls.add(result.first); // Lấy URL Cloudinary trả về
          } else {
            uploadedStepUrls.add(""); // Nếu lỗi upload thì để rỗng
          }
        }
      }
      // ---------------------------------------------------------

      final data = recipe.toFirestore();

      // Cập nhật lại các trường URL đã upload vào data trước khi lưu
      data['images'] = uploadedMainUrls;       // URL ảnh bìa
      data['stepImages'] = uploadedStepUrls;   // URL ảnh các bước (MỚI)

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

      _notificationService.sendRecipeNotification(
        recipeId: recipe.id,
        recipeTitle: recipe.title,
      ).then((_) {
        print("Tiến trình gửi thông báo hoàn tất");
      });

      return true;
    } catch (e) {
      print("Lỗi Publish: $e");
      return false;
    }
  }

  Future<bool> updatePublishRecipe(PublishRecipe recipe) async {
    try{
      final user = _auth.currentUser;
      if(user == null) return false;

      List<String> finalMainImages = [];
      List<String> newMainImagesToUpload = [];

      // Duyệt qua danh sách ảnh hiện tại trong UI
      for (String img in recipe.images) {
        if(img.startsWith('http') || img.startsWith('https')){
          // Ảnh cũ đã có trên Cloudinary giữ nguyên
          finalMainImages.add(img);
        }else {
          newMainImagesToUpload.add(img);
        }
      }

      if (newMainImagesToUpload.isNotEmpty) {
        List<String> uploadedUrls = await _recipeService.uploadImages(newMainImagesToUpload);
        finalMainImages.addAll(uploadedUrls);
      }

      //Xử lý ảnh
      List<String> finalStepImages = [];

      for (String path in recipe.stepImages){
        if(path.isEmpty){
          finalStepImages.add("");
        }else if(path.startsWith('http') || path.startsWith('https')){
          finalStepImages.add(path);
        }else{
          List<String> result = await _recipeService.uploadImages([path]);
          if(result.isNotEmpty){
            finalStepImages.add(result.first);
          }else{
            finalStepImages.add("");
          }
        }
      }

      //Data update
      final data = recipe.toFirestore();

      data['images'] = finalMainImages;
      data['stepImages'] = finalStepImages;
      data['name_lowercase'] = recipe.title.toLowerCase();
      //Remove để tránh không bị ghi đè
      data.remove('createdAt');
      data['updatedAt'] = FieldValue.serverTimestamp();

      //Update
      await _firestore
            .collection('users')
            .doc(user.uid)
            .collection('published_recipes')
            .doc(recipe.id)
            .update(data);

      return true;
    } catch (e) {
      print('Lỗi update recipe: $e');
      return false;
    }
  }

  Future<bool> deletePublishedRecipe(String userId, PublishRecipe recipe) async {
    try {
      // 1. Xóa ảnh bìa trên Cloudinary
      if (recipe.images.isNotEmpty) {
        await _recipeService.deleteImages(recipe.images);
      }

      // 2. Xóa ảnh các bước trên Cloudinary (Nên thêm đoạn này để dọn rác sạch sẽ)
      // Lọc ra các url không rỗng để xóa
      final stepImagesToDelete = recipe.stepImages.where((url) => url.isNotEmpty).toList();
      if (stepImagesToDelete.isNotEmpty) {
        await _recipeService.deleteImages(stepImagesToDelete);
      }

      // 3. Xóa document trong sub-collection của user
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

    try {
      await _firestore.runTransaction((transaction) async {
        DocumentSnapshot ratingSnapshot = await transaction.get(ratingRef);
        DocumentSnapshot recipeSnapshot = await transaction.get(recipeRef);

        if (!recipeSnapshot.exists) {
          throw Exception("Công thức không tồn tại!");
        }

        Map<String, dynamic> recipeData = recipeSnapshot.data() as Map<String, dynamic>;
        double oldAverage = (recipeData['averageRating'] ?? 0.0).toDouble();
        int oldTotal = recipeData['totalRatings'] ?? 0;
        Map<String, int> ratingCount = Map<String, int>.from(recipeData['ratingCount'] ?? {
          "1": 0, "2": 0, "3": 0, "4": 0, "5": 0
        });

        double newAverage;
        int newTotal = oldTotal;

        if (ratingSnapshot.exists) {
          // Người dùng đổi đánh giá
          int previousRating = ratingSnapshot.get('score');
          ratingCount[previousRating.toString()] = (ratingCount[previousRating.toString()] ?? 1) - 1;
          ratingCount[rating.toString()] = (ratingCount[rating.toString()] ?? 0) + 1;

          newAverage = ((oldAverage * oldTotal) - previousRating + rating) / oldTotal;
        } else {
          // Người dùng đánh giá mới
          newTotal = oldTotal + 1;
          ratingCount[rating.toString()] = (ratingCount[rating.toString()] ?? 0) + 1;
          newAverage = ((oldAverage * oldTotal) + rating) / newTotal;
        }

        transaction.update(recipeRef, {
          'averageRating': newAverage,
          'totalRatings': newTotal,
          'ratingCount': ratingCount,
        });

        transaction.set(ratingRef, {
          'userId': user.uid,
          'score': rating,
          'updatedAt': FieldValue.serverTimestamp(),
        });
      });
    } catch (e) {
      print("Transaction error: $e");
      rethrow; // Đẩy lỗi ra ngoài để UI nhận diện và hiện SnackBar
    }

    await _updateChefOverallRating(authorId);
  }

  Future<void> _updateChefOverallRating(String authorId) async {
    try {
      // 1. SỬA LẠI ĐƯỜNG DẪN: Lấy công thức từ sub-collection của user
      QuerySnapshot recipeSnapshot = await _firestore
          .collection('users')
          .doc(authorId)
          .collection('published_recipes')
          .get();

      if (recipeSnapshot.docs.isEmpty) return;

      double totalRatingSum = 0.0;
      int ratedRecipeCount = 0; // Chỉ đếm những bài đã có đánh giá

      // 2. Tính tổng điểm trung bình của tất cả các công thức
      for (var doc in recipeSnapshot.docs) {
        final data = doc.data() as Map<String, dynamic>;
        // Lấy averageRating của từng công thức
        double rRating = (data['averageRating'] ?? 0.0).toDouble();

        // Chỉ tính các công thức đã có đánh giá (rating > 0)
        // Hoặc bạn có thể tính cả bài chưa đánh giá là 0 tùy logic,
        // nhưng thường chỉ tính trên bài đã có người chấm.
        if (rRating > 0) {
          totalRatingSum += rRating;
          ratedRecipeCount++;
        }
      }

      // 3. Tính điểm trung bình mới cho Chef
      // Nếu chưa có bài nào được đánh giá thì điểm chef vẫn là 0 hoặc giữ nguyên
      double newChefRating = ratedRecipeCount > 0
          ? totalRatingSum / ratedRecipeCount
          : 0.0;

      // 4. Cập nhật vào User Document
      // Lưu ý: Trường này nằm ở collection 'users' -> doc(authorId)
      await _firestore.collection('users').doc(authorId).update({
        'average_rating': newChefRating,
        'total_recipes': recipeSnapshot.docs.length,
      });

      print("✅ Đã cập nhật điểm Chef: $newChefRating (trên $ratedRecipeCount bài có đánh giá)");

    } catch (e) {
      print("❌ Lỗi khi cập nhật điểm Chef: $e");
    }
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

  Stream<List<PublishRecipe>> getRecipesByTags(List<String> tags) {
    if (tags.isEmpty) {
      // Nếu không có tag nào, trả về các công thức được đề xuất chung
      return getRecommendedRecipes();
    }

    return _firestore
        .collectionGroup('published_recipes')
    // Lọc các công thức có chứa ít nhất một trong các tag người dùng chọn
        .where('tags', arrayContainsAny: tags)
        .limit(10) // Giới hạn số lượng hiển thị
        .snapshots()
        .map((snapshot) => snapshot.docs
        .map((doc) => PublishRecipe.fromFirestore(doc))
        .toList());
  }
}