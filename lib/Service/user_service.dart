import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloudinary_public/cloudinary_public.dart'; // 1. Import thư viện mới
import 'package:fontend/Service/user_model.dart';
import '../Service/user_model.dart';

class UserService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // 2. Cấu hình Cloudinary
  final cloudinary = CloudinaryPublic('dzysold5b', 'cookinghub_preset', cache: false);

  // Lấy thông tin User (Giữ nguyên)
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

  // --- HÀM MỚI: Upload lên Cloudinary ---
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

  // 3. Cập nhật Profile (Logic đã sửa để dùng hàm upload mới)
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
}