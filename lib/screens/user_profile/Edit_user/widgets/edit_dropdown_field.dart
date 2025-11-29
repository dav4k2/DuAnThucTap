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

  // Hàm hiển thị Modal Bottom Sheet chứa CupertinoPicker
  void _showItemPicker(BuildContext context) {
    String selectedItem = value;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent, // Để sheet có góc bo tròn nhìn đẹp hơn
      builder: (BuildContext builder) {
        return Container(
          height: 300.h,
          decoration: BoxDecoration(
            color: Colors.white,
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
                  border: Border(bottom: BorderSide(color: Colors.grey.shade200)),
                ),
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      label,
                      style: TextStyle(
                          fontSize: 18.sp, fontWeight: FontWeight.bold),
                    ),
                    TextButton(
                      onPressed: () {
                        // Gửi giá trị đã chọn ra ngoài và đóng modal
                        onChanged(selectedItem);
                        Navigator.pop(context);
                      },
                      child: Text(
                        'Xong',
                        style: TextStyle(
                            fontSize: 18.sp,
                            fontWeight: FontWeight.bold,
                            color: Colors.blue),
                      ),
                    ),
                  ],
                ),
              ),

              // Cupertino Picker (Giao diện giống iOS)
              Expanded(
                child: CupertinoPicker(
                  magnification: 1.2,
                  squeeze: 1.0,
                  itemExtent: 40.h, // Chiều cao của mỗi mục
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
                        style: TextStyle(fontSize: 20.sp, color: Colors.black),
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(left: 17.w, bottom: 8.h),
          child: Text(label,
              style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.w500)),
        ),

        // Thay thế DropdownButton bằng GestureDetector để mở Modal
        GestureDetector(
          onTap: () => _showItemPicker(context),
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: 10.w),
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
            decoration: BoxDecoration(
              color: const Color(0xFFEBEBEB),
              borderRadius: BorderRadius.circular(10.r), // Bo góc mềm mại hơn
              border: Border.all(color: Colors.grey.shade400, width: 1.w), // Border mỏng và sáng hơn
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Giá trị được chọn
                Text(
                  value,
                  style: TextStyle(fontSize: 16.sp, color: Colors.black),
                ),
                // Icon mũi tên
                Icon(
                  Icons.keyboard_arrow_down,
                  size: 24.sp, // Icon nhỏ hơn, phù hợp hơn
                  color: Colors.grey.shade600,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}