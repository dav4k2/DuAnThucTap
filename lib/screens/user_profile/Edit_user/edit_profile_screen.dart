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
import '../MyUser_profile/logic/my_profile_provider.dart';

class EditProfileScreen extends ConsumerStatefulWidget {
  const EditProfileScreen({super.key});

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
    'Mới tập nấu',
    'Nghiệp dư',
    'Đầu bếp tại gia',
    'Đầu bếp chuyên nghiệp',
    'Không chắc chắn'
  ];
  final countries = [
    'Việt Nam', 'Thái Lan', 'Nhật Bản', 'Hàn Quốc', 'Trung Quốc',
    'Pháp', 'Ý', 'Mỹ', 'Ấn Độ', 'Khác'
  ];

  @override
  void initState() {
    super.initState();
    // 1. Lấy dữ liệu hiện tại từ màn hình Profile
    final currentChef = ref.read(myChefProvider);

    // 2. Điền vào các Controller
    _nameController = TextEditingController(text: currentChef.name);

    // Xử lý Bio: Nếu bio là mặc định thì để trống cho người dùng nhập, ngược lại thì hiện bio cũ
    _bioController = TextEditingController(
        text: (currentChef.bio == "Mô tả mặc định...") ? "" : currentChef.bio
    );

    // 3. Xử lý Dropdown (Trình độ & Quốc gia)
    // Kiểm tra xem giá trị cũ có nằm trong danh sách không để tránh lỗi Crash
    if (levels.contains(currentChef.title)) {
      selectedLevel = currentChef.title;
    } else {
      selectedLevel = levels[2]; // Mặc định: Đầu bếp tại gia
    }

    if (countries.contains(currentChef.country)) {
      selectedCountry = currentChef.country!;
    } else {
      selectedCountry = countries[0]; // Mặc định: Việt Nam
    }

    // 4. Cập nhật state ban đầu cho editProfileProvider (để nút Lưu hoạt động đúng)
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final notifier = ref.read(editProfileProvider.notifier);
      notifier.updateName(_nameController.text);
      notifier.updateBio(_bioController.text);
      notifier.updateCookingLevel(selectedLevel);
      notifier.updateCountry(selectedCountry);
    });

    // 5. Lắng nghe thay đổi khi gõ phím
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
    // Watch state để cập nhật UI nếu cần thiết
    // final state = ref.watch(editProfileProvider);

    return Scaffold(
      backgroundColor: Colors.white,
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
                        backgroundColor: Colors.white70,
                        child: Icon(Icons.arrow_back_ios_new_rounded, size: 16.sp),
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
                    child: Text('Tên người dùng', style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.w500)),
                  ),
                  Text(' (*)', style: TextStyle(color: const Color(0xFFFF5959), fontSize: 13.sp)),
                ],
              ),
              SizedBox(height: 8.h),
              EditTextField(
                hintText: 'Nhập tên của bạn',
                controller: _nameController,
                maxLength: 30,
              ),
              SizedBox(height: 24.h),

              // Level Dropdown
              EditDropdownField(
                label: 'Trình độ',
                value: selectedLevel,
                items: levels,
                onChanged: (v) {
                  setState(() => selectedLevel = v!);
                  // Cập nhật Provider khi chọn
                  ref.read(editProfileProvider.notifier).updateCookingLevel(v!);
                },
              ),
              SizedBox(height: 24.h),

              // Bio Field
              EditTextField(
                label: 'Tiểu sử',
                hintText: 'Giới thiệu về bạn...',
                controller: _bioController,
                maxLines: 6,
                maxLength: 200,
              ),
              SizedBox(height: 24.h),

              // Country Dropdown
              EditDropdownField(
                label: 'Quốc gia',
                value: selectedCountry,
                items: countries,
                onChanged: (v) {
                  setState(() => selectedCountry = v!);
                  // Cập nhật Provider khi chọn
                  ref.read(editProfileProvider.notifier).updateCountry(v!);
                },
              ),
              SizedBox(height: 40.h),

              // Save Button Logic
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: EditSaveButton(
                  onPressed: () async {
                    // 1. Gọi API lưu lên Server
                    final success = await ref.read(editProfileProvider.notifier).save();

                    if (!mounted) return;

                    if (success) {
                      // 2. QUAN TRỌNG: Cập nhật lại dữ liệu dưới máy (Local State)
                      // Lấy dữ liệu vừa nhập xong
                      final editState = ref.read(editProfileProvider);

                      // Cập nhật vào surveyProvider (vì myChefProvider lắng nghe cái này)
                      // Lưu ý: Bạn cần import surveyProvider ở đầu file
                      ref.read(surveyProvider.notifier).updateUserData(
                        displayName: editState.name,
                        bio: editState.bio,
                        cookingTitle: editState.cookingLevel,
                        country: editState.country,
                      );

                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Đã lưu thành công!')),
                      );

                      Navigator.pop(context);
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Lỗi khi lưu hồ sơ')),
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