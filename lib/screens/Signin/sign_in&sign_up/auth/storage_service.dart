// File: lib/services/storage_service.dart
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class StorageService {
  // Tạo instance của FlutterSecureStorage
  static const _storage = FlutterSecureStorage();

  static const _tokenKey = 'access_token';

  // 1. Lưu Token
  static Future<void> saveToken(String token) async {
    await _storage.write(key: _tokenKey, value: token);
  }

  // 2. Đọc Token (dùng khi App khởi động)
  static Future<String?> getToken() async {
    return await _storage.read(key: _tokenKey);
  }

  // 3. Xóa Token (dùng khi Đăng xuất)
  static Future<void> deleteToken() async {
    await _storage.delete(key: _tokenKey);
  }
}