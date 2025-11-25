

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

class AddRecipeScreen extends ConsumerStatefulWidget {
  const AddRecipeScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<AddRecipeScreen> createState() => _AddRecipeScreenState();
}

class _AddRecipeScreenState extends ConsumerState<AddRecipeScreen> {
  late final TextEditingController nameController;
  late final TextEditingController descriptionController;

  @override
  void initState() {
    super.initState();
    final state = ref.read(addRecipeProvider);
    nameController = TextEditingController(text: state.title);
    descriptionController = TextEditingController(text: state.description);

    nameController.addListener(() {
      ref.read(addRecipeProvider.notifier).updateTitle(nameController.text);
    });
    descriptionController.addListener(() {
      ref.read(addRecipeProvider.notifier).updateDescription(descriptionController.text);
    });
  }

  @override
  void dispose() {
    nameController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(addRecipeProvider);

    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: Column(
          children: [
            // ==================== PHẦN CUỘN ĐƯỢC ====================
            Expanded(
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: EdgeInsets.only(bottom: 10.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // THAY TOÀN BỘ PHẦN NÀY – NÚT BACK + TITLE CÙNG HÀNG, ĐẸP HOÀN HẢO
                    Padding(
                      padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 16.h),
                      child: Stack(
                        children: [
                          Align(
                            alignment: Alignment.centerLeft,
                            child: const BackButtonWidget(),
                          ),
                          const Center(
                            child: TitleSection(),
                          ),
                          SizedBox(width: 48.w),
                        ],
                      ),
                    ),

                    Padding(padding: EdgeInsets.symmetric(horizontal: 26.w, vertical: 1.h), child: Text('Thêm ảnh minh hoạ', style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.w600, color: Colors.black87,),),),

                    const ImageGallery(),

                    Padding(padding: EdgeInsets.symmetric(horizontal: 26.w, vertical: 1.h), child: Text('Thêm Video minh hoạ', style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.w600, color: Colors.black87,),),),


                    const VideoUpload(),

                    // 5. InputField tên công thức
                     InputField(
                      label: 'Tên công thức',
                      hintText: 'Nhập tên công thức',
                      controller: nameController,
                     ),

                    // 6. InputField mô tả
                     InputField(
                       label: 'Mô tả',
                       hintText: 'Chia sẻ với mọi người về món ăn này',
                       isMultiline: true,
                       controller: descriptionController,
                     ),

                    // 7–9. 3 Dropdown
                    DropdownRow(
                      label: 'Khẩu phần',
                      value: state.servings,
                      items: const ['1 người', '2 người', '3-4 người', '5-6 người', '7+ người'],
                      onChanged: (val) => ref.read(addRecipeProvider.notifier).updateServings(val ?? '2 người'),
                    ),

                    DropdownRow(
                      label: 'Thời gian nấu',
                      value: state.cookingTime,
                      items: const ['Dưới 15 phút', '15-30 phút', '30-60 phút', 'Trên 1 tiếng'],
                      onChanged: (val) => ref.read(addRecipeProvider.notifier).updateCookingTime(val ?? '30 phút'),
                    ),

                    DropdownRow(
                      label: 'Độ khó',
                      value: state.difficulty,
                      items: const ['Dễ', 'Trung bình', 'Khó'],
                      onChanged: (val) => ref.read(addRecipeProvider.notifier).updateDifficulty(val ?? 'Dễ'),
                    ),

                    // 10. Tiêu đề Nguyên liệu + danh sách
                     Padding(
                       padding: EdgeInsets.only(left: 36.w, top: 40.h),
                       child: Text('Nguyên liệu', style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w500)),
                     ),

                    if (state.ingredients.isNotEmpty)
                      ...state.ingredients.asMap().entries.map((entry) {
                        final index = entry.key;
                        final text = entry.value;
                        return IngredientItem(
                          key: ValueKey('ingredient_$index'),
                          text: text,
                          onChanged: (newText) {
                            ref.read(addRecipeProvider.notifier).updateIngredient(index, newText);
                          },
                          onDelete: () {
                            final newList = List<String>.from(state.ingredients)..removeAt(index);
                            ref.read(addRecipeProvider.notifier).state =
                                ref.read(addRecipeProvider.notifier).state.copyWith(ingredients: newList);
                          },
                        );
                      }).toList()
                    else
                      Padding(
                        padding: EdgeInsets.only(left: 53.w, top: 16.h),
                        child: Text(
                          'Chưa có nguyên liệu nào',
                          style: TextStyle(fontSize: 15.sp, color: Colors.grey.shade500, fontStyle: FontStyle.italic),
                        ),
                      ),

                     Padding(
                       padding: EdgeInsets.only(left: 53.w, top: 20.h),
                      child: GestureDetector(
                        onTap: () => ref.read(addRecipeProvider.notifier).addIngredient(),
                        child: Text('+ Thêm nguyên liệu', style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w500, color: const Color(0xFFFE724C))),
                       ),
                     ),

                    Padding(
                      padding: EdgeInsets.only(top: 40.h, bottom: 20.h),
                      child: Divider(
                        height: 1.h,
                        thickness: 0.8,
                        color: Colors.grey.shade300,
                        indent: 36.w,
                        endIndent: 36.w,
                      ),
                    ),

                    // 11. PHẦN CÁCH LÀM – ĐÃ SỬA HOÀN HẢO, GIỐNG NGUYÊN LIỆU, KHÔNG LỖI, SỐ BẮT ĐẦU TỪ 1
                    Padding(
                      padding: EdgeInsets.only(left: 36.w, top: 50.h),
                      child: Text(
                        'Cách làm',
                        style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w600),
                      ),
                    ),

                    // Danh sách các bước – an toàn dù rỗng
                    if (state.steps.isNotEmpty)
                      ...state.steps.asMap().entries.map((entry) {
                        final index = entry.key;
                        final text = entry.value;
                        return StepItem(
                          key: ValueKey('step_$index'),
                          index: index + 1, // Bắt đầu từ 1
                          description: text,
                          onChanged: (newText) {
                            ref.read(addRecipeProvider.notifier).updateStep(index, newText);
                          },
                          onDelete: () {
                            final newList = List<String>.from(state.steps)..removeAt(index);
                            ref.read(addRecipeProvider.notifier).state =
                                ref.read(addRecipeProvider.notifier).state.copyWith(steps: newList);
                          },
                        );
                      }).toList()
                    else
                      Padding(
                        padding: EdgeInsets.only(left: 57.w, top: 16.h),
                        child: Text(
                          'Chưa có bước nào',
                          style: TextStyle(fontSize: 15.sp, color: Colors.grey.shade500, fontStyle: FontStyle.italic),
                        ),
                      ),

                    // Nút thêm bước mới
                    Padding(
                      padding: EdgeInsets.only(left: 57.w, top: 10.h, bottom: 40.h),
                      child: GestureDetector(
                        onTap: () => ref.read(addRecipeProvider.notifier).addStep(),
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

                    Positioned(
                      bottom: 20.h,
                      left: 0,
                      right: 0,
                      child: BottomButtons(),
                    ),



                  ],
                ),
              ),
            ),


          ],
        ),
      ),
    );
  }
}