import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fontend/screens/Signin/sign_in&sign_up/auth/auth_service.dart';
import '../../../../Main_layout/main_layout.dart';
import '../../../Home_page/mainpage_guest/home_screen.dart';
import '../../../Searching/search/explore_screen.dart';
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
    final authNotifier = ref.read(authProvider.notifier);
    authNotifier.setError(null);
    setState(() => _isLoading = true);

    try {
      final AuthResponse response = await AuthServices.signIn(
        _emailController.text.trim(),
        _passwordController.text.trim(),
      );

      if (mounted) {
        if (response.success) {
          authNotifier.setError(null);
          await StorageService.saveToken(response.token!);
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (_) => const AuthGate()),
                (route) => false,
          );
        } else {
          authNotifier.setError(response.message);
        }
      }
    } on Exception catch (e) {
      final errorMessage = e.toString().contains(':')
          ? e.toString().split(': ').last
          : 'Đăng nhập không thành công. Vui lòng thử lại.';
      authNotifier.setError(errorMessage);
    } finally {
      if (mounted) setState(() => _isLoading = false);
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

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        /// Tài khoản
        InputField(
          hintText: 'Tài khoản',
          controller: _emailController,
          width: inputWidth,
        ),
        SizedBox(height: 33.h),

        /// Mật khẩu
        InputField(
          hintText: 'Mật khẩu',
          controller: _passwordController,
          width: inputWidth,
          obscure: !_isPasswordVisible,
          suffixIcon: IconButton(
            icon: Icon(
              _isPasswordVisible ? Icons.visibility_off : Icons.visibility,
              color: Colors.black.withOpacity(0.5),
              size: 26.sp,
            ),
            onPressed: () => setState(() => _isPasswordVisible = !_isPasswordVisible),
          ),
        ),
        SizedBox(height: 10.h),

        /// Quên mật khẩu
        const ForgotPasswordLink(),
        SizedBox(height: 33.h),

        /// Hiển thị lỗi
        if (state.errorMessage != null)
          Padding(
            padding: EdgeInsets.only(bottom: 20.h),
            child: ErrorMessage(
              message: state.errorMessage!,
              width: errorWidth,
            ),
          ),

        /// Đăng nhập
        GestureDetector(
          onTap: _signIn,
          child: PrimaryButton(
            text: _isLoading ? 'Đang xử lý...' : 'Đăng nhập',
            width: inputWidth,
          ),
        ),
        SizedBox(height: 42.h),

        /// Đăng nhập là khách
        GestureDetector(
          onTap: () {
            ref.read(authProvider.notifier).setError(null);
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const HomeScreen()),
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
                ),
              ),
              Positioned(
                bottom: -4,
                left: 0,
                right: 0,
                child: Container(height: 6, color: Colors.black),
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
          fontWeight: FontWeight.w700, // ĐẬM Y HỆT SIGN UP
        ),
      ),
    );
  }
}


class ErrorMessage extends StatelessWidget {
  final String message;
  final double width;
  const ErrorMessage({super.key, required this.message, required this.width});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
      decoration: ShapeDecoration(
        color: const Color(0xA8F0A4A4),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50.r)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.warning_amber_rounded, color: const Color(0xFFF01E1E), size: 22.sp),
          SizedBox(width: 10.w),
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

class PrimaryButton extends StatelessWidget {
  final String text;
  final double width;
  const PrimaryButton({super.key, required this.text, required this.width});

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

class ForgotPasswordLink extends StatelessWidget {
  const ForgotPasswordLink({super.key});

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
                  color: Color(0xFFFFB901),
                  fontSize: 20.sp,
                  fontFamily: 'SF Pro Rounded',
                  fontWeight: FontWeight.w600,
                ),
              ),
              Positioned(
                bottom: -4,
                left: 0,
                right: 0,
                child: Container(height: 6, color: Color(0xFFFFB901)),
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