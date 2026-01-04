import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import '../../MyUser_profile/logic/my_profile_provider.dart';
import '../logic/edit_profile_provider.dart';

class EditHeader extends ConsumerWidget {
  const EditHeader({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final state = ref.watch(editProfileProvider);

    // Màu sắc theo theme
    final bottomContainerColor = isDark ? Colors.grey[900]! : Colors.white;
    final pickButtonBgColor = isDark ? Colors.grey[800]! : Colors.white;
    final pickButtonIconColor = isDark ? Colors.white70 : Colors.grey;

    return Stack(
      clipBehavior: Clip.none,
      children: [
        // 1. Ảnh nền (header/cover)
        Container(
          width: double.infinity,
          height: 220.h,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: state.headerFile != null
                  ? FileImage(state.headerFile!)
                  : getImageProvider(state.coverUrl, defaultAsset: "image/empty.png"),
              fit: BoxFit.cover,
            ),
          ),
        ),

        // 2. Nền cong bên dưới (phần trắng/đen chứa nội dung)
        Positioned(
          top: 195.h,
          child: Container(
            width: 402.w,
            height: 676.h,
            decoration: ShapeDecoration(
              color: bottomContainerColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.r),
              ),
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
              decoration: BoxDecoration(
                color: pickButtonBgColor,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(isDark ? 0.5 : 0.2),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Icon(
                Icons.photo_library,
                color: pickButtonIconColor,
                size: 24.sp,
              ),
            ),
          ),
        ),
      ],
    );
  }

  ImageProvider getImageProvider(String? path, {required String defaultAsset}) {
    if (path == null || path.isEmpty || !path.startsWith('http')) {
      return AssetImage(defaultAsset);
    }
    return NetworkImage(path);
  }

  void _pickHeaderImage(WidgetRef ref) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 80,
    );
    if (pickedFile != null) {
      ref.read(editProfileProvider.notifier).updateHeader(File(pickedFile.path));
    }
  }
}