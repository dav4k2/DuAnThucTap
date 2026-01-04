// lib/widgets/edit_profile/edit_avatar_section.dart
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import '../logic/edit_profile_provider.dart';

class EditAvatarSection extends ConsumerWidget {
  const EditAvatarSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(editProfileProvider);

    return Transform.translate(
      offset: Offset(0, -55.h),
      child: SizedBox( // Dùng SizedBox thay cho Container nếu chỉ muốn set width
        width: double.infinity,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Stack(
              alignment: Alignment.center,
              children: [
                // Lớp viền trắng bao quanh Avatar
                Container(
                  padding: EdgeInsets.all(3.w),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                  child: CircleAvatar(
                    radius: 55.r,
                    backgroundColor: Colors.grey[200],
                    backgroundImage: _getAvatarImage(state),
                  ),
                ),
                // Nút chọn ảnh Avatar (Camera icon)
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: GestureDetector(
                    onTap: () => _pickImage(ref),
                    child: CircleAvatar(
                      radius: 16.r,
                      backgroundColor: const Color(0xFFF5F5F5),
                      child: Icon(
                          Icons.camera_alt,
                          size: 16.sp,
                          color: Colors.grey[700]
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // Hàm bổ trợ để lấy ImageProvider an toàn
  ImageProvider _getAvatarImage(EditProfileState state) {
    if (state.avatarFile != null) {
      return FileImage(state.avatarFile!);
    } else if (state.avatarUrl != null && state.avatarUrl!.startsWith('http')) {
      return NetworkImage(state.avatarUrl!);
    }
    return const AssetImage("image/empty_user.jpg");
  }

  Widget _buildPickerButton(WidgetRef ref) {
    return GestureDetector(
      onTap: () => _pickImage(ref),
      child: Container(
        padding: EdgeInsets.all(8.w),
        decoration: const BoxDecoration(
          color: Color(0xFFF5F5F5),
          shape: BoxShape.circle,
        ),
        child: Icon(Icons.camera_alt_rounded, size: 20.sp, color: Colors.grey[700]),
      ),
    );
  }

  void _pickImage(WidgetRef ref) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery, imageQuality: 80);
    if (pickedFile != null) {
      ref.read(editProfileProvider.notifier).updateAvatar(File(pickedFile.path));
    }
  }
}
