import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class EditDropdownField extends StatelessWidget {
  final String label;
  final String value;
  final List<String> items;
  final ValueChanged<String?> onChanged;

  const EditDropdownField({
    super.key,
    required this.label,
    required this.value,
    required this.items,
    required this.onChanged,
  });

  void _showItemPicker(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    String selectedItem = value;

    // Màu sắc cho modal bottom sheet
    final sheetBackground = isDark ? Colors.grey[850]! : Colors.white;
    final dividerColor = isDark ? Colors.grey[700]! : Colors.grey.shade200;
    final titleColor = isDark ? Colors.white : Colors.black;
    final doneColor = Colors.blue;
    final pickerTextColor = isDark ? Colors.white : Colors.black;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext builder) {
        return Container(
          height: 300.h,
          decoration: BoxDecoration(
            color: sheetBackground,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20.r),
              topRight: Radius.circular(20.r),
            ),
          ),
          child: Column(
            children: [
              // Thanh tiêu đề và nút Done
              Container(
                decoration: BoxDecoration(
                  border: Border(bottom: BorderSide(color: dividerColor)),
                ),
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      label,
                      style: TextStyle(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.bold,
                        color: titleColor,
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        onChanged(selectedItem);
                        Navigator.pop(context);
                      },
                      child: Text(
                        'Xong'.tr(),
                        style: TextStyle(
                          fontSize: 18.sp,
                          fontWeight: FontWeight.bold,
                          color: doneColor,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Cupertino Picker
              Expanded(
                child: CupertinoPicker(
                  magnification: 1.2,
                  squeeze: 1.0,
                  itemExtent: 40.h,
                  scrollController: FixedExtentScrollController(
                    initialItem: items.indexOf(value),
                  ),
                  onSelectedItemChanged: (int index) {
                    selectedItem = items[index];
                  },
                  children: items.map((item) {
                    return Center(
                      child: Text(
                        item,
                        style: TextStyle(
                          fontSize: 20.sp,
                          color: pickerTextColor,
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    // Màu sắc cho phần hiển thị dropdown
    final containerBg = isDark ? Colors.grey[800]! : const Color(0xFFEBEBEB);
    final borderColor = isDark ? Colors.white.withOpacity(0.4) : Colors.grey.shade400;
    final labelColor = isDark ? Colors.white : Colors.black;
    final valueTextColor = isDark ? Colors.white : Colors.black;
    final arrowColor = isDark ? Colors.white70 : Colors.grey.shade600;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(left: 17.w, bottom: 8.h),
          child: Text(
            label,
            style: TextStyle(
              fontSize: 20.sp,
              fontWeight: FontWeight.w500,
              color: labelColor,
            ),
          ),
        ),

        GestureDetector(
          onTap: () => _showItemPicker(context),
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: 10.w),
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
            decoration: BoxDecoration(
              color: containerBg,
              borderRadius: BorderRadius.circular(10.r),
              border: Border.all(color: borderColor, width: 1.w),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 16.sp,
                    color: valueTextColor,
                  ),
                ),
                Icon(
                  Icons.keyboard_arrow_down,
                  size: 24.sp,
                  color: arrowColor,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}