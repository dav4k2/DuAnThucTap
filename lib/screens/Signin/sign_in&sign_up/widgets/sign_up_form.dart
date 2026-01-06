import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fontend/screens/Signin/sign_in&sign_up/auth/auth_service.dart';
import '../../../../theme/theme_provider.dart';
import '../auth/auth_provider.dart';
import '../sign_in_screen.dart';

class SignUpForm extends ConsumerStatefulWidget {
  const SignUpForm({super.key});

  @override
  ConsumerState<SignUpForm> createState() => _SignUpFormState();
}

class _SignUpFormState extends ConsumerState<SignUpForm> {
  final TextEditingController _usernameController = TextEditingController();
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
    final notifier = ref.read(authProvider.notifier);
    final service = ref.read(authServiceProvider);

    // 1. Validate dữ liệu nhập
    final validationError = notifier.validateSignup(
      _usernameController.text,
      _emailController.text,
      _passwordController.text,
      _confirmController.text,
    );

    if (validationError != null) {
      notifier.setError(validationError);
      return;
    }

    setState(() => _isLoading = true);
    notifier.setError(null);

    // 2. Gọi Firebase Auth
    final result = await service.signUp(
      email: _emailController.text.trim(),
      password: _passwordController.text.trim(),
      fullName: _usernameController.text.trim(),
    );

    setState(() => _isLoading = false);

    if (result == null) {
      // Thành công -> Chuyển sang màn hình Login (hoặc Home tùy bạn)
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Đăng ký thành công! Hãy đăng nhập.")));
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const SignInScreen(initialTab: true)), // initialTab: true để mở tab Login
        );
      }
    } else {
      // Thất bại
      notifier.setError(result);
    }
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(authProvider);
    final isDarkMode = ref.watch(themeProvider);
    final inputWidth = 0.85.sw;
    final errorWidth = 0.75.sw;

    final bgColor = isDarkMode ? Colors.grey[850]! : const Color(0xFFEBEBEB);
    final textColor = isDarkMode ? Colors.white : Colors.black;
    final borderColor = isDarkMode ? Colors.white.withOpacity(0.4) : Colors.black.withOpacity(0.4);
    final primaryButtonColor = isDarkMode ? Colors.amber[700]! : const Color(0xFFFFB901);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 10.h),


        /// Email
        Center(
          child: InputField(
            hintText: "Email",
            controller: _emailController,
            width: inputWidth,
            bgColor: bgColor,
            textColor: textColor,
            borderColor: borderColor,
          ),
        ),
        SizedBox(height: 12.h),

        /// Mật khẩu
        Center(
          child: InputField(
            hintText: "Mật khẩu",
            controller: _passwordController,
            obscure: !state.showPassword,
            width: inputWidth,
            bgColor: bgColor,
            textColor: textColor,
            borderColor: borderColor,
            suffixIcon: IconButton(
              icon: Icon(
                state.showPassword ? Icons.visibility_off : Icons.visibility,
                color: textColor.withOpacity(0.5),
                size: 26.sp,
              ),
              onPressed: () => ref.read(authProvider.notifier).togglePassword(),
            ),
          ),
        ),
        SizedBox(height: 12.h),

        /// Nhập lại mật khẩu
        Center(
          child: InputField(
            hintText: "Nhập lại mật khẩu",
            controller: _confirmController,
            obscure: !state.showConfirmPassword,
            width: inputWidth,
            bgColor: bgColor,
            textColor: textColor,
            borderColor: borderColor,
            suffixIcon: IconButton(
              icon: Icon(
                state.showConfirmPassword ? Icons.visibility_off : Icons.visibility,
                color: textColor.withOpacity(0.5),
                size: 26.sp,
              ),
              onPressed: () => ref.read(authProvider.notifier).toggleConfirmPassword(),
            ),
          ),
        ),
        SizedBox(height: 12.h),

        /// Checkbox đồng ý điều khoản
        Padding(
          padding: EdgeInsets.only(left: 0.01.sw),
          child: TermsCheckbox(
            isChecked: state.agreeTerms,
            onChanged: (_) => ref.read(authProvider.notifier).toggleTerms(),
            textColor: textColor,
          ),
        ),
        SizedBox(height: 15.h),

        /// Hiển thị lỗi
        if (state.errorMessage != null)
          Center(
            child: Padding(
              padding: EdgeInsets.only(bottom: 15.h),
              child: ErrorMessage(
                message: state.errorMessage!,
                width: errorWidth,
                isDarkMode: isDarkMode,
              ),
            ),
          ),

        /// Nút đăng ký
        Center(
          child: GestureDetector(
            onTap: _isLoading ? null : _signUp,
            child: PrimaryButton(
              text: _isLoading ? "Đang xử lý..." : "Đăng ký",
              width: inputWidth,
              bgColor: const Color(0xFFFFB901),
              textColor: Colors.black,
            ),
          ),
        ),

      ],
    );
  }
}

