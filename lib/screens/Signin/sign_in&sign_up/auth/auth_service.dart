import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  Future<String?> signUp({
    required String email,
    required String password,
    required String fullName,
  }) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      User? user = result.user;
      if (user != null) {
        await _saveUserToFirestore(user, fullName);
        return null; // Thành công
      }
      return "Không tạo được user";
    } on FirebaseAuthException catch (e) {
      return _handleAuthError(e);
    } catch (e) {
      return "Lỗi: $e";
    }
  }

  Future<String?> signIn({required String email, required String password}) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      return null;
    } on FirebaseAuthException catch (e) {
      return _handleAuthError(e);
    } catch (e) {
      return "Lỗi: $e";
    }
  }

  Future<UserCredential?> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

      if (googleUser == null) return null;

      String googleName = googleUser.displayName ?? googleUser.email.split('@')[0];
      String googlePhoto = googleUser.photoUrl ?? "";

      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

      final OAuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      UserCredential userCredential = await _auth.signInWithCredential(credential);
      User? user = userCredential.user;

      if (user != null) {
        final userDoc = await _firestore.collection('users').doc(user.uid).get();

        if (!userDoc.exists) {
          await _firestore.collection('users').doc(user.uid).set({
            'id': user.uid,
            'email': user.email,
            'display_name': googleName,
            'avatar_url': googlePhoto,
            'role': 'user',
            'created_at': FieldValue.serverTimestamp(),
            'is_profile_completed': false,
          });
        } else {
          Map<String, dynamic> data = userDoc.data() as Map<String, dynamic>;
          if (data['display_name'] == null || data['display_name'] == "") {
            await _firestore.collection('users').doc(user.uid).update({
              'display_name': googleName
            });
          }
        }
      }

      return userCredential;
    } catch (e) {
      print("Lỗi Google Sign In: $e");
      throw Exception("Đăng nhập Google thất bại: $e");
    }
  }

  // 4. RESET PASSWORD
  Future<String?> resetPassword({required String email}) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
      return null;
    } on FirebaseAuthException catch (e) {
      return _handleAuthError(e);
    }
  }

  // 5. ĐĂNG XUẤT
  Future<void> signOut() async {
    await _googleSignIn.signOut();
    await _auth.signOut();
  }

  // --- HÀM PHỤ: LƯU USER VÀO FIRESTORE ---
  Future<void> _saveUserToFirestore(User user, String fullName) async {
    await _firestore.collection('users').doc(user.uid).set({
      'uid': user.uid,
      'email': user.email,
      'full_name': fullName,
      'role': 'user',
      'avatar_url': user.photoURL ?? '',
      'created_at': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true)); // merge: true để không ghi đè nếu đã có
  }

  // --- HÀM PHỤ: XỬ LÝ LỖI ---
  String _handleAuthError(FirebaseAuthException e) {
    switch (e.code) {
      case 'email-already-in-use': return 'Email này đã được đăng ký.';
      case 'invalid-email': return 'Email không hợp lệ.';
      case 'user-disabled': return 'Tài khoản bị vô hiệu hóa.';
      case 'user-not-found': return 'Không tìm thấy tài khoản.';
      case 'wrong-password': return 'Sai mật khẩu.';
      case 'weak-password': return 'Mật khẩu quá yếu.';
      case 'credential-already-in-use': return 'Email này đã liên kết với tài khoản khác.';
      default: return 'Lỗi hệ thống: ${e.code} - ${e.message}';
    }
  }
}