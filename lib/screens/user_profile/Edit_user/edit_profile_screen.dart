import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fontend/screens/user_profile/Edit_user/widgets/edit_avatar_section.dart';
import 'package:fontend/screens/user_profile/Edit_user/widgets/edit_dropdown_field.dart';
import 'package:fontend/screens/user_profile/Edit_user/widgets/edit_header.dart';
import 'package:fontend/screens/user_profile/Edit_user/widgets/edit_save_button.dart';
import 'package:fontend/screens/user_profile/Edit_user/widgets/edit_text_field.dart';
import '../../survey/logic/survey_provider.dart';
import '../MyUser_profile/logic/my_profile_provider.dart';
import 'logic/edit_profile_provider.dart';

class EditProfileScreen extends ConsumerStatefulWidget {
  final MyChef user;

  const EditProfileScreen({super.key, required this.user});

  @override
  ConsumerState<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends ConsumerState<EditProfileScreen> {
  late TextEditingController _nameController;
  late TextEditingController _bioController;

  // Biến local để bind vào Dropdown UI
  late String selectedLevel;
  late String selectedCountry;

  final levels = [
    'Mới tập nấu'.tr(),
    'Nghiệp dư'.tr(),
    'Đầu bếp tại gia'.tr(),
    'Đầu bếp chuyên nghiệp'.tr(),
    'Không chắc chắn'.tr(),
  ];

  final countries = [
    'Việt Nam'.tr(),
    'Thái Lan'.tr(),
    'Nhật Bản'.tr(),
    'Hàn Quốc'.tr(),
    'Trung Quốc'.tr(),
    'Pháp'.tr(),
    'Ý'.tr(),
    'Mỹ'.tr(),
    'Ấn Độ'.tr(),
    'Khác'.tr(),
  ];

  @override
  void initState() {
    super.initState();

    // Lấy state hiện tại từ Provider (lúc này đã được khởi tạo từ myChefProvider)
    // Sử dụng ref.read vì đây là initState, chỉ chạy 1 lần
    final initialState = ref.read(editProfileProvider);

    _nameController = TextEditingController(text: initialState.name);
    _bioController = TextEditingController(text: initialState.bio);

    selectedLevel = initialState.cookingLevel;
    selectedCountry = initialState.country;

    // Lắng nghe thay đổi từ Controller để cập nhật vào Provider
    _nameController.addListener(() {
      ref.read(editProfileProvider.notifier).updateName(_nameController.text);
    });
    _bioController.addListener(() {
      ref.read(editProfileProvider.notifier).updateBio(_bioController.text);
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _bioController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    // Màu sắc theo theme
    final backgroundColor = isDark ? Colors.grey[900]! : Colors.white;
    final textColor = isDark ? Colors.white : Colors.black;
    final subtitleColor = isDark ? Colors.white70 : Colors.black87;
    final requiredColor = const Color(0xFFFF5959); // Giữ màu đỏ bắt buộc
    final backButtonBg = isDark ? Colors.black54 : Colors.white70;

    return Scaffold(
      backgroundColor: backgroundColor,
      extendBodyBehindAppBar: true,
      body: SafeArea(
        top: false,
        bottom: false,
        child: SingleChildScrollView(
          physics: const ClampingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                children: [
                  const EditHeader(),
                  Positioned(
                    top: MediaQuery.of(context).padding.top + 20.h,
                    left: 10.w,
                    child: GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: CircleAvatar(
                        radius: 15.5.r,
                        backgroundColor: backButtonBg,
                        child: Icon(
                          Icons.arrow_back_ios_new_rounded,
                          size: 16.sp,
                          color: isDark ? Colors.white : Colors.black,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const EditAvatarSection(),
              SizedBox(height: 20.h),

              // Name Field
              Row(
                children: [
                  Padding(
                    padding: EdgeInsets.only(left: 7.w),
                    child: Text(
                      'Tên người dùng'.tr(),
                      style: TextStyle(
                        fontSize: 20.sp,
                        fontWeight: FontWeight.w500,
                        color: textColor,
                      ),
                    ),
                  ),
                  Text(
                    ' (*)',
                    style: TextStyle(color: requiredColor, fontSize: 13.sp),
                  ),
                ],
              ),
              SizedBox(height: 8.h),
              EditTextField(
                hintText: 'Nhập tên của bạn'.tr(),
                controller: _nameController,
                maxLength: 30,
              ),
              SizedBox(height: 24.h),

              // Level Dropdown
              EditDropdownField(
                label: 'Trình độ'.tr(),
                value: selectedLevel,
                items: levels,
                onChanged: (v) {
                  setState(() => selectedLevel = v!);
                  ref.read(editProfileProvider.notifier).updateCookingLevel(v!);
                },
              ),
              SizedBox(height: 24.h),

              // Bio Field
              EditTextField(
                label: 'Tiểu sử'.tr(),
                hintText: 'Giới thiệu về bạn...'.tr(),
                controller: _bioController,
                maxLines: 6,
                maxLength: 200,
              ),
              SizedBox(height: 24.h),

              // Country Dropdown
              EditDropdownField(
                label: 'Quốc gia'.tr(),
                value: selectedCountry,
                items: countries,
                onChanged: (v) {
                  setState(() => selectedCountry = v!);
                  ref.read(editProfileProvider.notifier).updateCountry(v!);
                },
              ),
              SizedBox(height: 40.h),

              // Save Button
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: EditSaveButton(
                  onPressed: () async {
                    final success = await ref.read(editProfileProvider.notifier).save();
                    if (!mounted) return;

                    if (success) {
                      final editState = ref.read(editProfileProvider);
                      ref.read(surveyProvider.notifier).updateUserData(
                        displayName: editState.name,
                        bio: editState.bio,
                        cookingTitle: editState.cookingLevel,
                        country: editState.country,
                      );

                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Đã lưu thành công!'.tr())),
                      );
                      Navigator.pop(context);
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Lỗi khi lưu hồ sơ'.tr())),
                      );
                    }
                  },
                ),
              ),
              SizedBox(height: 30.h + MediaQuery.of(context).padding.bottom),
            ],
          ),
        ),
      ),
    );
  }
}