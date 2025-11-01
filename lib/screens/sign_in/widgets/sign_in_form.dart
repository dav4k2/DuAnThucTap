/// Sơn - Sign In Form
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../explore/explore_screen.dart';
import '../logic/auth_provider.dart';

class SignInForm extends ConsumerStatefulWidget {
  const SignInForm({super.key});

  @override
  ConsumerState<SignInForm> createState() => _SignInFormState();
}

class _SignInFormState extends ConsumerState<SignInForm> {
  final TextEditingController _accountController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _isPasswordVisible = false;

  @override
  void initState() {
    super.initState();
    // Reset lỗi khi vào màn
    Future.microtask(() {
      ref.read(authProvider.notifier).setError(null);
    });
  }

  void _login() {
    final account = _accountController.text.trim();
    final password = _passwordController.text.trim();

    ///Gọi logic đăng nhập
    final result = ref.read(authProvider.notifier).login(account, password);

    if (result == "admin") {
      Navigator.push(context,
          MaterialPageRoute(builder: (_) => const AdminScreen()));
    } else if (result == "user") {
      Navigator.push(context,
          MaterialPageRoute(builder: (_) => const ExploreScreen()));
    } else {
      ref.read(authProvider.notifier).setError(result);
    }
  }


  ///Widget
  @override
  Widget build(BuildContext context) {
    final state = ref.watch(authProvider);

    final inputWidth = 0.85.sw;
    final errorWidth = 0.75.sw;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [

        ///Textbox TK
        InputField(
          hintText: 'Tài khoản',
          controller: _accountController,
          width: inputWidth,
        ),

        SizedBox(height: 33.h),

        ///Textbox MK
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
            onPressed: () =>
                setState(() => _isPasswordVisible = !_isPasswordVisible),
          ),
        ),

        SizedBox(height: 10.h),

        /// Quên MK
        const ForgotPasswordLink(),

        SizedBox(height: 33.h),

        /// Error
        if (state.errorMessage != null)
          Padding(
            padding: EdgeInsets.only(bottom: 20.h),
            child: ErrorMessage(
              message: state.errorMessage!,
              width: errorWidth,
            ),
          ),

        ///Đăng nhập
        GestureDetector(
          onTap: _login,
          child: PrimaryButton(text: 'Đăng nhập', width: inputWidth),
        ),

        SizedBox(height: 42.h),

        /// Đăng nhập là khách
        GestureDetector(
          onTap: () {
            ref.read(authProvider.notifier).setError(null);
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const ExploreScreen()),
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
                bottom: -4, // khoảng cách gạch với chữ
                left: 0,
                right: 0,
                child: Container(
                  height: 6, // độ dày gạch
                  color: Colors.black,
                ),
              ),
            ],
          )
        ),
      ],
    );
  }
}


/// -------------------- Widget --------------------

/// Textbox tài khoản mật khẩu
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
      alignment: Alignment.centerLeft,
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      decoration: BoxDecoration(
        color: const Color(0xFFEBEBEB),
        border: Border.all(color: Colors.black.withOpacity(0.4)),
        borderRadius: BorderRadius.circular(50.r),
      ),
      child: TextField(
        controller: controller,
        obscureText: obscure,
        decoration: InputDecoration(
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
      ),
    );
  }
}

/// Thông báo lỗi
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

/// Nút đăng nhập
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

/// Link quên mật khẩu
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
                bottom: -4, // khoảng cách gạch với chữ
                left: 0,
                right: 0,
                child: Container(
                  height: 6, // độ dày gạch
                  color: Color(0xFFFFB901),
                ),
              ),
            ],
          )

        ),
      ),
    );
  }
}

/// Màn hình admin test
class AdminScreen extends StatelessWidget {
  const AdminScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: Text('Admin Dashboard')),
    );
  }
}
