import 'dart:convert';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloudinary_public/cloudinary_public.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:fontend/Service/recipe_model.dart';
import 'package:http/http.dart' as http;
import 'package:crypto/crypto.dart';

class RecipeService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final CollectionReference recipeRef = FirebaseFirestore.instance.collection('recipes');

  // Cấu hình Cloudinary
  CloudinaryPublic? _cloudinary;
  String? _cloudName;
  String? _uploadPreset;
  String? _apiKey;
  String? _apiSecret;

  Future<void> _initConfig() async {
    // Nếu đã có dữ liệu rồi thì không cần fetch lại để tiết kiệm
    if (_cloudinary != null && _apiSecret != null) return;

    final remoteConfig = FirebaseRemoteConfig.instance;

    try {
      // Cấu hình tần suất fetch
      await remoteConfig.setConfigSettings(RemoteConfigSettings(
        fetchTimeout: const Duration(minutes: 1),
        minimumFetchInterval: const Duration(hours: 1),
      ));

      // Lấy giá trị về và kích hoạt
      await remoteConfig.fetchAndActivate();

      // Gán giá trị từ trên mạng vào biến local
      _cloudName = remoteConfig.getString('cloudinary_cloud_name');
      _uploadPreset = remoteConfig.getString('cloudinary_upload_preset');
      _apiKey = remoteConfig.getString('cloudinary_api_key');
      _apiSecret = remoteConfig.getString('cloudinary_api_secret');

      // Khởi tạo đối tượng CloudinaryPublic
      if (_cloudName!.isNotEmpty && _uploadPreset!.isNotEmpty) {
        _cloudinary = CloudinaryPublic(_cloudName!, _uploadPreset!, cache: false);
      }

    } catch (e) {
      print("Lỗi lấy Remote Config: $e");
      // Fallback: Nếu mất mạng hoặc lỗi, có thể dùng tạm key hardcode (Tùy chọn)
      // _cloudName = 'dzysold5b'; ...
    }
  }

  // 1. Upload ảnh lên cloudinary (Giữ nguyên logic cũ)
  Future<List<String>> uploadImages(List<String> filePaths) async {
    // Gọi hàm init trước khi làm bất cứ gì
    await _initConfig();

    // Kiểm tra nếu init thất bại
    if (_cloudinary == null) {
      print("Chưa cấu hình được Cloudinary");
      return [];
    }

    List<String> urls = [];
    for (String path in filePaths) {
      if (path.isEmpty) continue;

      if (path.startsWith('http')) {
        urls.add(path);
      } else {
        try {
          // Dùng _cloudinary đã được init từ Remote Config
          CloudinaryResponse response = await _cloudinary!.uploadFile(
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

  // 2. [MỚI] Upload Video lên Cloudinary
  Future<String?> uploadVideo(String videoPath) async {
    await _initConfig(); // Đảm bảo đã có config

    if (videoPath.startsWith('http')) return videoPath;
    if (_cloudName == null || _uploadPreset == null) return null;

    File file = File(videoPath);
    if (!file.existsSync()) return null;

    try {
      // Dùng biến _cloudName lấy từ Remote Config
      var uri = Uri.parse("https://api.cloudinary.com/v1_1/$_cloudName/video/upload");
      var request = http.MultipartRequest("POST", uri);

      var multipartFile = await http.MultipartFile.fromPath('file', file.path);
      request.files.add(multipartFile);

      // Dùng biến _uploadPreset lấy từ Remote Config
      request.fields['upload_preset'] = _uploadPreset!;
      request.fields['resource_type'] = 'video';

      var response = await request.send();

      if (response.statusCode == 200) {
        var responseData = await response.stream.toBytes();
        var responseString = String.fromCharCodes(responseData);
        var jsonMap = jsonDecode(responseString);
        return jsonMap['secure_url'];
      } else {
        print("Upload video thất bại: ${response.statusCode}");
        return null;
      }
    } catch (e) {
      print("Lỗi upload video: $e");
      return null;
    }
  }

  // 3. Đăng bài (Đã tích hợp upload Video)
  Future<bool> publishRecipe(RecipeModel recipe) async {
    try {
      final user = _auth.currentUser;
      if (user == null) return false;

      // 3.1. Upload Video nếu có (Logic mới)
      String? finalVideoUrl;
      if (recipe.video != null && recipe.video!.isNotEmpty) {
        finalVideoUrl = await uploadVideo(recipe.video!);
      }

      // 3.2. Chuyển model sang Map và cập nhật dữ liệu
      final data = recipe.toJson();

      // Cập nhật các trường quan trọng
      data['authorId'] = user.uid;
      data['createdAt'] = FieldValue.serverTimestamp();

      // Ghi đè URL video (nếu đã upload thành công hoặc giữ nguyên null)
      data['video'] = finalVideoUrl;

      // Tạo keyword tìm kiếm
      if (recipe.title.isNotEmpty) {
        data['name_lowercase'] = recipe.title.toLowerCase();
      }

      await _firestore.collection('recipes').add(data);
      return true;
    } catch (e) {
      print("Lỗi đăng bài: $e");
      return false;
    }
  }

  // 4. Lấy danh sách bài viết
  Stream<List<RecipeModel>> getUserRecipes(String uid) {
    return _firestore
        .collection('recipes')
        .where('authorId', isEqualTo: uid)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) =>
        snapshot.docs.map((doc) => RecipeModel.fromSnapshot(doc)).toList());
  }

  // Hàm helper lấy Public ID từ URL (Dùng chung cho cả ảnh và video)
  String? _getPublicIdFromUrl(String url) {
    try {
      final uri = Uri.parse(url);
      final pathSegments = uri.pathSegments;
      final uploadIndex = pathSegments.indexOf('upload');
      if (uploadIndex == -1 || uploadIndex + 2 >= pathSegments.length) return null;

      List<String> publicIdSegments = [];
      int startIndex = uploadIndex + 1;

      // Bỏ qua version (v12345)
      if (RegExp(r'^v\d+$').hasMatch(pathSegments[startIndex])) {
        startIndex++;
      }

      publicIdSegments = pathSegments.sublist(startIndex);
      String publicIdWithExtension = publicIdSegments.join('/');

      // Xóa đuôi file (.jpg, .mp4...)
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

  // 5. Xóa danh sách ảnh
  Future<void> deleteImages(List<String> imageUrls) async {
    for (String url in imageUrls) {
      if (!url.startsWith('http')) continue;
      final publicId = _getPublicIdFromUrl(url);
      if (publicId == null) continue;

      await _deleteResourceOnCloudinary(publicId, 'image');
    }
  }

  // 6. [MỚI] Xóa Video
  Future<void> deleteVideo(String? videoUrl) async {
    if (videoUrl == null || !videoUrl.startsWith('http')) return;

    final publicId = _getPublicIdFromUrl(videoUrl);
    if (publicId == null) return;

    await _deleteResourceOnCloudinary(publicId, 'video');
  }

  // Hàm private để gọi API xóa (Dùng chung để tránh lặp code)
  Future<void> _deleteResourceOnCloudinary(String publicId, String resourceType) async {
    await _initConfig(); // Lấy key

    if (_cloudName == null || _apiKey == null || _apiSecret == null) return;

    try {
      final int timestamp = DateTime.now().millisecondsSinceEpoch ~/ 1000;

      // Dùng _apiSecret lấy từ Remote Config
      final String paramsToSign = 'public_id=$publicId&timestamp=$timestamp';
      final bytes = utf8.encode('$paramsToSign$_apiSecret');
      final digest = sha1.convert(bytes);
      final signature = digest.toString();

      final response = await http.post(
        Uri.parse('https://api.cloudinary.com/v1_1/$_cloudName/$resourceType/destroy'),
        body: {
          'public_id': publicId,
          'timestamp': timestamp.toString(),
          'api_key': _apiKey, // Dùng key động
          'signature': signature,
        },
      );
      // ... (Phần còn lại giữ nguyên)
    } catch (e) {
      print("Exception xóa $resourceType: $e");
    }
  }

  // 7. Xóa hoàn toàn bài đăng (Cập nhật xóa cả video)
  Future<bool> deleteRecipe(String recipeId, RecipeModel recipe) async {
    try {
      // 7.1. Xóa ảnh
      if (recipe.images.isNotEmpty) {
        await deleteImages(recipe.images);
      }

      // 7.2. [MỚI] Xóa Video
      if (recipe.video != null && recipe.video!.isNotEmpty) {
        await deleteVideo(recipe.video);
      }

      // 7.3. Xóa document trong Firestore
      await _firestore.collection('recipes').doc(recipeId).delete();
      return true;
    } catch (e) {
      print("Lỗi xóa bài đăng: $e");
      return false;
    }
  }
}