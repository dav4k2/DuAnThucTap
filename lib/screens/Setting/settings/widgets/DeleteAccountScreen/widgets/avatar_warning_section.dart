// lib/screens/delete_account/widgets/avatar_warning_section.dart
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../../user_profile/MyUser_profile/logic/my_profile_provider.dart';


class AvatarWarningSection extends ConsumerWidget {
  const AvatarWarningSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final myChef = ref.watch(myChefProvider);
    final avatarPath = myChef.avatarUrl;

    // Xác định loại ảnh và hiển thị đúng cách
    Widget avatarWidget;

    if (avatarPath.startsWith('http') || avatarPath.startsWith('https')) {
      // Ảnh từ mạng
      avatarWidget = CircleAvatar(
        radius: 60,
        backgroundImage: NetworkImage(avatarPath),
        backgroundColor: Colors.transparent,
      );
    } else if (avatarPath.startsWith('/')) {
      // Ảnh từ file local (File)
      avatarWidget = CircleAvatar(
        radius: 60,
        backgroundImage: FileImage(File(avatarPath)),
        backgroundColor: Colors.transparent,
      );
    } else {
      // Ảnh từ asset (mặc định)
      avatarWidget = CircleAvatar(
        radius: 60,
        backgroundImage: AssetImage(avatarPath),
        backgroundColor: Colors.transparent,
      );
    }

    return Center(
      child: Stack(
        children: [
          // Avatar chính có viền nhẹ
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: const Color(0xFFC6BFBF), width: 1.5),
            ),
            child: ClipOval(child: avatarWidget),
          ),

          // Icon cảnh báo đỏ góc dưới bên phải
          Positioned(
            right: 0,
            bottom: 0,
            child: Container(
              width: 39,
              height: 39,
              decoration: const ShapeDecoration(
                color: Color(0xFFF74E4E),
                shape: OvalBorder(),
                shadows: [
                  BoxShadow(
                    color: Color(0x3F000000),
                    blurRadius: 4,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: const Icon(
                Icons.warning_amber_rounded,
                color: Colors.white,
                size: 24,
              ),
            ),
          ),
        ],
      ),
    );
  }
}