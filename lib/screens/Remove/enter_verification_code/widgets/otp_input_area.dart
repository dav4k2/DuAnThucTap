// widgets/otp_input_area.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class OTPInputArea extends StatefulWidget {
  final void Function(String code)? onChanged; // callback trả code đầy đủ

  const OTPInputArea({super.key, this.onChanged});

  @override
  State<OTPInputArea> createState() => _OTPInputAreaState();
}

class _OTPInputAreaState extends State<OTPInputArea> {
  final List<TextEditingController> _controllers =
  List.generate(4, (_) => TextEditingController());
  final List<FocusNode> _focusNodes = List.generate(4, (_) => FocusNode());

  @override
  void dispose() {
    for (final c in _controllers) c.dispose();
    for (final f in _focusNodes) f.dispose();
    super.dispose();
  }

  void _onChanged(String value, int index) {
    if (value.isNotEmpty && index < 3) {
      _focusNodes[index + 1].requestFocus();
    }
    final code = _controllers.map((e) => e.text).join();
    if (widget.onChanged != null) widget.onChanged!(code);
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(4, (index) {
        return Padding(
          padding: EdgeInsets.symmetric(horizontal: 8.w),
          child: Container(
            width: 73.w,
            height: 102.h,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: const Color(0xFFD9D9D9),
              borderRadius: BorderRadius.circular(15.r),
            ),
            child: TextField(
              controller: _controllers[index],
              focusNode: _focusNodes[index],
              textAlign: TextAlign.center,
              keyboardType: TextInputType.number,
              maxLength: 1,
              decoration: const InputDecoration(counterText: '', border: InputBorder.none),
              style: TextStyle(fontSize: 36.sp, fontWeight: FontWeight.w700),
              onChanged: (v) => _onChanged(v, index),
            ),
          ),
        );
      }),
    );
  }
}
