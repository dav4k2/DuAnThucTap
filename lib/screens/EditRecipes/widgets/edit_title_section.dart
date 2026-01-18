// lib/features/Remove/enter_new_password/widgets/edit_title_section.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class EditTitleSection extends StatelessWidget {
  const EditTitleSection({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Text(
      'Chỉnh sửa công thức',
      style: TextStyle(
        fontFamily: 'SF Pro',
        fontSize: 24.sp,
        fontWeight: FontWeight.w600,
        color: isDark ? Colors.white : Colors.black,
      ),
    );
  }
}