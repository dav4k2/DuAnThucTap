import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;

const String _baseUrl = "http://10.0.2.2:8000/api/auth";

class AuthResponse {
  final bool success;
  final String? token;
  final Map<String, dynamic>? userJson; // Hoặc User user;
  final String? message;

  AuthResponse({
    this.success = false,
    this.token,
    this.userJson,
    this.message,
  });
}

class AuthServices {
  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;

  static Future<Map<String, dynamic>> signUp(
      String email, String password, String username) async {
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/register'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': email,
          'username': username,
          'password': password,
        }),
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        // Đăng ký thành công
        return data; // Trả về JSON user (ví dụ: {"id": 1, "email": ...})
      } else {
        // Đăng ký thất bại
        return {'error': data['detail'] ?? 'Lỗi không xác định'};
      }
    } catch (e) {
      return {'error': 'Không thể kết nối đến máy chủ: $e'};
    }
  }

  static Future<AuthResponse> signIn(String email, String password) async {
    try {
      // FastAPI dùng OAuth2PasswordRequestForm, nó mong đợi
      // dữ liệu dạng 'application/x-www-form-urlencoded'
      final response = await http.post(
        Uri.parse('$_baseUrl/token'),
        headers: {'Content-Type': 'application/x-www-form-urlencoded'},
        body: {
          'username': email, // FastAPI OAuth2 form dùng 'username' cho email
          'password': password,
        },
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        // Đăng nhập thành công, trả về token
        // TODO: Bạn cần một endpoint khác (ví dụ: /users/me) để lấy
        // thông tin user từ token này.
        // Tạm thời, chúng ta chỉ trả về token.
        return AuthResponse(
          success: true,
          token: data['access_token'],
          // userJson: ... // Cần gọi API /users/me để lấy
        );
      } else {
        // Đăng nhập thất bại
        return AuthResponse(message: data['detail'] ?? 'Đăng nhập thất bại');
      }
    } catch (e) {
      return AuthResponse(message: 'Không thể kết nối đến máy chủ: $e');
    }
  }

  Future<UserCredential?> signInWithGoogle() async {
    try {
      // Trigger the authentication flow
      final googleUser = await GoogleSignIn().signIn();
      final ggAuth = await googleUser?.authentication;
      if (googleUser == null) return null; // user cancelled

      // Create a new credential
      final credential = GoogleAuthProvider.credential(
        accessToken: ggAuth?.accessToken,
        idToken: ggAuth?.idToken,
      );

      // Once signed in, return the UserCredential
      return await _auth.signInWithCredential(credential);
    } catch (e) {
      // xử lý lỗi ở đây (log hoặc rethrow)
      rethrow;
    }
  }

  Exception _handleFirebaseError(FirebaseAuthException e) {
    debugPrint('Firebase error code: ${e.code}');
    switch (e.code) {
      case 'invalid-email':
        return Exception('Địa chỉ email không hợp lệ.');
      case 'user-disabled':
        return Exception('This account has been disabled.');
      case 'user-not-found':
        return Exception('Không tìm thấy người dùng nào có email này.');
      case 'wrong-password':
      case 'invalid-credential':
      case 'INVALID_LOGIN_CREDENTIALS':
        return Exception('Mật khẩu hoặc email không đúng. Vui lòng thử lại.');
      case 'too-many-requests':
        return Exception('Quá nhiều yêu cầu. Vui lòng thử lại sau');
      case 'user-token-expired':
        return Exception('Phiên đã hết hạn. Vui lòng đăng nhập lại.');
      case 'network-request-failed':
        return Exception('Không có kết nối internet. Vui lòng kiểm tra mạng của bạn.');
      case 'email-already-in-use':
        return Exception('Email này đã được đăng ký. Hãy thử đăng nhập.');
      case 'weak-password':
        return Exception('Mật khẩu phải có ít nhất 6 ký tự.');
      case 'operation-not-allowed':
        return Exception('Email/password sign-in is not enabled.');
      default:
        return Exception('Có lỗi xảy ra. Vui lòng thử lại sau.');
    }
  }

  Future<void> signOut() async {
    // Đăng xuất khỏi Firebase
    await _auth.signOut();
  }
}
