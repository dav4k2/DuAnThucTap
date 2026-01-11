import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fontend/screens/Signin/sign_in&sign_up/auth/auth_service.dart';
import 'package:fontend/screens/survey/survey_0.dart';
import '../../../../Main_layout/main_layout.dart';
import '../../../../Service/user_service.dart';
import '../../../Home_page/mainpage_guest/home_screen.dart';
import '../../../Searching/search/explore_screen.dart';
import '../../../survey/survey_flow_screen.dart';
import '../auth/auth_gate.dart';
import '../auth/auth_provider.dart';
import '../auth/storage_service.dart';

class SignInForm extends ConsumerStatefulWidget {
  const SignInForm({super.key});

  @override
  ConsumerState<SignInForm> createState() => _SignInFormState();
}

class _SignInFormState extends ConsumerState<SignInForm> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;
  bool _isPasswordVisible = false;

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref.read(authProvider.notifier).setError(null);
    });
  }

  Future<void> _signIn() async {
    ref.read(authProvider.notifier).setError(null);
    setState(() => _isLoading = true);

    final authService = ref.read(authServiceProvider);
    String? error = await authService.signIn(
      email: _emailController.text.trim(),
      password: _passwordController.text.trim(),
    );

    setState(() => _isLoading = false);

    if (error == null) {
      if (mounted) {
        Navigator.of(context).pushNamedAndRemoveUntil('/authgate', (route) => false);
      }
    } else {
      ref.read(authProvider.notifier).setError(error);
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
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    final backgroundColor = isDarkMode ? Colors.black : Colors.white;
    final inputColor = isDarkMode ? Colors.grey[850]! : const Color(0xFFEBEBEB);
    final hintColor = isDarkMode ? Colors.white54 : Colors.black.withOpacity(0.3);
    final errorBgColor = isDarkMode ? Colors.red.withOpacity(0.5) : const Color(0xA8F0A4A4);
    final errorTextColor = Colors.red;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        /// Email
        InputField(
          key: const Key('field_email'),
          hintText: 'Email',
          controller: _emailController,
          width: inputWidth,
          isDarkMode: isDarkMode,
        ),
        SizedBox(height: 33.h),

        /// Mật khẩu
        InputField(
          key: const Key('field_password'),
          hintText: 'Mật khẩu',
          controller: _passwordController,
          width: inputWidth,
          obscure: !_isPasswordVisible,
          suffixIcon: IconButton(
            icon: Icon(
              _isPasswordVisible ? Icons.visibility_off : Icons.visibility,
              color: hintColor,
              size: 26.sp,
            ),
            onPressed: () => setState(() => _isPasswordVisible = !_isPasswordVisible),
          ),
          isDarkMode: isDarkMode,
        ),
        SizedBox(height: 10.h),

        /// Quên mật khẩu
        ForgotPasswordLink(isDarkMode: isDarkMode),
        SizedBox(height: 33.h),

        /// Hiển thị lỗi
        if (state.errorMessage != null)
          Padding(
            padding: EdgeInsets.only(bottom: 20.h),
            child: ErrorMessage(
              message: state.errorMessage!,
              width: errorWidth,
              bgColor: errorBgColor,
              textColor: errorTextColor,
            ),
          ),

        /// Đăng nhập
        GestureDetector(
          key: const Key('btn_login'),
          onTap: _isLoading ? null : _signIn,
          child: PrimaryButton(
            text: _isLoading ? 'Đang xử lý...' : 'Đăng nhập',
            width: inputWidth,
            isDarkMode: isDarkMode,
          ),
        ),
        SizedBox(height: 42.h),

        /// Đăng nhập là khách
        GestureDetector(
          onTap: () {
            ref.read(authProvider.notifier).setError(null);
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const MainLayout()),
            );
          },
          child: Stack(
            children: [
              Text(
                'Đăng nhập với tư cách khách ?',
                style: TextStyle(
                  fontSize: 22.sp,
                  fontFamily: 'SF Pro Rounded',
                  fontWeight: FontWeight.w600,
                  color: isDarkMode ? Colors.white : Colors.black,
                ),
              ),
              Positioned(
                bottom: -4,
                left: 0,
                right: 0,
                child: Container(
                  height: 6,
                  color: isDarkMode ? Colors.white : Colors.black,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// ==================== INPUT FIELD  ====================
class InputField extends StatelessWidget {
  final String hintText;
  final bool obscure;
  final TextEditingController controller;
  final double width;
  final Widget? suffixIcon;
  final bool isDarkMode;

  const InputField({
    super.key,
    required this.hintText,
    required this.controller,
    required this.width,
    this.obscure = false,
    this.suffixIcon,
    this.isDarkMode = false,
  });

  @override
  Widget build(BuildContext context) {
    final inputColor = isDarkMode ? Colors.grey[850]! : const Color(0xFFEBEBEB);
    final hintColor = isDarkMode ? Colors.white54 : Colors.black.withOpacity(0.3);
    final textColor = isDarkMode ? Colors.white : Colors.black;

    return Container(
      width: width,
      height: 65.h,
      alignment: Alignment.center,
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      decoration: BoxDecoration(
        color: inputColor,
        border: Border.all(color: Colors.black.withOpacity(0.4)),
        borderRadius: BorderRadius.circular(50.r),
      ),
      child: TextField(
        controller: controller,
        obscureText: obscure,
        cursorColor: textColor,
        style: TextStyle(
          color: textColor,
          fontSize: 24.sp,
          fontFamily: 'SF Pro Rounded',
          fontWeight: FontWeight.w700,
        ),
        decoration: InputDecoration(
          isDense: true,
          border: InputBorder.none,
          hintText: hintText,
          hintStyle: TextStyle(
            color: hintColor,
            fontSize: 24.sp,
            fontFamily: 'SF Pro Rounded',
            fontWeight: FontWeight.w700,
          ),
          suffixIcon: suffixIcon,
        ),
      ),
    );
  }
}

// ==================== ERROR MESSAGE  ====================
class ErrorMessage extends StatelessWidget {
  final String message;
  final double width;
  final Color bgColor;
  final Color textColor;

  const ErrorMessage({
    super.key,
    required this.message,
    required this.width,
    required this.bgColor,
    required this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
      decoration: ShapeDecoration(
        color: bgColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50.r)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.warning_amber_rounded, color: textColor, size: 22.sp),
          SizedBox(width: 10.w),
          Flexible(
            child: Text(
              message,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: textColor,
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

// ==================== PRIMARY BUTTON  ====================
class PrimaryButton extends StatelessWidget {
  final String text;
  final double width;
  final bool isDarkMode;

  const PrimaryButton({super.key, required this.text, required this.width, this.isDarkMode = false});

  @override
  Widget build(BuildContext context) {
    final bgColor = const Color(0xFFFFB901);
    final textColor = Colors.black;

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

// ==================== FORGOT PASSWORD  ====================
class ForgotPasswordLink extends StatelessWidget {
  final bool isDarkMode;
  const ForgotPasswordLink({super.key, this.isDarkMode = false});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(right: 10.w),
      child: Align(
        alignment: Alignment.centerRight,
        child: GestureDetector(
          onTap: () => Navigator.pushNamed(context, '/reset'),
          child: Stack(
            children: [
              Text(
                'Quên mật khẩu ?',
                style: TextStyle(
                  color: const Color(0xFFFFB901),
                  fontSize: 20.sp,
                  fontFamily: 'SF Pro Rounded',
                  fontWeight: FontWeight.w600,
                ),
              ),
              Positioned(
                bottom: -4,
                left: 0,
                right: 0,
                child: Container(height: 6, color: const Color(0xFFFFB901)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class AdminScreen extends StatelessWidget {
  const AdminScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: Center(child: Text('Admin Dashboard')));
  }
}
