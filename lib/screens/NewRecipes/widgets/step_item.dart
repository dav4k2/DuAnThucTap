import 'dart:io';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import '../logic/add_recipe_provider.dart';

class StepItem extends ConsumerWidget {
  final int index;
  final String description;
  final String? duration;
  final List<String> mediaPaths;
  final ValueChanged<String>? onChanged;
  final VoidCallback? onDelete;

  const StepItem({
    Key? key,
    required this.index,
    required this.description,
    required this.mediaPaths,
    this.duration,
    this.onChanged,
    this.onDelete,
  }) : super(key: key);

  bool _isVideo(String path) {
    final ext = path.split('.').last.toLowerCase();
    return ['mp4', 'mov', 'avi', 'mkv'].contains(ext);
  }

  void _showMediaPicker(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    showModalBottomSheet(
      context: context,
      backgroundColor: isDark ? const Color(0xFF1E1E1E) : Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20.r))),
      builder: (ctx) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.image, color: Colors.blue),
                title: Text('Chọn Ảnh', style: TextStyle(color: isDark ? Colors.white : Colors.black)),
                onTap: () async {
                  Navigator.pop(ctx);
                  final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
                  if (pickedFile != null) {
                    ref.read(addRecipeProvider.notifier).addStepMedia(index, pickedFile.path);
                  }
                },
              ),
              ListTile(
                leading: const Icon(Icons.videocam, color: Colors.red),
                title: Text('Chọn Video', style: TextStyle(color: isDark ? Colors.white : Colors.black)),
                onTap: () async {
                  Navigator.pop(ctx);
                  final pickedFile = await ImagePicker().pickVideo(source: ImageSource.gallery, maxDuration: const Duration(minutes: 5));
                  if (pickedFile != null) {
                    ref.read(addRecipeProvider.notifier).addStepMedia(index, pickedFile.path);
                  }
                },
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final errorText = ref.watch(addRecipeProvider.select((s) => s.stepErrors.length > index ? s.stepErrors[index] : null));

    final fieldBgColor = isDark ? const Color(0xFF2C2C2C) : const Color(0xFFEBEBEB);
    final fieldTextColor = isDark ? Colors.white : Colors.black87;
    final primaryColor = const Color(0xFFFFB901);

    // Danh sách các phút từ 1 đến 60
    final List<String> minuteOptions = List.generate(60, (i) => '${i + 1} phút');

    return Padding(
      padding: EdgeInsets.only(top: 30.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(width: 15.w),
          Text('${index + 1}', style: TextStyle(fontSize: 24.sp, fontWeight: FontWeight.bold, color: fieldTextColor)),
          SizedBox(width: 20.w),
          Container(width: 3.w, height: 46.h, color: const Color(0xFF21DB53)),
          SizedBox(width: 20.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Ô NHẬP TEXT MÔ TẢ
                    Expanded(
                      flex: 3,
                      child: Container(
                        decoration: BoxDecoration(
                          color: fieldBgColor,
                          borderRadius: BorderRadius.circular(15.r),
                          border: errorText != null ? Border.all(color: Colors.red, width: 1.5) : null,
                        ),
                        child: TextField(
                          controller: TextEditingController(text: description)
                            ..selection = TextSelection.fromPosition(TextPosition(offset: description.length)),
                          style: TextStyle(fontSize: 14.sp, color: fieldTextColor),
                          decoration: InputDecoration(
                            hintText: 'Mô tả bước...',
                            hintStyle: TextStyle(color: Colors.grey, fontSize: 13.sp),
                            border: InputBorder.none,
                            isDense: true,
                            contentPadding: EdgeInsets.all(12.w),
                          ),
                          maxLines: null,
                          onChanged: onChanged,
                        ),
                      ),
                    ),
                    SizedBox(width: 8.w),
                    // DROPBOX CHỌN PHÚT
                    Expanded(
                      flex: 2,
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 8.w),
                        decoration: BoxDecoration(
                          color: fieldBgColor,
                          borderRadius: BorderRadius.circular(15.r),
                        ),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            value: duration,
                            hint: Text('Phút', style: TextStyle(fontSize: 12.sp, color: Colors.grey)),
                            isExpanded: true,
                            items: minuteOptions.map((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value, style: TextStyle(fontSize: 13.sp, color: fieldTextColor)),
                              );
                            }).toList(),
                            onChanged: (val) => ref.read(addRecipeProvider.notifier).updateStepDuration(index, val),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),

                if (errorText != null)
                  Padding(
                    padding: EdgeInsets.only(top: 4.h),
                    child: Text(errorText, style: TextStyle(color: Colors.red, fontSize: 11.sp)),
                  ),

                SizedBox(height: 12.h),

                // GALLERY MEDIA (ẢNH/VIDEO)
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      ...mediaPaths.asMap().entries.map((entry) {
                        int mediaIdx = entry.key;
                        String path = entry.value;
                        return Padding(
                          padding: EdgeInsets.only(right: 10.w),
                          child: Stack(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(15.r),
                                child: _isVideo(path)
                                    ? Container(
                                  width: 60.w,
                                  height: 60.h,
                                  color: Colors.black,
                                  child: Icon(Icons.videocam, color: Colors.white, size: 24.sp),
                                )
                                    : Image.file(File(path), width: 60.w, height: 60.h, fit: BoxFit.cover),
                              ),
                              Positioned(
                                top: 2,
                                right: 2,
                                child: GestureDetector(
                                  onTap: () => ref.read(addRecipeProvider.notifier).removeStepMedia(index, mediaIdx),
                                  child: Container(
                                    decoration: const BoxDecoration(color: Colors.black54, shape: BoxShape.circle),
                                    child: Icon(Icons.close, size: 14.sp, color: Colors.white),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      }),

                      // NÚT THÊM TIẾP
                      GestureDetector(
                        onTap: () => _showMediaPicker(context, ref),
                        child: DottedBorder(
                          color: primaryColor,
                          strokeWidth: 2,
                          dashPattern: const [5, 3],
                          borderType: BorderType.RRect,
                          radius: Radius.circular(15.r),
                          child: Container(
                            width: 60.w,
                            height: 60.h,
                            decoration: BoxDecoration(
                              color: isDark ? const Color(0x33D4D4D4) : const Color(0x51D4D4D4),
                              borderRadius: BorderRadius.circular(15.r),
                            ),
                            child: Icon(Icons.add_a_photo_outlined, size: 22.sp, color: primaryColor),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          if (onDelete != null)
            IconButton(
              icon: Icon(Icons.close, size: 20.sp, color: Colors.grey),
              onPressed: onDelete,
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
            ),
          SizedBox(width: 15.w),
        ],
      ),
    );
  }
}