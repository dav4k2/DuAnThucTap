// lib/logic/edit_profile_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:io';
import '../../MyUser_profile/logic/my_profile_provider.dart';
import '../../../../Service/user_service.dart'; // Import service của bạn

// 1. Cập nhật State để chứa Country và Level
class EditProfileState {
  final String name;
  final String bio;
  final String country;      // Thêm
  final String cookingLevel; // Thêm
  final String? avatarUrl;
  final File? avatarFile;
  final File? headerFile;
  final String? coverUrl;

  EditProfileState({
    required this.name,
    required this.bio,
    required this.country,      // Thêm
    required this.cookingLevel, // Thêm
    this.avatarUrl,
    this.avatarFile,
    this.headerFile,
    this.coverUrl,
  });

  EditProfileState copyWith({
    String? name,
    String? bio,
    String? country,
    String? cookingLevel,
    String? avatarUrl,
    File? avatarFile,
    File? headerFile,
    String? coverUrl,
  }) {
    return EditProfileState(
      name: name ?? this.name,
      bio: bio ?? this.bio,
      country: country ?? this.country,
      cookingLevel: cookingLevel ?? this.cookingLevel,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      avatarFile: avatarFile ?? this.avatarFile,
      headerFile: headerFile ?? this.headerFile,
      coverUrl: coverUrl ?? this.coverUrl,
    );
  }
}

class EditProfileNotifier extends StateNotifier<EditProfileState> {
  // 2. Lấy dữ liệu từ MyChef để khởi tạo State (Pre-fill)
  EditProfileNotifier(MyChef myChef)
      : super(EditProfileState(
    name: myChef.name,
    bio: myChef.bio ?? '',
    country: myChef.country ?? 'Việt Nam', // Giá trị mặc định nếu null
    cookingLevel: myChef.cookingTitle ?? 'Đầu bếp tại gia',
    avatarUrl: myChef.avatarUrl,
  ));

  void updateName(String name) => state = state.copyWith(name: name);
  void updateBio(String bio) => state = state.copyWith(bio: bio);
  void updateCountry(String country) => state = state.copyWith(country: country);
  void updateCookingLevel(String level) => state = state.copyWith(cookingLevel: level);
  void updateAvatar(File file) => state = state.copyWith(avatarFile: file);
  void updateHeader(File file) => state = state.copyWith(headerFile: file);

  // 3. Hàm Save gọi API
  Future<bool> save() async {
    final userService = UserService();

    // Gọi API updateProfile
    final success = await userService.updateUserProfile(
      displayName: state.name,
      bio: state.bio,
      country: state.country,
      cookingLevel: state.cookingLevel,
      avatarFile: state.avatarFile,
      coverFile: state.headerFile,
    );

    return success;
  }
}

final editProfileProvider =
StateNotifierProvider<EditProfileNotifier, EditProfileState>((ref) {
  final myChef = ref.watch(myChefProvider);
  return EditProfileNotifier(myChef);
});