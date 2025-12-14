import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloudinary_public/cloudinary_public.dart'; // Import thư viện Cloudinary
import 'package:fontend/Service/recipe_model.dart';

class RecipeService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Cấu hình Cloudinary (Dùng lại thông tin của bạn)
  final cloudinary = CloudinaryPublic('dzysold5b', 'cookinghub_preset', cache: false);

  // 1. Upload danh sách ảnh
  Future<List<String>> uploadImages(List<String> filePaths) async {
    List<String> urls = [];
    for (String path in filePaths) {
      // Nếu là URL sẵn (ví dụ ảnh từ mạng) thì giữ nguyên, nếu là đường dẫn file trong máy thì upload
      if (path.startsWith('http')) {
        urls.add(path);
      } else {
        try {
          CloudinaryResponse response = await cloudinary.uploadFile(
            CloudinaryFile.fromFile(path, resourceType: CloudinaryResourceType.Image),
          );
          urls.add(response.secureUrl);
        } catch (e) {
          print("Lỗi upload ảnh recipe: $e");
        }
      }
    }
    return urls;
  }

  // 2. Đăng bài viết (Publish)
  Future<bool> publishRecipe(RecipeModel recipe) async {
    try {
      await _firestore.collection('recipes').add(recipe.toJson());
      return true;
    } catch (e) {
      print("Lỗi đăng bài: $e");
      return false;
    }
  }

  // 3. Lấy công thức của User (Cho Profile)
  Stream<List<RecipeModel>> getUserRecipes(String uid) {
    return _firestore
        .collection('recipes')
        .where('authorId', isEqualTo: uid)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) =>
        snapshot.docs.map((doc) => RecipeModel.fromSnapshot(doc)).toList());
  }
}