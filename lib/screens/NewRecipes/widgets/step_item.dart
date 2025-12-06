// lib/features/add_recipe/widgets/step_item.dart
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
  final ValueChanged<String>? onChanged;
  final VoidCallback? onDelete;

  const StepItem({
    Key? key,
    required this.index,
    required this.description,
    this.onChanged,
    this.onDelete,
  }) : super(key: key);

  // Hàm kiểm tra xem đường dẫn là video hay ảnh dựa vào đuôi file
  bool _isVideo(String path) {
    final ext = path.split('.').last.toLowerCase();
    return ['mp4', 'mov', 'avi', 'mkv'].contains(ext);
  }

  // Hiển thị lựa chọn: Ảnh hoặc Video
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
                  final picker = ImagePicker();
                  final pickedFile = await picker.pickImage(source: ImageSource.gallery);
                  if (pickedFile != null) {
                    // Lưu ý: Provider cần đổi tên hàm này thành updateStepMedia để hợp lý hơn
                    ref.read(addRecipeProvider.notifier).updateStepImage(index, pickedFile.path);
                  }
                },
              ),
              ListTile(
                leading: const Icon(Icons.videocam, color: Colors.red),
                title: Text('Chọn Video', style: TextStyle(color: isDark ? Colors.white : Colors.black)),
                onTap: () async {
                  Navigator.pop(ctx);
                  final picker = ImagePicker();
                  // Chọn video
                  final pickedFile = await picker.pickVideo(
                    source: ImageSource.gallery,
                    maxDuration: const Duration(minutes: 5), // Giới hạn độ dài nếu cần
                  );
                  if (pickedFile != null) {
                    ref.read(addRecipeProvider.notifier).updateStepImage(index, pickedFile.path);
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

    // Lấy đường dẫn file (ảnh hoặc video)
    final stepMediaPath = ref.watch(
      addRecipeProvider.select((s) => s.stepImages.length > index ? s.stepImages[index] : null),
    );

    final errorText = ref.watch(
      addRecipeProvider.select((s) => s.stepErrors.length > index ? s.stepErrors[index] : null),
    );

    final fieldBgColor = isDark ? const Color(0xFF2C2C2C) : const Color(0xFFEBEBEB);
    final fieldTextColor = isDark ? Colors.white : Colors.black87;
    final placeholderColor = isDark ? Colors.grey[500]! : Colors.grey.shade400;
    final primaryColor = const Color(0xFFFFB901);

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
                // Ô NHẬP TEXT
                Container(
                  decoration: BoxDecoration(
                    color: fieldBgColor,
                    borderRadius: BorderRadius.circular(20.r),
                    border: errorText != null ? Border.all(color: Colors.red, width: 1.5) : null,
                  ),
                  child: TextField(
                    controller: TextEditingController(text: description)
                      ..selection = TextSelection.fromPosition(TextPosition(offset: description.length)),
                    style: TextStyle(fontSize: 15.sp, color: fieldTextColor),
                    decoration: InputDecoration(
                      hintText: 'Mô tả chi tiết bước này...',
                      hintStyle: TextStyle(color: placeholderColor),
                      border: InputBorder.none,
                      isDense: true,
                      contentPadding: EdgeInsets.fromLTRB(16.w, 14.h, 16.w, 14.h),
                    ),
                    maxLines: null,
                    onChanged: onChanged,
                  ),
                ),

                if (errorText != null)
                  Padding(
                    padding: EdgeInsets.only(top: 6.h),
                    child: Text(errorText, style: TextStyle(color: Colors.red, fontSize: 12.sp)),
                  ),

                SizedBox(height: 12.h),

                // Ô MEDIA (ẢNH HOẶC VIDEO)
                GestureDetector(
                  onTap: () => _showMediaPicker(context, ref),
                  child: DottedBorder(
                    color: primaryColor,
                    strokeWidth: 2.5,
                    dashPattern: const [8, 5],
                    borderType: BorderType.RRect,
                    radius: Radius.circular(20.r),
                    child: Container(
                      width: 68.w,
                      height: 68.h,
                      decoration: BoxDecoration(
                        color: isDark ? const Color(0x33D4D4D4) : const Color(0x51D4D4D4),
                        borderRadius: BorderRadius.circular(20.r),
                      ),
                      child: stepMediaPath == null
                          ? Center(child: Icon(Icons.add_a_photo_outlined, size: 28.sp, color: primaryColor))
                          : Stack(
                        alignment: Alignment.center,
                        children: [
                          // Hiển thị nội dung
                          ClipRRect(
                            borderRadius: BorderRadius.circular(20.r),
                            child: _isVideo(stepMediaPath)
                                ? Container(
                              width: 68.w,
                              height: 68.h,
                              color: Colors.black, // Nền đen cho video
                              child: Center(
                                child: Icon(Icons.videocam, color: Colors.white, size: 30.sp),
                              ),
                            )
                                : Image.file(
                              File(stepMediaPath),
                              width: 68.w,
                              height: 68.h,
                              fit: BoxFit.cover,
                            ),
                          ),

                          // Icon Play nhỏ nếu là video (để dễ nhận biết)
                          if (_isVideo(stepMediaPath))
                            Container(
                              decoration: BoxDecoration(
                                color: Colors.black54,
                                shape: BoxShape.circle,
                              ),
                              padding: EdgeInsets.all(4.w),
                              child: Icon(Icons.play_arrow, color: primaryColor, size: 20.sp),
                            ),

                          // Nút xóa
                          Positioned(
                            top: 4,
                            right: 4,
                            child: GestureDetector(
                              onTap: () => ref.read(addRecipeProvider.notifier).clearStepImage(index),
                              child: Container(
                                padding: EdgeInsets.all(4.w),
                                decoration: const BoxDecoration(color: Colors.black54, shape: BoxShape.circle),
                                child: Icon(Icons.close, size: 14.sp, color: Colors.white),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          if (onDelete != null)
            IconButton(
              icon: Icon(Icons.close, size: 20.sp, color: isDark ? Colors.grey[400] : Colors.grey.shade600),
              onPressed: onDelete,
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
            ),
          SizedBox(width: 20.w),
        ],
      ),
    );
  }
}