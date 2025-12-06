import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:fontend/Service/api_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../Service/user_model.dart';
import '../screens/Signin/sign_in&sign_up/auth/storage_service.dart';

class UserService {
  final Dio _dio = Dio(BaseOptions(
    baseUrl: ApiService.baseUrl, // THAY IP CỦA BẠN VÀO ĐÂY
    connectTimeout: const Duration(seconds: 10),
  ));

  // Hàm lấy token từ bộ nhớ
  Future<String?> _getToken() async {
    // Thay vì dùng SharedPreferences, hãy dùng StorageService
    return await StorageService.getToken();
  }

  Future<bool> updateProfile({
    required String displayName,
    String? bio,
    String? country,
    String? cookingLevel,
    List<String>? categories,
    File? avatarFile,
    File? coverFile,
  }) async {
    try {
      final token = await _getToken();
      if (token == null) return false;

      Map<String, dynamic> mapData = {
        'display_name': displayName,
        'bio': bio ?? '',
        'country': country ?? '',
        'cooking_level': cookingLevel ?? '',
        'interested_categories': jsonEncode(categories ?? []),
      };

      if (avatarFile != null) {
        mapData['avatar'] = await MultipartFile.fromFile(avatarFile.path);
      }
      if (coverFile != null) {
        mapData['cover'] = await MultipartFile.fromFile(coverFile.path);
      }

      FormData formData = FormData.fromMap(mapData);

      final response = await _dio.put(
        '/users/me/profile/update',
        data: formData,
        options: Options(
          headers: {'Authorization': 'Bearer $token'},
          contentType: 'multipart/form-data',
        ),
      );

      return response.statusCode == 200;
    } catch (e) {
      print("Error update profile: $e");
      return false;
    }
  }

  // 2. Get User Profile
  Future<UserModel?> getUserProfile() async {
    try {
      final token = await _getToken();
      print("Token sent: $token"); // Log để kiểm tra

      if (token == null) return null;

      final response = await _dio.get(
        '/users/me',
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      if (response.statusCode == 200) {
        return UserModel.fromJson(response.data);
      }
      return null;
    } catch (e) {
      print("Error get profile: $e");
      return null;
    }
  }
}