import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthServices {
  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;

  Future<User?> signUpWithEmail(String email, String password, String username, String confirmPass) async {
    try {
      final userCred = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      User? user = userCred.user;

      if(user!=null){
        // 2. Cập nhật displayName trong Firebase Auth
        await user.updateDisplayName(username);
        await user.reload();
        user = _auth.currentUser; // Lấy lại thông tin user đã cập nhật

        // 3. Lưu thông tin (username, email) vào Cloud Firestore
        // Dùng UID của user làm ID document
        await _firestore.collection("user").doc(user!.uid).set({
          'username': username,
          'email': email,
          'uid': user.uid,
          'createdAt': FieldValue.serverTimestamp(),
        });
      }
      return user;
    } on FirebaseAuthException catch (e) {
      throw _handleFirebaseError(e);
    }
  }

  Future<User?> signInWithEmail(String email, String password) async {
    try {
      final userCred = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCred.user;
    } on FirebaseAuthException catch (e) {
      throw _handleFirebaseError(e);
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
