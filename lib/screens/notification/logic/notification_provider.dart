// file: lib/screens/notification/logic/notification_provider.dart

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// --- ENUM ---
enum IconType { recipe, follow, comment, achievement }

// --- MODEL ---
class NotificationModel {
  final String id;
  final String message;
  final DateTime createdAt;
  final bool isRead;
  final IconType iconType;
  final String? recipeId; // Thêm trường này để biết navigate đi đâu

  NotificationModel({
    required this.id,
    required this.message,
    required this.createdAt,
    required this.iconType,
    required this.isRead,
    this.recipeId,
  });

  // Hàm helper để convert thời gian sang String "1h", "30m"
  String get timeDisplay {
    final diff = DateTime.now().difference(createdAt);
    if (diff.inDays > 0) return "${diff.inDays}d";
    if (diff.inHours > 0) return "${diff.inHours}h";
    if (diff.inMinutes > 0) return "${diff.inMinutes}m";
    return "Vừa xong";
  }

  factory NotificationModel.fromSnapshot(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;

    // Mapping string type từ DB sang Enum
    IconType type = IconType.achievement;
    if (data['type'] == 'recipe') type = IconType.recipe;
    if (data['type'] == 'follow') type = IconType.follow;
    if (data['type'] == 'comment') type = IconType.comment;

    Timestamp timestamp = data['createdAt'] ?? Timestamp.now();

    return NotificationModel(
      id: doc.id,
      message: data['message'] ?? '',
      createdAt: timestamp.toDate(),
      isRead: data['isRead'] ?? false,
      iconType: type,
      recipeId: data['recipeId'],
    );
  }
}

// --- PROVIDER (Stream) ---
// Provider này sẽ tự động lắng nghe real-time từ Firestore

final notificationStreamProvider = StreamProvider.autoDispose<List<NotificationModel>>((ref) {
  final user = FirebaseAuth.instance.currentUser;
  if (user == null) return Stream.value([]);

  return FirebaseFirestore.instance
      .collection('users')
      .doc(user.uid)
      .collection('notifications')
      .orderBy('createdAt', descending: true) // Mới nhất lên đầu
      .snapshots()
      .map((snapshot) {
    return snapshot.docs.map((doc) => NotificationModel.fromSnapshot(doc)).toList();
  });
});

// Logic đánh dấu đã đọc
class NotificationController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> markAsRead(String notificationId) async {
    final uid = _auth.currentUser?.uid;
    if (uid == null) return;
    await _firestore
        .collection('users')
        .doc(uid)
        .collection('notifications')
        .doc(notificationId)
        .update({'isRead': true});
  }

  Future<void> markAllAsRead() async {
    final uid = _auth.currentUser?.uid;
    if (uid == null) return;

    // Lưu ý: Batch update nếu số lượng lớn, demo thì loop đơn giản
    final snapshot = await _firestore
        .collection('users')
        .doc(uid)
        .collection('notifications')
        .where('isRead', isEqualTo: false)
        .get();

    WriteBatch batch = _firestore.batch();
    for (var doc in snapshot.docs) {
      batch.update(doc.reference, {'isRead': true});
    }
    await batch.commit();
  }
}

final notificationControllerProvider = Provider((ref) => NotificationController());