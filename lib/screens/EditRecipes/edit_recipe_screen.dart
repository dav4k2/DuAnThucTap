// lib/features/add_recipe/screen/edit_recipe_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fontend/screens/EditRecipes/widgets/edit_CategorySection.dart';

// --- IMPORTANT: Đảm bảo đường dẫn import đúng với nơi bạn lưu file ---
import '../Crete_recipe/logic/publish_recipe.dart';
import '../NewRecipes/logic/add_recipe_provider.dart';
import 'logic/edit_recipe_provider.dart';
import 'widgets/edit_back_button.dart';
import 'widgets/edit_title_section.dart';
import 'widgets/edit_image_gallery.dart';
import 'widgets/edit_video_upload.dart';
import 'widgets/edit_input_field.dart';
import 'widgets/edit_dropdown_row.dart';
import 'widgets/edit_ingredient_item.dart';
import 'widgets/edit_step_item.dart';


class EditAddRecipeScreen extends ConsumerStatefulWidget {
  final PublishRecipe originalRecipe;

  const EditAddRecipeScreen({Key? key, required this.originalRecipe}) : super(key: key);

  @override
  ConsumerState<EditAddRecipeScreen> createState() => _EditAddRecipeScreenState();
}

class _EditAddRecipeScreenState extends ConsumerState<EditAddRecipeScreen> {

