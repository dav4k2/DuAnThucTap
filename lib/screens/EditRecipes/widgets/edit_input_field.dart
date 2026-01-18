import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class EditInputField extends StatefulWidget {
  final String label;
  final String hintText;
  final bool isMultiline;
  final String? initialValue;
  final void Function(String)? onChanged;
  final int? maxLines;
  final Widget? suffixIcon;
  final String? errorText;

  const EditInputField({
    Key? key,
    required this.label,
    required this.hintText,
    this.isMultiline = false,
    this.initialValue,
    this.onChanged,
    this.maxLines,
    this.suffixIcon,
    this.errorText,
  }) : super(key: key);

  @override
  State<EditInputField> createState() => _EditInputFieldState();
}

class _EditInputFieldState extends State<EditInputField> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialValue ?? '');
  }

  @override
  void didUpdateWidget(covariant EditInputField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.initialValue != widget.initialValue) {
      _controller.text = widget.initialValue ?? '';
      _controller.selection = TextSelection.fromPosition(
        TextPosition(offset: _controller.text.length),
      );
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final hasError = widget.errorText != null;
    final currentLength = _controller.text.length;

    final bgColor = hasError
        ? const Color(0xFFFFE6E6)
        : (isDark ? Colors.grey[800] : const Color(0xFFEBEBEB));
    final borderColor = hasError ? const Color(0xFFFF3B30) : Colors.transparent;
    final textColor = isDark ? Colors.white70 : Colors.black87;
    final hintColor = Colors.black.withOpacity(0.5);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(left: 28.w, top: 30.h),
          child: Text(
            widget.label,
            style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w500, color: textColor),
          ),
        ),
        SizedBox(height: 8.h),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 25.w),
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
            decoration: BoxDecoration(
              color: bgColor,
              borderRadius: BorderRadius.circular(30.r),
              border: Border.all(color: borderColor, width: hasError ? 1.5 : 0),
            ),
            child: Directionality(
              textDirection: TextDirection.ltr,
              child: TextField(
                controller: _controller,
                onChanged: widget.onChanged,
                maxLines: widget.isMultiline ? (widget.maxLines ?? 6) : 1,
                maxLength: widget.isMultiline ? 200 : null,
                textAlign: TextAlign.left,
                style: TextStyle(color: textColor, fontSize: 16.sp),
                decoration: InputDecoration(
                  hintText: widget.hintText,
                  hintStyle: TextStyle(color: hintColor, fontSize: 16.sp, fontFamily: 'SF Pro Rounded'),
                  border: InputBorder.none,
                  counterText: widget.isMultiline ? '$currentLength/200' : null,
                  suffixIcon: widget.suffixIcon,
                ),
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