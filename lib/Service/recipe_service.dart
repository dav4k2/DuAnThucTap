import 'dart:convert';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloudinary_public/cloudinary_public.dart';
import 'package:fontend/Service/recipe_model.dart';
import 'package:http/http.dart' as http;
import 'package:crypto/crypto.dart';

class RecipeService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final CollectionReference recipeRef = FirebaseFirestore.instance.collection('recipes');

  //Cấu hình Cloudinary
  final cloudinary = CloudinaryPublic('dzysold5b', 'cookinghub_preset', cache: false);
  final String cloudName = 'dzysold5b';
  final String apiKey = '259311985559455';
  final String apiSecret = '74tXcTNDC8W9h1GpWCFJ-w0Kj7o';

  //Upload ảnh lên cloudinary
  Future<List<String>> uploadImages(List<String> filePaths) async {
    List<String> urls = [];
    for (String path in filePaths) {
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

  // Đăng bài
  Future<bool> publishRecipe(RecipeModel recipe) async {
    try {
      final user = _auth.currentUser;
      if (user == null) return false;

      // Chuyển model sang Map
      final data = recipe.toJson();

      // CẬP NHẬT QUAN TRỌNG: Ghi đè các trường hệ thống để đảm bảo chính xác
      data['authorId'] = user.uid; // Luôn lấy ID người đang đăng nhập
      data['createdAt'] = FieldValue.serverTimestamp(); // Thời gian thực từ server

      // Tạo keyword tìm kiếm (Search Logic)
      if (recipe.title != null) {
        data['name_lowercase'] = recipe.title!.toLowerCase();
      }

      await _firestore.collection('recipes').add(data);
      return true;
    } catch (e) {
      print("Lỗi đăng bài: $e");
      return false;
    }
  }

  // 3. Lấy danh sách bài viết của 1 user cụ thể (Stream Real-time)
  Stream<List<RecipeModel>> getUserRecipes(String uid) {
    return _firestore
        .collection('recipes')
        .where('authorId', isEqualTo: uid)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) =>
        snapshot.docs.map((doc) => RecipeModel.fromSnapshot(doc)).toList());
  }

  // Hàm phụ trợ nếu bạn dùng cách add thủ công (đã tích hợp logic tìm kiếm)
  Future<void> addRecipeManual({
    required String name,
    required String imageUrl,
  }) async {
    final user = _auth.currentUser;
    if (user == null) return;

    try {
      await recipeRef.add({
        'name': name,
        'image': imageUrl,
        'authorId': user.uid, // Gắn ID người dùng
        'createdAt': FieldValue.serverTimestamp(),
        'name_lowercase': name.toLowerCase(),
      });
    } catch (e) {
      print("Lỗi đăng bài thủ công: $e");
      rethrow;
    }
  }

  String? _getPublicIdFromUrl(String url) {
    try {
      // URL mẫu: https://res.cloudinary.com/dzysold5b/image/upload/v12345/cookinghub_preset/abc.jpg
      final uri = Uri.parse(url);
      final pathSegments = uri.pathSegments;

      final uploadIndex = pathSegments.indexOf('upload');
      if (uploadIndex == -1 || uploadIndex + 2 >= pathSegments.length) return null;

      // Logic: Bỏ qua version (v12345) nếu có, lấy phần sau đó
      List<String> publicIdSegments = [];
      int startIndex = uploadIndex + 1;

      // Kiểm tra nếu segment là version (bắt đầu bằng v và theo sau là số)
      if (RegExp(r'^v\d+$').hasMatch(pathSegments[startIndex])) {
        startIndex++;
      }

      publicIdSegments = pathSegments.sublist(startIndex);
      String publicIdWithExtension = publicIdSegments.join('/');

      // Xóa đuôi file (.jpg, .png...)
      final lastDotIndex = publicIdWithExtension.lastIndexOf('.');
      if (lastDotIndex != -1) {
        return publicIdWithExtension.substring(0, lastDotIndex);
      }
      return publicIdWithExtension;
    } catch (e) {
      print("Lỗi parse URL Cloudinary: $e");
      return null;
    }
  }

  /// Hàm xóa danh sách ảnh trên Cloudinary
  Future<void> deleteImages(List<String> imageUrls) async {
    for (String url in imageUrls) {
      if (!url.startsWith('http')) continue; // Bỏ qua ảnh local

      final publicId = _getPublicIdFromUrl(url);
      if (publicId == null) continue;

      try {
        final int timestamp = DateTime.now().millisecondsSinceEpoch ~/ 1000;

        // Tạo chữ ký bảo mật (Signature)
        final String paramsToSign = 'public_id=$publicId&timestamp=$timestamp';
        final bytes = utf8.encode('$paramsToSign$apiSecret');
        final digest = sha1.convert(bytes);
        final signature = digest.toString();

        // Gửi request xóa
        final response = await http.post(
          Uri.parse('https://api.cloudinary.com/v1_1/$cloudName/image/destroy'),
          body: {
            'public_id': publicId,
            'timestamp': timestamp.toString(),
            'api_key': apiKey,
            'signature': signature,
          },
        );

        if (response.statusCode == 200) {
          print("Đã xóa ảnh Cloudinary: $publicId");
        } else {
          print("Lỗi xóa ảnh Cloudinary: ${response.body}");
        }
      } catch (e) {
        print("Exception xóa ảnh: $e");
      }
    }
  }

  /// Hàm xóa hoàn toàn bài đăng (Xóa ảnh trên mây + Xóa data trong Firestore)
  Future<bool> deleteRecipe(String recipeId, List<String> imageUrls) async {
    try {
      // 1. Xóa ảnh trước
      if (imageUrls.isNotEmpty) {
        await deleteImages(imageUrls);
      }

      // 2. Xóa document
      await _firestore.collection('recipes').doc(recipeId).delete();
      return true;
    } catch (e) {
      print("Lỗi xóa bài đăng: $e");
      return false;
    }
  }
}