// lib/features/add_recipe/screen/add_recipe_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'widgets/title_section.dart';
import 'logic/add_recipe_provider.dart';
import 'widgets/back_button.dart';
import 'widgets/image_gallery.dart';
import 'widgets/video_upload.dart';
import 'widgets/dropdown_row.dart';
import 'widgets/ingredient_item.dart';
import 'widgets/step_item.dart';
import 'widgets/bottom_buttons.dart';
import 'widgets/input_field.dart';

class AddRecipeScreen extends ConsumerWidget {
  const AddRecipeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(addRecipeProvider);
    final notifier = ref.read(addRecipeProvider.notifier);

    // FIX: Khai báo controller TRƯỚC khi dùng
    final nameController = TextEditingController(text: state.title);
    final descriptionController = TextEditingController(text: state.description);

    // Đồng bộ 2 chiều
    nameController.addListener(() => notifier.updateTitle(nameController.text));
    descriptionController.addListener(() => notifier.updateDescription(descriptionController.text));

    // Giữ text đồng bộ khi state thay đổi từ nơi khác
    ref.listen(addRecipeProvider, (_, next) {
      if (nameController.text != next.title) {
        nameController.text = next.title;
      }
      if (descriptionController.text != next.description) {
        descriptionController.text = next.description;
      }
    });

    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              children: [
                // HEADER CỐ ĐỊNH + POPUP KHI BẤM BACK
                Positioned(
                  child: Container(
                    color: Colors.white,
                    padding: EdgeInsets.fromLTRB(1.w, 1.h, 1.w, 1.h),
                    child: Stack(
                      children: [
                        Align(
                          alignment: Alignment.centerLeft,
                          child: BackButtonWidget(
                            onPressed: () async {
                              final shouldExit = await showDialog<bool>(
                                context: context,
                                barrierDismissible: false,
                                builder: (_) => AlertDialog(
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.r)),
                                  title: Row(
                                    children: [
                                      Icon(Icons.help_outline_rounded, color: Colors.orange, size: 28.sp),
                                      SizedBox(width: 1.w),
                                      Text('Thoát mà không lưu?', style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold)),
                                    ],
                                  ),
                                  content: Text('Bạn có muốn lưu công thức dưới dạng nháp trước khi thoát?', style: TextStyle(fontSize: 15.sp)),
                                  actions: [
                                    TextButton(
                                      onPressed: () => Navigator.pop(context, false),
                                      child: Text('Không lưu', style: TextStyle(color: Colors.grey[700])),
                                    ),
                                    TextButton(
                                      onPressed: () => Navigator.pop(context, null),
                                      child: Text('Hủy', style: TextStyle(color: const Color(0xFFFE724C), fontWeight: FontWeight.bold)),
                                    ),
                                    ElevatedButton(
                                      onPressed: () {
                                        // TODO: Gọi hàm lưu nháp ở đây sau
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          SnackBar(content: Text('Đã lưu nháp thành công!'), backgroundColor: Colors.green),
                                        );
                                        Navigator.pop(context, true);
                                      },
                                      style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFFE724C)),
                                      child: Text('Lưu nháp', style: TextStyle(color: Colors.white)),
                                    ),
                                  ],
                                ),
                              );

                              if (shouldExit == true) {
                                if (context.mounted) Navigator.of(context).pop();
                              }
                            },
                          ),
                        ),
                        const Center(child: TitleSection()),
                        SizedBox(width: 48.w),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    padding: EdgeInsets.only(bottom: 20.h),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [



                        // Nội dung giữ nguyên 100%
                        Padding(padding: EdgeInsets.symmetric(horizontal: 26.w, vertical: 1.h), child: Text('Thêm ảnh minh hoạ', style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.w600, color: Colors.black87))),
                        const ImageGallery(),
                        Padding(padding: EdgeInsets.symmetric(horizontal: 26.w, vertical: 1.h), child: Text('Thêm Video minh hoạ', style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.w600, color: Colors.black87))),
                        const VideoUpload(),

                        InputField(
                          label: 'Tên công thức',
                          hintText: 'Nhập tên công thức',
                          controller: nameController,
                          errorText: state.nameError,
                        ),
                        InputField(
                          label: 'Mô tả',
                          hintText: 'Chia sẻ với mọi người về món ăn này',
                          isMultiline: true,
                          controller: descriptionController,
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
                          errorText: state.servingsError,
                        ),
                        DropdownRow(
                          label: 'Độ khó',
                          value: state.difficulty,
                          items: const ['Dễ', 'Trung bình', 'Khó'],
                          onChanged: notifier.updateDifficulty,
                          errorText: state.servingsError,
                        ),

                        // Nguyên liệu
                        Padding(
                          padding: EdgeInsets.only(left: 36.w, top: 40.h),
                          child: Text('Nguyên liệu', style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w500)),
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
                              onDelete: () {
                                final newList = List<String>.from(state.ingredients)..removeAt(i);
                                notifier.state = notifier.state.copyWith(ingredients: newList);
                              },
                            );
                          }).toList()
                        else
                          Padding(
                            padding: EdgeInsets.only(left: 53.w, top: 16.h),
                            child: Text('Chưa có nguyên liệu nào',
                                style: TextStyle(fontSize: 15.sp, color: Colors.grey.shade500)),
                          ),

                        Padding(
                          padding: EdgeInsets.only(left: 53.w, top: 20.h),
                          child: GestureDetector(
                            onTap: notifier.addIngredient,
                            child: Text('+ Thêm nguyên liệu',
                                style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w500, color: const Color(0xFFFE724C))),
                          ),
                        ),

                        Padding(
                          padding: EdgeInsets.only(top: 40.h, bottom: 20.h),
                          child: Divider(height: 1.h, thickness: 0.8, color: Colors.grey.shade300, indent: 36.w, endIndent: 36.w),
                        ),

// Cách làm
                        Padding(
                          padding: EdgeInsets.only(left: 36.w, top: 50.h),
                          child: Text('Cách làm', style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w600)),
                        ),
                        if (state.steps.isNotEmpty)
                          ...state.steps.asMap().entries.map((e) {
                            final i = e.key;
                            final t = e.value;
                            return StepItem(
                              key: ValueKey('step_$i'),
                              index: i ,
                              description: t,
                              onChanged: (v) => notifier.updateStep(i, v),
                              onDelete: () => notifier.removeStep(i),
                            );
                          }).toList()
                        else
                          Padding(
                            padding: EdgeInsets.only(left: 57.w, top: 16.h),
                            child: Text('Chưa có bước nào',
                                style: TextStyle(fontSize: 15.sp, color: Colors.grey.shade500)),
                          ),

                        Padding(
                          padding: EdgeInsets.only(left: 57.w, top: 10.h, bottom: 40.h),
                          child: GestureDetector(
                            onTap: notifier.addStep,
                            child: Text('+ Thêm bước',
                                style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w500, color: const Color(0xFFFE724C))),
                          ),
                        ),

                        // Nút Đăng
                        Positioned(

                          child: GestureDetector(
                            onTapDown: (details) {
                              if (details.globalPosition.dx > MediaQuery.of(context).size.width / 2) {
                                notifier.validateAndSubmit(context);
                              }
                            },
                            child: BottomButtons(),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),


          ],
        ),
      ),
    );
  }
}