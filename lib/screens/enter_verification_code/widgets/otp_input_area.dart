import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../logic/verify_provider.dart';

class OTPInputArea extends ConsumerStatefulWidget {
  const OTPInputArea({super.key});

  @override
  ConsumerState<OTPInputArea> createState() => _OTPInputAreaState();
}

class _OTPInputAreaState extends ConsumerState<OTPInputArea> {
  final List<TextEditingController> _controllers =
  List.generate(4, (_) => TextEditingController());
  final List<FocusNode> _focusNodes = List.generate(4, (_) => FocusNode());

  @override
  void dispose() {
    for (final c in _controllers) {
      c.dispose();
    }
    for (final f in _focusNodes) {
      f.dispose();
    }
    super.dispose();
  }

  void _onChanged(String value, int index) {
    // Nếu nhập đúng 1 ký tự, tự động chuyển focus sang ô kế
    if (value.isNotEmpty && index < 3) {
      _focusNodes[index + 1].requestFocus();
    }

    // Ghép các ô thành chuỗi đầy đủ
    final code = _controllers.map((e) => e.text).join();

    // Gửi code lên provider
    ref.read(verifyCodeProvider.notifier).setCode(code);
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
              style: TextStyle(
                fontSize: 36.sp,
                fontWeight: FontWeight.w700,
                fontFamily: 'SF Pro',
              ),
              keyboardType: TextInputType.number,
              maxLength: 1,
              decoration: const InputDecoration(
                counterText: '', // ẩn “0/1”
                border: InputBorder.none,
              ),
              onChanged: (value) => _onChanged(value, index),
            ),
          ),
        );
      }),
    );
  }
}
