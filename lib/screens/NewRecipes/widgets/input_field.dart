// lib/features/add_recipe/widgets/input_field.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class InputField extends StatefulWidget {
  final String label;
  final String hintText;
  final bool isMultiline;
  final TextEditingController controller;
  final int? maxLines;
  final Widget? suffixIcon;
  final String? errorText;

  const InputField({
    Key? key,
    required this.label,
    required this.hintText,
    required this.controller,
    this.isMultiline = false,
    this.maxLines,
    this.suffixIcon,
    this.errorText,
  }) : super(key: key);

  @override
  State<InputField> createState() => _InputFieldState();
}

class _InputFieldState extends State<InputField> {
  late String counterText;

  @override
  void initState() {
    super.initState();
    counterText = _getCounterText();
    widget.controller.addListener(_updateCounter);
  }

  @override
  void dispose() {
    widget.controller.removeListener(_updateCounter);
    super.dispose();
  }

  void _updateCounter() {
    if (mounted) {
      setState(() {
        counterText = _getCounterText();
      });
    }
  }

  String _getCounterText() {
    return widget.isMultiline ? '${widget.controller.text.length}/200' : '';
  }

  @override
  Widget build(BuildContext context) {
    final hasError = widget.errorText != null;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(left: 28.w, top: 30.h),
          child: Text(
            widget.label,
            style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w500),
          ),
        ),
        SizedBox(height: 8.h),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 25.w),
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
            decoration: BoxDecoration(
              color: hasError ? const Color(0xFFFFE6E6) : const Color(0xFFEBEBEB),
              borderRadius: BorderRadius.circular(30.r),
              border: hasError ? Border.all(color: const Color(0xFFFF3B30), width: 1.5) : null,
            ),
            child: TextField(
              controller: widget.controller,
              maxLines: widget.isMultiline ? (widget.maxLines ?? 6) : 1,
              decoration: InputDecoration(
                hintText: widget.hintText,
                hintStyle: TextStyle(
                  color: Colors.black.withOpacity(0.5),
                  fontSize: 16.sp,
                  fontFamily: 'SF Pro Rounded',
                ),
                border: InputBorder.none,
                counterText: widget.isMultiline ? counterText : null,
                suffixIcon: widget.suffixIcon,
              ),
            ),
          ),
        ),
        if (hasError)
          Padding(
            padding: EdgeInsets.only(left: 35.w, top: 6.h),
            child: Text(
              widget.errorText!,
              style: TextStyle(color: const Color(0xFFFF3B30), fontSize: 13.sp),
            ),
          ),
      ],
    );
  }
}