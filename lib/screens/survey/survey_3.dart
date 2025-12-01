// lib/screens/survey/survey_step3_screen.dart
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';

import 'logic/survey_provider.dart';
import 'widgets/survey_title_1.dart';
import 'widgets/survey_description.dart';
import 'widgets/survey_input_field.dart';
import 'widgets/survey_text_area.dart';
import 'widgets/survey_country_dropdown.dart';
import 'widgets/survey_avatar_picker.dart';

class Survey3 extends ConsumerStatefulWidget {
  const Survey3({super.key});

  @override
  ConsumerState<Survey3> createState() => _SurveyStep3ScreenState();
}

class _SurveyStep3ScreenState extends ConsumerState<Survey3> {
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage({required bool isAvatar}) async {
    try {
      final XFile? picked = await _picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 85,
        maxWidth: 1200,
      );

      if (picked != null && mounted) {
        final file = File(picked.path);

        if (isAvatar) {
          ref.read(surveyProvider.notifier).setAvatarFile(file);
        } else {
          ref.read(surveyProvider.notifier).setCoverFile(file);
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Không thể chọn ảnh: $e")),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final survey = ref.watch(surveyProvider);

    return Container(
      width: 402.w,
      height: 874.h,
      clipBehavior: Clip.antiAlias,
      decoration: ShapeDecoration(
        color: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50.r)),
      ),
      child: Stack(
        children: [
          // ẢNH BÌA
          Positioned(
            top: 225.h,
            left: -3.w,
            child: Container(
              width: 402.w,
              height: 200.h,
              decoration: BoxDecoration(
                image: survey.coverFile != null
                    ? DecorationImage(
                  image: FileImage(survey.coverFile!),
                  fit: BoxFit.cover,
                )
                    : null,
                color: survey.coverFile == null ? const Color(0xFFC4C4C4) : null,
              ),
            ),
          ),

          // Form trắng
          Positioned(
            top: 377.h,
            child: IgnorePointer(
              child: Container(
                width: 402.w,
                height: 579.h,
                decoration: ShapeDecoration(
                  color: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.r)),
                ),
              ),
            ),
          ),

          const Positioned(
            left: 42,
            top: 100,
            child: SurveyTitle1(text: 'Hoàn tất thông tin cho \ntrang cá nhân của bạn'),
          ),
          const Positioned(
            left: 28,
            top: 197,
            child: SurveyDescription(text: 'Trang cá nhân của bạn sẽ trông như thế này'),
          ),

          // Inputs
          Positioned(
            top: 446.h,
            left: 24.w,
            child: SurveyInputField(
              label: "Tên người dùng",
              placeholder: "Kong Fuong",
              isRequired: true,
              onChanged: (v) => ref.read(surveyProvider.notifier).setDisplayName(v),
            ),
          ),
          Positioned(
            top: 542.h,
            left: 24.w,
            child: SurveyTextArea(onChanged: (v) => ref.read(surveyProvider.notifier).setBio(v)),
          ),
          Positioned(
            top: 658.h,
            left: 25.w,
            child: SurveyCountryDropdown(onChanged: (v) => ref.read(surveyProvider.notifier).setCountry(v)),
          ),

          // NÚT ĐỔI ẢNH BÌA
          Positioned(
            top: 353.h,
            right: 20.w,
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(30.r),
                onTap: () => _pickImage(isAvatar: false),
                child: Container(
                  width: 44.w,
                  height: 44.h,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white,
                    boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 8, offset: Offset(0, 4))],
                  ),
                  child: Icon(Icons.camera_alt, size: 22.sp, color: Colors.black87),
                ),
              ),
            ),
          ),

          // AVATAR PICKER
          Positioned(
            top: 306.h,
            left: 127.w,
            child: SurveyAvatarPicker(
              imageFile: survey.avatarFile,
              imageUrl: "https://placehold.co/120x120",
              onTap: () => _pickImage(isAvatar: true),
            ),
          ),
        ],
      ),
    );
  }
}