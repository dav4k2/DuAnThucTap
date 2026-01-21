// lib/features/add_recipe/screen/add_recipe_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fontend/screens/NewRecipes/widgets/CategorySection.dart';

import '../Crete_recipe/create_recipe_screen.dart';
import 'widgets/title_section.dart';
import 'logic/add_recipe_provider.dart';
import 'widgets/back_button.dart';
import 'widgets/image_gallery.dart';
import 'widgets/video_upload.dart';
import 'widgets/dropdown_row.dart';
import 'widgets/ingredient_item.dart';
import 'widgets/step_item.dart';
import 'widgets/input_field.dart';

class AddRecipeScreen extends ConsumerWidget {
  const AddRecipeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(addRecipeProvider);
    final notifier = ref.read(addRecipeProvider.notifier);

    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final bgColor = isDark ? const Color(0xFF121212) : Colors.white;
    final subtitleColor = isDark ? Colors.grey[400]! : Colors.grey.shade700;
    final borderColor = isDark ? Colors.grey.shade700 : Colors.grey.shade300;
    final sectionTitleColor = isDark ? Colors.white : Colors.black87;

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
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
                      child: BackButtonWidget(
                        onPressed: () => notifier.handleBackPressed(context),
                      ),
                    ),
                    const Center(child: TitleSection()),
                    SizedBox(width: 48.w),
                  ],
                ),
              ),

              // ===================== BODY =====================
              Expanded(
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: EdgeInsets.zero,
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
                      const ImageGallery(),



                      // Các Input Field
                      InputField(
                        label: 'Tên công thức',
                        hintText: 'Nhập tên công thức',
                        initialValue: state.title,
                        onChanged: notifier.updateTitle,
                        errorText: state.nameError,
                      ),
                      InputField(
                        label: 'Mô tả',
                        hintText: 'Chia sẻ với mọi người về món ăn này',
                        isMultiline: true,
                        initialValue: state.description,
                        onChanged: notifier.updateDescription,
                        errorText: state.descriptionError,
                      ),
                      DropdownRow(
                        label: 'Khẩu phần',
                        value: state.servings,
                        items: const ['1 người', '2 người', '3-4 người', '5-6 người', '7+ người'],
                        onChanged: notifier.updateServings,
                        errorText: state.servingsError,
                      ),
                      DropdownRow(
                        label: 'Thời gian nấu',
                        value: state.cookingTime,
                        items: const ['Dưới 15 phút', '15-30 phút', '30-60 phút', 'Trên 1 tiếng'],
                        onChanged: notifier.updateCookingTime,
                        errorText: state.cookingTimeError,
                      ),
                      DropdownRow(
                        label: 'Độ khó',
                        value: state.difficulty,
                        items: const ['Dễ', 'Trung bình', 'Khó'],
                        onChanged: notifier.updateDifficulty,
                        errorText: state.difficultyError,
                      ),

                      const CategorySection(),

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
                          return IngredientItem(
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
                          final stepModel = e.value; // Bây giờ là RecipeStepModel

                          return StepItem(
                            key: ValueKey('step_$i'),
                            index: i,
                            // Lấy dữ liệu từ Model thay vì các list rời rạc
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

                      // ===================== BOTTOM BUTTONS =====================
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 26.w),
                        child: Row(
                          children: [
                            Expanded(
                              child: GestureDetector(
                                onTap: () async {
                                  // 1. Gọi hàm lưu nháp từ notifier
                                  final success = await notifier.saveAsDraft(context);

                                  // 2. Nếu lưu thành công, thực hiện nhảy trang
                                  if (success && context.mounted) {
                                    Navigator.pop(context);
                                  }
                                },
                                child: Container(
                                  height: 66.h,
                                  decoration: BoxDecoration(
                                    color: isDark ? Colors.grey.shade800 : Colors.grey.shade200,
                                    borderRadius: BorderRadius.circular(20),
                                    border: Border.all(color: isDark ? Colors.white : Colors.black, width: 1.5),
                                  ),
                                  child: Center(
                                    child: Text(
                                      'Lưu nháp',
                                      style: TextStyle(
                                        fontSize: 24.sp,
                                        fontWeight: FontWeight.w600,
                                        color: isDark ? Colors.white70 : Colors.black87,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(width: 12.w),
                            Expanded(
                              child: GestureDetector(
                                onTap: () => notifier.validateAndPublish(context),
                                child: Container(
                                  height: 66.h,
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFFFB901),
                                    borderRadius: BorderRadius.circular(20),
                                    border: Border.all(color: isDark ? Colors.white : Colors.black, width: 1.5),
                                  ),
                                  child: Center(
                                    child: Text(
                                      'Đăng',
                                      style: TextStyle(
                                        fontSize: 24.sp,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      SizedBox(height: 30.h),
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