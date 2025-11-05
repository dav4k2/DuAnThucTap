/// Sơn
/// Form đăng ký
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../auth/auth_provider.dart';
import '../../explore/explore_screen.dart';
import '../sign_in_screen.dart';

import '../../enter_verification_code/verify_signup_email_screen.dart';
import '../../enter_verification_code/verify_signup_phone_screen.dart';
import '../logic/auth_provider.dart';


class SignUpForm extends ConsumerStatefulWidget {
  const SignUpForm({super.key});

  @override
  ConsumerState<SignUpForm> createState() => _SignUpFormState();
}

class _SignUpFormState extends ConsumerState<SignUpForm> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmController = TextEditingController();
  bool _isLoading = false;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref.read(authProvider.notifier).setError(null);
    });
  }

  Future<void> _signUp() async {
    if (_formKey.currentState != null && _formKey.currentState!.validate()) {
      if(_formKey.currentState!.validate()){
        setState(() {
          _isLoading = true;
        });
      }
    }

    // Lấy các dịch vụ cần thiết
    final authNotifier = ref.read(authProvider.notifier);
    final authService = ref.read(authServiceProvider);

    try{
      // 1. Thực hiện Đăng ký Firebase
      await authService.signUpWithEmail(
        _emailController.text.trim(),
        _passwordController.text.trim(),
      );

      // 2. ĐĂNG XUẤT ngay lập tức (để chuyển hướng về màn hình đăng nhập)
      await authService.signOut();

      // 3. THÀNH CÔNG: Chuyển hướng đến màn hình Đăng nhập
      if (mounted) {
        authNotifier.setError(null);

        // Sử dụng pushReplacement để chuyển đến màn hình đăng nhập
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            // Giả định SignInScreen có thể nhận tham số để hiển thị tab Đăng nhập
            builder: (context) => const SignInScreen(initialTab: true),
          ),
        );
      }
    } on Exception catch (e) {
      // Xử lý lỗi
      final errorMessage = e.toString().contains(':')
          ? e.toString().split(': ').last
          : 'Lỗi đăng ký. Vui lòng thử lại.';
      authNotifier.setError(errorMessage);
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(authProvider);
    final inputWidth = 0.85.sw;
    final errorWidth = 0.75.sw;
    final state = ref.watch(authProvider);
    final auth = ref.read(authProvider.notifier);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 10.h),

        /// Tài khoản
        Center(
          child: InputField(
            hintText: "Tài khoản",
            controller: _emailController,
            width: inputWidth,
          ),
        ),
        SizedBox(height: 9.h),
        Center(
          child: InputField(
            hintText: "Email hoặc SĐT",
            controller: _emailController,
            width: inputWidth,
          ),
        ),
        SizedBox(height: 9.h),
        Center(
          child: InputField(
            hintText: "Mật khẩu",
            controller: _passwordController,
            obscure: !state.showPassword,
            width: inputWidth,
            suffixIcon: IconButton(
              icon: Icon(
                state.showPassword ? Icons.visibility_off : Icons.visibility,
                color: Colors.black.withOpacity(0.5),
                size: 26.sp,
              ),
              onPressed: () => ref.read(authProvider.notifier).togglePassword(),
            ),
          ),
        ),
        SizedBox(height: 9.h),
        Center(
          child: InputField(
            hintText: "Nhập lại mật khẩu",
            controller: _confirmController,
            obscure: !state.showConfirmPassword,
            width: inputWidth,
            suffixIcon: IconButton(
              icon: Icon(
                state.showConfirmPassword ? Icons.visibility_off : Icons.visibility,
                color: Colors.black.withOpacity(0.5),
                size: 26.sp,
              ),
              onPressed: () => ref.read(authProvider.notifier).toggleConfirmPassword(),
            ),
          ),
        ),
        SizedBox(height: 9.h),
        Padding(
          padding: EdgeInsets.only(left: 0.01.sw),
          child: TermsCheckbox(
            isChecked: state.agreeTerms,
            onChanged: (_) => ref.read(authProvider.notifier).toggleTerms(),
          ),
        ),
        SizedBox(height: 15.h),

        /// Lỗi
        if (state.errorMessage != null)
          Center(
            child: Padding(
              padding: EdgeInsets.only(bottom: 15.h),
              child: ErrorMessage(
                message: state.errorMessage!,
                width: errorWidth,
              ),
            ),
          ),

        /// Nút đăng ký
        Center(
          child: GestureDetector(
            onTap: _signUp,
            child: PrimaryButton(
              text: "Đăng ký",
              width: inputWidth,
            ),
          ),
        ),
      ],
    );
  }
}

