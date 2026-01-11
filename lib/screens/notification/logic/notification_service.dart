import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class NotificationService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  /// Gửi thông báo cho tất cả người theo dõi khi có công thức mới
  Future<void> sendRecipeNotification({
    required String recipeId,
    required String recipeTitle,
  }) async {
    final currentUser = _auth.currentUser;
    if (currentUser == null) return;

    try {
      // 1. Lấy thông tin người đăng (User B - người đang login)
      // Để hiển thị tên trong thông báo: "Mr.Dean đã đăng..."
      DocumentSnapshot userDoc =
      await _firestore.collection('users').doc(currentUser.uid).get();
      final userData = userDoc.data() as Map<String, dynamic>?;
      String userName = userData?['display_name'] ?? 'Một đầu bếp';

      // 2. Lấy danh sách những người đang theo dõi User B
      // Dựa trên logic User Service: users/{uid}/followers
      QuerySnapshot followersSnapshot = await _firestore
          .collection('users')
          .doc(currentUser.uid)
          .collection('followers')
          .get();

      if (followersSnapshot.docs.isEmpty) {
        print("Không có người theo dõi nào để gửi thông báo.");
        return;
      }

      // 3. Sử dụng WriteBatch để ghi nhiều dữ liệu cùng lúc (tối ưu hiệu năng)
      WriteBatch batch = _firestore.batch();

      for (var doc in followersSnapshot.docs) {
        String followerId = doc.id; // ID của User A (người nhận)

        // Tạo reference đến collection notifications của User A
        DocumentReference notiRef = _firestore
            .collection('users')
            .doc(followerId)
            .collection('notifications')
            .doc();

        // Dữ liệu thông báo
        Map<String, dynamic> notificationData = {
          'id': notiRef.id,
          'message': '$userName đã thêm công thức mới: $recipeTitle',
          'type': 'recipe', // Loại thông báo
          'senderId': currentUser.uid, // ID người gửi
          'recipeId': recipeId, // ID bài viết để điều hướng
          'isRead': false,
          'createdAt': FieldValue.serverTimestamp(),
        };

        batch.set(notiRef, notificationData);
      }

      // 4. Thực thi batch
      await batch.commit();
      print("Đã gửi thông báo thành công cho ${followersSnapshot.docs.length} người.");

    } catch (e) {
      print("Lỗi khi gửi thông báo: $e");
    }
  }

  Future<void> sendFollowNotification({
    required String targetUserId, // ID người NHẬN thông báo (Người được follow)
  }) async {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) return;

    try {
      // 1. Lấy thông tin người gửi (Tên, Avatar) để hiển thị trong thông báo
      final senderDoc = await _firestore.collection('users').doc(currentUser.uid).get();
      final senderName = senderDoc.data()?['displayName'] ?? "Người dùng";

      // 2. Tạo data thông báo
      final notificationData = {
        'type': 'follow', // Loại thông báo để hiện icon IconType.follow
        'message': '$senderName đã bắt đầu theo dõi bạn',
        'createdAt': FieldValue.serverTimestamp(),
        'isRead': false,
        'senderId': currentUser.uid, // Lưu ID người gửi để sau này click vào ra profile
        'recipeId': null, // Follow thì không có recipeId
      };

      // 3. Ghi vào sub-collection 'notifications' của người nhận
      await _firestore
          .collection('users')
          .doc(targetUserId)
          .collection('notifications')
          .add(notificationData);

    } catch (e) {
      print("Lỗi gửi thông báo: $e");
    }
  }
}