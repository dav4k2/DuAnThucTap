/// Sơn - Sign In Form
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fontend/screens/Signin/sign_in&sign_up/auth/auth_service.dart';
import '../../../Home_page/mainpage_guest/home_screen.dart';
import '../../../Searching/search/explore_screen.dart';
import '../auth/auth_provider.dart';

class SignInForm extends ConsumerStatefulWidget {
  const SignInForm({super.key});

  @override
  ConsumerState<SignInForm> createState() => _SignInFormState();
}

class _SignInFormState extends ConsumerState<SignInForm> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  bool _isPasswordVisible = false;

  @override
  void initState() {
    super.initState();
    // Reset lỗi khi vào màn
    Future.microtask(() {
      ref.read(authProvider.notifier).setError(null);
    });
  }

  Future<void> _signIn() async {
    if (_formKey.currentState != null && _formKey.currentState!.validate()) {
      if(_formKey.currentState!.validate()){
        setState(() {
          _isLoading = true;
        });
      }
    }

    final authNotifier = ref.read(authProvider.notifier);
    final authService = ref.read(authServiceProvider);

    try {
      // 1. Thực hiện Đăng nhập Firebase
      await AuthServices.signIn(
        _emailController.text.trim(),
        _passwordController.text.trim(),
      );

      // 2. Đăng nhập thành công -> KHÔNG CẦN điều hướng thủ công.
      //    AuthGate sẽ tự động chuyển sang ExploreScreen.
      if (mounted) {
        authNotifier.setError(null);

        // Sử dụng pushReplacement để chuyển đến màn hình đăng nhập
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            // Giả định SignInScreen có thể nhận tham số để hiển thị tab Đăng nhập
            builder: (context) => const ExploreScreen(),
          ),
        );
      }

    } on Exception catch (e) {
      // Xử lý lỗi
      final errorMessage = e.toString().contains(':')
          ? e.toString().split(': ').last
          : 'Đăng nhập không thành công. Vui lòng thử lại.';
      authNotifier.setError(errorMessage);
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
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
          controller: _emailController,
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
          onTap: _signIn,
          child: PrimaryButton(text: 'Đăng nhập', width: inputWidth),
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