////////////////////////////////////////////
/// --------- WIDGET PHỤ ------------------
////////////////////////////////////////////

/// Textbox TK,MK
class InputField extends StatelessWidget {
  final String hintText;
  final bool obscure;
  final TextEditingController controller;
  final double width;
  final Widget? suffixIcon;

  const InputField({
    super.key,
    required this.hintText,
    required this.controller,
    required this.width,
    this.obscure = false,
    this.suffixIcon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: 65.h,
      alignment: Alignment.center,
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      decoration: BoxDecoration(
        color: const Color(0xFFEBEBEB),
        border: Border.all(color: Colors.black.withOpacity(0.4)),
        borderRadius: BorderRadius.circular(50.r),
      ),
      child: TextField(
        controller: controller,
        obscureText: obscure,
        cursorColor: Colors.black,
        decoration: InputDecoration(
          isDense: true,
          border: InputBorder.none,
          hintText: hintText,
          hintStyle: TextStyle(
            color: Colors.black.withOpacity(0.3),
            fontSize: 24.sp,
            fontFamily: 'SF Pro Rounded',
            fontWeight: FontWeight.w700,
          ),
          suffixIcon: suffixIcon,
        ),
        style: TextStyle(
          color: Colors.black,
          fontSize: 24.sp,
          fontFamily: 'SF Pro Rounded',
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

///Checkbox DK
class TermsCheckbox extends StatelessWidget {
  final bool isChecked;
  final ValueChanged<bool> onChanged;

  const TermsCheckbox({
    super.key,
    required this.isChecked,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(
          width: 22.w,
          height: 22.h,
          child: Checkbox(
            value: isChecked,
            onChanged: (val) => onChanged(val ?? false),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(6.r),
            ),
            side: BorderSide(color: Colors.black.withOpacity(0.6)),
            activeColor: Colors.amber,
          ),
        ),
        SizedBox(width: 10.w),
        Expanded(
          child: Wrap(
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              Text(
                "Tôi đồng ý với ",
                style: TextStyle(
                  fontSize: 15.sp,
                  fontFamily: "SF Pro Rounded",
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                ),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.pushNamed(context, '/terms');
                },
                child: Text(
                  "điều khoản và điều kiện",
                  style: TextStyle(
                    fontSize: 15.sp,
                    fontFamily: "SF Pro Rounded",
                    fontWeight: FontWeight.w700,
                    color: Colors.blueAccent,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

///TB lỗi
class ErrorMessage extends StatelessWidget {
  final String message;
  final double width;

  const ErrorMessage({
    super.key,
    required this.message,
    required this.width,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
      decoration: ShapeDecoration(
        color: const Color(0xA8F0A4A4),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(50.r),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.warning_amber_rounded,
              color: const Color(0xFFF01E1E), size: 22.sp),
          SizedBox(width: 19.w),
          Flexible(
            child: Text(
              message,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: const Color(0xFFF01E1E),
                fontSize: 13.sp,
                fontFamily: 'SF Pro Rounded',
                fontWeight: FontWeight.w400,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

///Nút đăng ký
class PrimaryButton extends StatelessWidget {
  final String text;
  final double width;

  const PrimaryButton({
    super.key,
    required this.text,
    required this.width,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: 65.h,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: const Color(0xFFFFB901),
        borderRadius: BorderRadius.circular(50.r),
        border: Border.all(color: Colors.black, width: 2.w),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: Colors.black,
          fontSize: 24.sp,
          fontFamily: 'SF Pro Rounded',
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}
