import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fontend/screens/user_profile/Edit_user/widgets/edit_avatar_section.dart';
import 'package:fontend/screens/user_profile/Edit_user/widgets/edit_dropdown_field.dart';
import 'package:fontend/screens/user_profile/Edit_user/widgets/edit_header.dart';
import 'package:fontend/screens/user_profile/Edit_user/widgets/edit_save_button.dart';
import 'package:fontend/screens/user_profile/Edit_user/widgets/edit_text_field.dart';
import 'logic/edit_profile_provider.dart';

class EditProfileScreen extends ConsumerStatefulWidget {
  const EditProfileScreen({super.key});

  @override
  ConsumerState<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends ConsumerState<EditProfileScreen> {
  late TextEditingController _nameController;
  late TextEditingController _bioController;

  String selectedLevel = 'Đầu bếp chuyên nghiệp';
  String selectedCountry = 'Việt Nam';

  final levels = [
    'Người mới',
    'Nấu ăn tại nhà',
    'Đầu bếp bán chuyên',
    'Đầu bếp chuyên nghiệp',
    'Master Chef'
  ];
  final countries = [
    'Việt Nam',
    'Thái Lan',
    'Nhật Bản',
    'Hàn Quốc',
    'Trung Quốc',
    'Pháp',
    'Ý',
    'Mỹ',
    'Ấn Độ',
    'Khác'
  ];

  @override
  void initState() {
    super.initState();
    final state = ref.read(editProfileProvider);
    _nameController = TextEditingController(text: state.name);
    _bioController = TextEditingController(text: state.bio);

    _nameController.addListener(() =>
        ref.read(editProfileProvider.notifier).updateName(_nameController.text));
    _bioController.addListener(() =>
        ref.read(editProfileProvider.notifier).updateBio(_bioController.text));
  }

  @override
  void dispose() {
    _nameController.dispose();
    _bioController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      extendBodyBehindAppBar: true,
      body: SafeArea(
        top: false, // header đã kéo lên top, tránh double padding
        child: SingleChildScrollView(
          physics: const ClampingScrollPhysics(), // tránh overscroll
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header + back button
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
                        backgroundColor: Colors.white70,
                        child:
                        Icon(Icons.arrow_back_ios_new_rounded, size: 16.sp),
                      ),
                    ),
                  ),
                ],
              ),

              // Avatar
              const EditAvatarSection(),

              SizedBox(height: 20.h),

              // Tên người dùng
              Row(
                children: [
                  Padding(
                    padding: EdgeInsets.only(left: 7.w),
                    child: Text(
                      'Tên người dùng',
                      style: TextStyle(
                          fontSize: 20.sp, fontWeight: FontWeight.w500),
                    ),
                  ),
                  Text(
                    ' (*)',
                    style: TextStyle(
                        color: const Color(0xFFFF5959), fontSize: 13.sp),
                  ),
                ],
              ),
              SizedBox(height: 8.h),
              EditTextField(
                hintText: 'Nhập tên của bạn',
                controller: _nameController,
                maxLength: 30,
              ),
              SizedBox(height: 24.h),

              // Trình độ
              EditDropdownField(
                label: 'Trình độ',
                value: selectedLevel,
                items: levels,
                onChanged: (v) => setState(() => selectedLevel = v!),
              ),
              SizedBox(height: 24.h),

              // Tiểu sử
              EditTextField(
                label: 'Tiểu sử',
                hintText: 'Giới thiệu về bạn...',
                controller: _bioController,
                maxLines: 6,
                maxLength: 200,
              ),
              SizedBox(height: 24.h),

              // Quốc gia
              EditDropdownField(
                label: 'Quốc gia',
                value: selectedCountry,
                items: countries,
                onChanged: (v) => setState(() => selectedCountry = v!),
              ),
              SizedBox(height: 40.h),

              // Nút lưu
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: EditSaveButton(
                  onPressed: () async {
                    await ref.read(editProfileProvider.notifier).save();
                    if (!mounted) return;
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Đã lưu thành công!')),
                    );
                    Navigator.pop(context);
                  },
                ),
              ),
              SizedBox(height: 30.h),
            ],
          ),
        ),
      ),
    );
  }
}
