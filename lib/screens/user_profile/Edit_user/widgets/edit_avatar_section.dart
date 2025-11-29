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

    return SizedBox(
      width: double.infinity,
      height: 15.h, // giữ nguyên 0, không đẩy nội dung xuống
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.topCenter,
        children: [
          // Ảnh nền
          Container(
            width: double.infinity,
            height: 180.h,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: NetworkImage("https://placehold.co/402x222"),
                fit: BoxFit.cover,
              ),
            ),
          ),

          // Avatar với viền trắng
          Positioned(
            bottom: -10.h, // nhô ra khỏi ảnh nền
            child: Stack(
              alignment: Alignment.center,
              children: [
                // Viền trắng
                Container(
                  width: 130.w,
                  height: 130.h,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                ),

                // Avatar
                CircleAvatar(
                  radius: 60.r,
                  backgroundImage: state.avatarFile != null
                      ? FileImage(state.avatarFile!)
                      : const AssetImage("image/avatar.png") as ImageProvider,
                ),

                // Nút chọn ảnh (gallery)
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: Material(
                    color: Colors.transparent,
                    shape: const CircleBorder(),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(50.r),
                      onTap: () => _pickImage(ref),
                      child: Container(
                        width: 40.w,
                        height: 40.h,
                        decoration: const BoxDecoration(
                          color: Color(0xFFFFFDFD),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.photo_library, color: Colors.grey),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _pickImage(WidgetRef ref) async {
    final picker = ImagePicker();
    final pickedFile =
    await picker.pickImage(source: ImageSource.gallery, imageQuality: 80);
    if (pickedFile != null) {
      ref.read(editProfileProvider.notifier).updateAvatar(File(pickedFile.path));
    }
  }
}
