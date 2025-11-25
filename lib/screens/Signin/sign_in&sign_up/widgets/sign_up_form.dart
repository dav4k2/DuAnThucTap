import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fontend/screens/Signin/sign_in&sign_up/auth/auth_service.dart';
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
    final authNotifier = ref.read(authProvider.notifier);

    // --- Dùng provider kiểm tra dữ liệu trước khi gọi AuthServices ---
    final error = authNotifier.signup(
      _usernameController.text,
      _passwordController.text,
      _confirmController.text,
      _emailController.text,
    );

    if (error != null) {
      authNotifier.setError(error);
      return;
    }

    setState(() => _isLoading = true);

    try {
      // SỬA ĐỔI: Bắt kết quả trả về và kiểm tra lỗi từ backend
      final result = await AuthServices.signUp(
        _emailController.text.trim(),      // Tham số 1: Email
        _passwordController.text.trim(),   // Tham số 2: Password
        _usernameController.text.trim(),   // Tham số 3: Username
      );

      // KIỂM TRA LỖI TRẢ VỀ TỪ BACKEND
      if (result.containsKey('error')) {
        throw Exception(result['error']); // Ném lỗi để bắt ở catch block
      }

      // Đăng ký thành công (Nếu không có key 'error' và không có exception)
      if (mounted) {
        authNotifier.setError(null);
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const SignInScreen(initialTab: true),/// Nếu đăng ký thành công quay lại đăng nhâoj
          ),
        );
      }
    } on Exception catch (e) {
      final errorMessage = e.toString().contains(':')
          ? e.toString().split(': ').last
          : 'Lỗi đăng ký. Vui lòng thử lại.';
      authNotifier.setError(errorMessage);
    } finally {
      if (mounted) setState(() => _isLoading = false);
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
    final inputWidth = 0.85.sw;
    final errorWidth = 0.75.sw;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 10.h),

        /// Tài khoản
        Center(
          child: InputField(
            hintText: "Tài khoản",
            controller: _usernameController,
            width: inputWidth,
          ),
        ),
        SizedBox(height: 9.h),

        /// Email hoặc SĐT
        Center(
          child: InputField(
            hintText: "Email hoặc SĐT",
            controller: _emailController,
            width: inputWidth,
          ),
        ),
        SizedBox(height: 9.h),

        /// Mật khẩu
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

        /// Nhập lại mật khẩu
        Center(
          child: InputField(
            hintText: "Nhập lại mật khẩu",
            controller: _confirmController,
            obscure: !state.showConfirmPassword,
            width: inputWidth,
            suffixIcon: IconButton(
              icon: Icon(
                state.showConfirmPassword
                    ? Icons.visibility_off
                    : Icons.visibility,
                color: Colors.black.withOpacity(0.5),
                size: 26.sp,
              ),
              onPressed: () =>
                  ref.read(authProvider.notifier).toggleConfirmPassword(),
            ),
          ),
        ),
        SizedBox(height: 9.h),

        /// Checkbox đồng ý điều khoản
        Padding(
          padding: EdgeInsets.only(left: 0.01.sw),
          child: TermsCheckbox(
            isChecked: state.agreeTerms,
            onChanged: (_) => ref.read(authProvider.notifier).toggleTerms(),
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
              ),
            ),
          ),

        /// Nút đăng ký
        Center(
          child: GestureDetector(
            onTap: _signUp,
            child: PrimaryButton(
              text: _isLoading ? "Đang xử lý..." : "Đăng ký",
              width: inputWidth,
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
