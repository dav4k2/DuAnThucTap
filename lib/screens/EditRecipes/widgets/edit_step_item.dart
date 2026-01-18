import 'dart:io';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import '../../NewRecipes/logic/add_recipe_provider.dart';

class EditStepItem extends ConsumerStatefulWidget {
  final int index;
  final String description;
  final String? duration;
  final List<String> mediaPaths;
  final ValueChanged<String>? onChanged;
  final VoidCallback? onDelete;

  const EditStepItem({
    Key? key,
    required this.index,
    required this.description,
    required this.mediaPaths,
    this.duration,
    this.onChanged,
    this.onDelete,
  }) : super(key: key);

  @override
  ConsumerState<EditStepItem> createState() => _EditStepItemState();
}

class _EditStepItemState extends ConsumerState<EditStepItem> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.description);
  }

  @override
  void didUpdateWidget(EditStepItem oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.description != _controller.text) {
      _controller.text = widget.description;
      _controller.selection = TextSelection.fromPosition(TextPosition(offset: _controller.text.length));
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  bool _isVideo(String path) {
    // Kiểm tra đơn giản đuôi file
    final ext = path.split('.').last.toLowerCase();
    // Lưu ý: Nếu là URL có query param (vd: video.mp4?token=...), logic này có thể cần cải thiện
    // Nhưng tạm thời ổn với path file local và url đơn giản
    return ['mp4', 'mov', 'avi', 'mkv'].contains(ext);
  }

  void _showMediaPicker(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
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
                    ref.read(addRecipeProvider.notifier).addStepMedia(widget.index, pickedFile.path);
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
                    ref.read(addRecipeProvider.notifier).addStepMedia(widget.index, pickedFile.path);
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
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final errorText = ref.watch(addRecipeProvider.select(
            (s) => (s.stepErrors.length > widget.index) ? s.stepErrors[widget.index] : null
    ));
    final fieldBgColor = isDark ? const Color(0xFF2C2C2C) : const Color(0xFFEBEBEB);
    final fieldTextColor = isDark ? Colors.white : Colors.black87;
    final primaryColor = const Color(0xFFFFB901);

    final List<String> minuteOptions = List.generate(60, (i) => '${i + 1} phút');

    // --- FIX LỖI DROPDOWN VALUE ---
    // Kiểm tra xem giá trị hiện tại (widget.duration) có nằm trong danh sách minuteOptions không.
    // Nếu không khớp (do định dạng cũ, hoặc null), gán về null để hiển thị Hint "Phút"
    String? safeDuration;
    if (widget.duration != null && minuteOptions.contains(widget.duration)) {
      safeDuration = widget.duration;
    }
    // -----------------------------

    return Padding(
      padding: EdgeInsets.only(top: 30.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(width: 15.w),
          Text('${widget.index + 1}', style: TextStyle(fontSize: 24.sp, fontWeight: FontWeight.bold, color: fieldTextColor)),
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
                    Expanded(
                      flex: 3,
                      child: Container(
                        decoration: BoxDecoration(
                          color: fieldBgColor,
                          borderRadius: BorderRadius.circular(15.r),
                          border: errorText != null ? Border.all(color: Colors.red, width: 1.5) : null,
                        ),
                        child: TextField(
                          controller: _controller,
                          style: TextStyle(fontSize: 14.sp, color: fieldTextColor),
                          decoration: InputDecoration(
                            hintText: 'Mô tả bước...',
                            hintStyle: TextStyle(color: Colors.grey, fontSize: 13.sp),
                            border: InputBorder.none,
                            isDense: true,
                            contentPadding: EdgeInsets.all(12.w),
                          ),
                          maxLines: null,
                          onChanged: widget.onChanged,
                        ),
                      ),
                    ),
                    SizedBox(width: 8.w),
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
                            value: safeDuration, // Sử dụng giá trị đã kiểm tra an toàn
                            hint: Text('Phút', style: TextStyle(fontSize: 12.sp, color: Colors.grey)),
                            isExpanded: true,
                            items: minuteOptions.map((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value, style: TextStyle(fontSize: 13.sp, color: fieldTextColor)),
                              );
                            }).toList(),
                            onChanged: (val) => ref.read(addRecipeProvider.notifier).updateStepDuration(widget.index, val),
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
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      ...widget.mediaPaths.asMap().entries.map((entry) {
                        int mediaIdx = entry.key;
                        String path = entry.value;

                        // --- FIX HIỂN THỊ ẢNH ---
                        // Kiểm tra xem path là URL (ảnh cũ) hay File Path (ảnh mới)
                        bool isNetworkImage = path.startsWith('http');

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
                                // Logic hiển thị ảnh:
                                    : (isNetworkImage
                                    ? Image.network(path, width: 60.w, height: 60.h, fit: BoxFit.cover)
                                    : Image.file(File(path), width: 60.w, height: 60.h, fit: BoxFit.cover)),
                              ),
                              Positioned(
                                top: 2,
                                right: 2,
                                child: GestureDetector(
                                  onTap: () => ref.read(addRecipeProvider.notifier).removeStepMedia(widget.index, mediaIdx),
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
                      GestureDetector(
                        onTap: () => _showMediaPicker(context),
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
          if (widget.onDelete != null)
            IconButton(
              icon: Icon(Icons.close, size: 20.sp, color: Colors.grey),
              onPressed: widget.onDelete,
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
            ),
          SizedBox(width: 15.w),
        ],
      ),
    );
  }
}