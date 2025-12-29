import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import '../../MyUser_profile/logic/my_profile_provider.dart';
import '../logic/edit_profile_provider.dart'; // provider để lưu ảnh


class EditHeader extends ConsumerWidget {
  const EditHeader({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(editProfileProvider);
    final chef = ref.watch(myChefProvider); // lấy dữ liệu MyChef

    return Stack(
      clipBehavior: Clip.none,
      children: [
        // 1. Ảnh nền
        Container(
          width: double.infinity,
          height: 220.h,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: state.headerFile != null
                  ? FileImage(state.headerFile!) // Ưu tiên ảnh từ máy
                  : getImageProvider(state.coverUrl, defaultAsset: "image/profile_bg.png"),
              fit: BoxFit.cover,
            ),
          ),
        ),

        // 2. Nền trắng bên dưới
        Positioned(
          top: 195.h,
          child: Container(
            width: 402.w,
            height: 676.h,
            decoration: ShapeDecoration(
              color: Colors.white,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.r)),
            ),
          ),
        ),

        // 3. Nút chọn ảnh nền
        Positioned(
          top: 220.h - 40.h - 10.h,
          right: 15.w,
          child: GestureDetector(
            onTap: () => _pickHeaderImage(ref),
            child: Container(
              width: 40.w,
              height: 40.h,
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.photo_library, color: Colors.grey),
            ),
          ),
        ),
      ],
    );
  }

  ImageProvider getImageProvider(String? path, {required String defaultAsset}) {
    if (path == null || path.isEmpty || !path.startsWith('http')) {
      return AssetImage(defaultAsset); // Nếu không có http, coi là Asset
    }
    return NetworkImage(path); // Nếu có http, dùng NetworkImage
  }

  void _pickHeaderImage(WidgetRef ref) async {
    final picker = ImagePicker();
    final pickedFile =
    await picker.pickImage(source: ImageSource.gallery, imageQuality: 80);
    if (pickedFile != null) {
      ref.read(editProfileProvider.notifier).updateHeader(File(pickedFile.path));
    }
  }
}