  @override
  void initState() {
    super.initState();
    // Gọi hàm init dữ liệu 1 lần duy nhất khi vào màn hình
    // Sử dụng WidgetsBinding để đảm bảo build xong mới update state
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(editRecipeProvider.notifier).initializeData(widget.originalRecipe);
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(editRecipeProvider);
    final notifier = ref.read(editRecipeProvider.notifier);

    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final bgColor = isDark ? const Color(0xFF121212) : Colors.white;
    final subtitleColor = isDark ? Colors.grey[400]! : Colors.grey.shade700;
    final borderColor = isDark ? Colors.grey.shade700 : Colors.grey.shade300;
    final sectionTitleColor = isDark ? Colors.white : Colors.black87;

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: bgColor,
        resizeToAvoidBottomInset: true,
        body: SafeArea(
          child: Column(
            children: [
              // ===================== HEADER =====================
              Container(
                color: bgColor,
                padding: EdgeInsets.fromLTRB(16.w, 8.h, 16.w, 8.h),
                child: Stack(
                  children: [
                    Align(
                      alignment: Alignment.centerLeft,
                      child: EditBackButtonWidget(
                        onPressed: () => notifier.handleBackPressed(context),
                      ),
                    ),
                    const Center(child: EditTitleSection()),
                    SizedBox(width: 48.w),
                  ],
                ),
              ),

              // ===================== BODY =====================
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Thêm ảnh minh hoạ
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 26.w, vertical: 12.h),
                        child: Text(
                          'Thêm ảnh minh hoạ',
                          style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.w600, color: sectionTitleColor),
                        ),
                      ),
                      const EditImageGallery(),

                      // Thêm Video minh hoạ
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 26.w, vertical: 12.h),
                        child: Text(
                          'Thêm Video minh hoạ',
                          style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.w600, color: sectionTitleColor),
                        ),
                      ),
                      const EditVideoUpload(),

                      // Các Input Field
                      EditInputField(
                        label: 'Tên công thức',
                        hintText: 'Nhập tên công thức',
                        initialValue: state.title,
                        onChanged: notifier.updateTitle,
                        errorText: state.nameError,
                      ),
                      EditInputField(
                        label: 'Mô tả',
                        hintText: 'Chia sẻ với mọi người về món ăn này',
                        isMultiline: true,
                        initialValue: state.description,
                        onChanged: notifier.updateDescription,
                        errorText: state.descriptionError,
                      ),
                      EditDropdownRow(
                        label: 'Khẩu phần',
                        value: state.servings,
                        items: const ['1 người', '2 người', '3-4 người', '5-6 người', '7+ người'],
                        onChanged: notifier.updateServings,
                        errorText: state.servingsError,
                      ),
                      EditDropdownRow(
                        label: 'Thời gian nấu',
                        value: state.cookingTime,
                        items: const ['Dưới 15 phút', '15-30 phút', '30-60 phút', 'Trên 1 tiếng'],
                        onChanged: notifier.updateCookingTime,
                        errorText: state.cookingTimeError,
                      ),
                      EditDropdownRow(
                        label: 'Độ khó',
                        value: state.difficulty,
                        items: const ['Dễ', 'Trung bình', 'Khó'],
                        onChanged: notifier.updateDifficulty,
                        errorText: state.difficultyError,
                      ),

                      const EditCategorySection(),

                      // ===================== NGUYÊN LIỆU =====================
                      Padding(
                        padding: EdgeInsets.only(left: 36.w, top: 40.h),
                        child: Text(
                          'Nguyên liệu',
                          style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w500, color: sectionTitleColor),
                        ),
                      ),
                      if (state.ingredients.isNotEmpty)
                        ...state.ingredients.asMap().entries.map((e) {
                          final i = e.key;
                          final t = e.value;
                          return EditIngredientItem(
                            key: ValueKey('ingredient_$i'),
                            index: i,
                            text: t,
                            onChanged: (v) => notifier.updateIngredient(i, v),
                            onDelete: () => notifier.state = notifier.state.copyWith(
                              ingredients: List<String>.from(state.ingredients)..removeAt(i),
                              ingredientErrors: List<String?>.from(state.ingredientErrors)..removeAt(i),
                            ),
                          );
                        })
                      else
                        Padding(
                          padding: EdgeInsets.only(left: 53.w, top: 16.h),
                          child: Text(
                            'Chưa có nguyên liệu nào',
                            style: TextStyle(fontSize: 15.sp, color: subtitleColor),
                          ),
                        ),
                      Padding(
                        padding: EdgeInsets.only(left: 53.w, top: 20.h),
                        child: GestureDetector(
                          onTap: notifier.addIngredient,
                          child: Text(
                            '+ Thêm nguyên liệu',
                            style: TextStyle(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w500,
                              color: const Color(0xFFFE724C),
                            ),
                          ),
                        ),
                      ),

                      Padding(
                        padding: EdgeInsets.only(top: 40.h, bottom: 20.h),
                        child: Divider(
                          height: 1.h,
                          thickness: 0.8,
                          color: borderColor,
                          indent: 36.w,
                          endIndent: 36.w,
                        ),
                      ),

                      // ===================== CÁCH LÀM =====================
                      Padding(
                        padding: EdgeInsets.only(left: 36.w, top: 50.h),
                        child: Text(
                          'Cách làm',
                          style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w600, color: sectionTitleColor),
                        ),
                      ),
                      if (state.steps.isNotEmpty)
                        ...state.steps.asMap().entries.map((e) {
                          final i = e.key;
                          final stepModel = e.value;

                          return EditStepItem(
                            key: ValueKey('step_$i'),
                            index: i,
                            description: stepModel.content,
                            duration: stepModel.duration,
                            mediaPaths: stepModel.media,
                            onChanged: (v) => notifier.updateStep(i, v),
                            onDelete: () => notifier.removeStep(i),
                          );
                        })
                      else
                        Padding(
                          padding: EdgeInsets.only(left: 57.w, top: 16.h),
                          child: Text(
                            'Chưa có bước nào',
                            style: TextStyle(fontSize: 15.sp, color: subtitleColor),
                          ),
                        ),
                      Padding(
                        padding: EdgeInsets.only(left: 57.w, top: 10.h, bottom: 40.h),
                        child: GestureDetector(
                          onTap: notifier.addStep,
                          child: Text(
                            '+ Thêm bước',
                            style: TextStyle(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w500,
                              color: const Color(0xFFFE724C),
                            ),
                          ),
                        ),
                      ),
                      // ===================== BUTTON LƯU (SỬA LOGIC) =====================
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 26.w, vertical: 30.h),
                        child: Row(
                          children: [
                            Expanded(
                              child: GestureDetector(
                                onTap: () async {
                                  // 1. Hiện loading (nếu cần)
                                  showDialog(
                                      context: context,
                                      barrierDismissible: false,
                                      builder: (c) => const Center(child: CircularProgressIndicator())
                                  );

                                  // 2. Gọi hàm update từ notifier (KHÔNG TRUYỀN CONTEXT)
                                  final errorMsg = await notifier.validateAndUpdate();

                                  // 3. Đóng loading dialog
                                  if (context.mounted) Navigator.pop(context);

                                  // 4. Kiểm tra kết quả (Context safe)
                                  if (!context.mounted) return;

                                  if (errorMsg == null) {
                                    // THÀNH CÔNG
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(content: Text('Cập nhật thành công!'), backgroundColor: Colors.green),
                                    );
                                    Navigator.pop(context); // Thoát màn hình Edit
                                  } else {
                                    // THẤT BẠI HOẶC LỖI VALIDATE
                                    // Kiểm tra xem lỗi là do thiếu thông tin hay lỗi hệ thống
                                    // Ở đây hiển thị đơn giản bằng SnackBar hoặc Dialog
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(content: Text(errorMsg), backgroundColor: Colors.red),
                                    );
                                  }
                                },
                                child: Container(
                                  height: 66.h,
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFFE724C), // Màu cam nổi bật
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Center(
                                    child: Text(
                                      'Lưu thay đổi',
                                      style: TextStyle(
                                        fontSize: 18.sp,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}