/// ------------------ WIDGET PHỤ ------------------

class InputField extends StatelessWidget {
  final String hintText;
  final bool obscure;
  final TextEditingController controller;
  final double width;
  final Widget? suffixIcon;
  final Color bgColor;
  final Color textColor;
  final Color borderColor;

  const InputField({
    super.key,
    required this.hintText,
    required this.controller,
    required this.width,
    this.obscure = false,
    this.suffixIcon,
    required this.bgColor,
    required this.textColor,
    required this.borderColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: 65.h,
      alignment: Alignment.center,
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      decoration: BoxDecoration(
        color: bgColor,
        border: Border.all(color: borderColor),
        borderRadius: BorderRadius.circular(50.r),
      ),
      child: TextField(
        controller: controller,
        obscureText: obscure,
        cursorColor: textColor,
        decoration: InputDecoration(
          isDense: true,
          border: InputBorder.none,
          hintText: hintText,
          hintStyle: TextStyle(
            color: textColor.withOpacity(0.3),
            fontSize: 24.sp,
            fontFamily: 'SF Pro Rounded',
            fontWeight: FontWeight.w700,
          ),
          suffixIcon: suffixIcon,
        ),
        style: TextStyle(
          color: textColor,
          fontSize: 24.sp,
          fontFamily: 'SF Pro Rounded',
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

class TermsCheckbox extends StatelessWidget {
  final bool isChecked;
  final ValueChanged<bool> onChanged;
  final Color textColor;

  const TermsCheckbox({
    super.key,
    required this.isChecked,
    required this.onChanged,
    required this.textColor,
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
            side: BorderSide(color: textColor.withOpacity(0.6)),
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
                  color: textColor,
                ),
              ),
              GestureDetector(
                onTap: () => Navigator.pushNamed(context, '/terms'),
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

class ErrorMessage extends StatelessWidget {
  final String message;
  final double width;
  final bool isDarkMode;

  const ErrorMessage({
    super.key,
    required this.message,
    required this.width,
    this.isDarkMode = false,
  });

  @override
  Widget build(BuildContext context) {
    final bg = isDarkMode ? Colors.red[900]!.withOpacity(0.6) : const Color(0xA8F0A4A4);
    final iconColor = isDarkMode ? Colors.red[300]! : const Color(0xFFF01E1E);

    return Container(
      width: width,
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
      decoration: ShapeDecoration(
        color: bg,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(50.r),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.warning_amber_rounded, color: iconColor, size: 22.sp),
          SizedBox(width: 19.w),
          Flexible(
            child: Text(
              message,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: iconColor,
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

class PrimaryButton extends StatelessWidget {
  final String text;
  final double width;
  final Color bgColor;
  final Color textColor;

  const PrimaryButton({
    super.key,
    required this.text,
    required this.width,
    required this.bgColor,
    required this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: 65.h,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(50.r),
        border: Border.all(color: textColor, width: 2.w),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: textColor,
          fontSize: 24.sp,
          fontFamily: 'SF Pro Rounded',
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}
