import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'draft_recipe.dart';

class DraftService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> saveDraft(DraftRecipe draft) async {
    final user = _auth.currentUser;
    if (user == null) return;

    final docRef = _firestore
        .collection('users')
        .doc(user.uid)
        .collection('drafts')
        .doc(draft.id.isEmpty ? null : draft.id);

    final data = draft.toJson();
    data['savedAt'] = FieldValue.serverTimestamp();
    data['authorId'] = user.uid;

    await docRef.set(data, SetOptions(merge: true));
  }

  Future<void> deleteDraft(String draftId) async {
    final user = _auth.currentUser;
    if (user == null) return;

    await _firestore
        .collection('users')
        .doc(user.uid)
        .collection('drafts')
        .doc(draftId)
        .delete();
  }
}

final draftServiceProvider = Provider<DraftService>((ref) => DraftService());

final authStateProvider = StreamProvider<User?>((ref) {
  return FirebaseAuth.instance.authStateChanges();
});

final recipeDraftProvider = StreamProvider<List<DraftRecipe>>((ref) {
  final authState = ref.watch(authStateProvider);

  return authState.when(
    data: (user) {
      if (user == null) {
        return Stream.value([]);
      }

      return FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .collection('drafts')
          .orderBy('savedAt', descending: true)
          .snapshots()
          .map((snapshot) {
        return snapshot.docs.map((doc) {
          final data = doc.data();
          data['id'] = doc.id;

          return DraftRecipe.fromJson(data);
        }).toList();
      });
    },
    loading: () => Stream.value([]),
    error: (_, __) => Stream.value([]),
  );
});