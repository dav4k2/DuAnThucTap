// lib/logic/edit_profile_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:io';
import '../../MyUser_profile/logic/my_profile_provider.dart';

class EditProfileState {
  final String name;
  final String bio;
  final String? avatarUrl;
  final File? avatarFile;
  final File? headerFile; // ảnh nền mới chọn

  EditProfileState({
    required this.name,
    required this.bio,
    this.avatarUrl,
    this.avatarFile,
    this.headerFile,
  });

  EditProfileState copyWith({
    String? name,
    String? bio,
    String? avatarUrl,
    File? avatarFile,
    File? headerFile,
  }) {
    return EditProfileState(
      name: name ?? this.name,
      bio: bio ?? this.bio,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      avatarFile: avatarFile ?? this.avatarFile,
      headerFile: headerFile ?? this.headerFile,
    );
  }
}

class EditProfileNotifier extends StateNotifier<EditProfileState> {
  EditProfileNotifier(MyChef myChef)
      : super(EditProfileState(
    name: myChef.name,
    bio: myChef.bio ?? '',
    avatarUrl: myChef.avatarUrl,
  ));

  void updateName(String name) => state = state.copyWith(name: name);
  void updateBio(String bio) => state = state.copyWith(bio: bio);
  void updateAvatar(File file) => state = state.copyWith(avatarFile: file);
  void updateHeader(File file) => state = state.copyWith(headerFile: file);

  Future<void> save() async {
    // TODO: upload avatarFile + headerFile + cập nhật Firestore
  }
}

final editProfileProvider =
StateNotifierProvider<EditProfileNotifier, EditProfileState>((ref) {
  final myChef = ref.watch(myChefProvider);
  return EditProfileNotifier(myChef);
});
