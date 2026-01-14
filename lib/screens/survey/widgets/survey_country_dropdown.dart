import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SurveyCountryDropdown extends ConsumerWidget {
  final Function(String) onChanged;
  final String? selectedCountry;

  SurveyCountryDropdown({
    super.key,
    required this.onChanged,
    required this.selectedCountry,
  });

  final List<String> countries = [
    "Việt Nam",
    "Thái Lan",
    "Hàn Quốc",
    "Nhật Bản",
    "Mỹ",
    "Pháp",
    "Ý"
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
            'Quốc gia',
            style: TextStyle(
                fontSize: 20.sp,
                fontWeight: FontWeight.w500,
                fontFamily: 'SF Pro Rounded'
            )
        ),
        SizedBox(height: 8.h),
        Container(
          width: 370.w,
          height: 48.h,
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          decoration: BoxDecoration(
            color: const Color(0xFFEBEBEB),
            borderRadius: BorderRadius.circular(20.r),
            border: Border.all(color: Colors.black.withOpacity(0.4)),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              isExpanded: true,
              hint: const Text("Chọn quốc gia"),
              value: selectedCountry,
              icon: const Icon(Icons.keyboard_arrow_down),
              items: countries.map((c) {
                return DropdownMenuItem(
                  value: c,
                  child: Text(c),
                );
              }).toList(),
              onChanged: (v) => v != null ? onChanged(v) : null,
            ),
          ),
        ),
      ],
    );
  }
}