/// Sơn
/// Form đăng ký (Responsive + Gọn)

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../dieu_khoan/dkhoan.dart';

class SignUpForm extends StatefulWidget {
  const SignUpForm({super.key});

  @override
  State<SignUpForm> createState() => _SignUpFormState();
}

    /// Xử lý sign up ở đây
class _SignUpFormState extends State<SignUpForm> {
  final TextEditingController accountController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmController = TextEditingController();

  bool isChecked = false;
  bool showPassword = false;
  bool showConfirmPassword = false;
  String? errorMessage;

  void _handleSignUp() {
    final account = accountController.text.trim();
    final password = passwordController.text.trim();
    final confirm = confirmController.text.trim();


    /// Thông báo lỗi ---------//
    setState(() => errorMessage = null);

    if (account.isEmpty || password.isEmpty || confirm.isEmpty) {
      setState(() => errorMessage = 'Vui lòng điền đầy đủ thông tin!');
      return;
    }
    if (password != confirm) {
      setState(() => errorMessage = 'Mật khẩu nhập lại không khớp!');
      return;
    }
    if (!isChecked) {
      setState(() => errorMessage = 'Vui lòng đồng ý với điều khoản!');
      return;
    }
    ///-----------------------------///

    ///test
    Navigator.pushNamed(context, '/welcome'); // Test route
  }


  /// Quản lý widget
  @override
  Widget build(BuildContext context) {
    final fieldWidth = 0.85.sw;
    final fieldHeight = 65.h;

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 0.h),
        child: Column(
          children: [

            /// Textbox tài khoản
            InputField(
              hintText: 'Tài khoản',
              controller: accountController,
              width: fieldWidth,
              height: fieldHeight,
            ),

            SizedBox(height: 33.h),

            ///Textbox mật khẩu
            InputField(
              hintText: 'Mật khẩu',
              controller: passwordController,
              width: fieldWidth,
              height: fieldHeight,
              isPassword: true,
              show: showPassword,
              toggle: () => setState(() => showPassword = !showPassword),
            ),

            SizedBox(height: 33.h),

            ///Text box nhập lại mật khẩu
            InputField(
              hintText: 'Nhập lại mật khẩu',
              controller: confirmController,
              width: fieldWidth,
              height: fieldHeight,
              isPassword: true,
              show: showConfirmPassword,
              toggle: () =>
                  setState(() => showConfirmPassword = !showConfirmPassword),
            ),

            SizedBox(height: 15.h),

            ///Checkbox
            CheckBoxTerms(
              isChecked: isChecked,
              onChanged: () => setState(() => isChecked = !isChecked),
            ),
            if (errorMessage != null) ...[
              SizedBox(height: 16.h),
              ErrorBox(message: errorMessage!, width: fieldWidth),
            ],

            SizedBox(height: 20.h),

            ///Nút đăng ký
            PrimaryButton(
              text: 'Đăng ký',
              width: fieldWidth,
              height: fieldHeight,
              onTap: _handleSignUp,
            ),
          ],
        ),
      ),
    );
  }
}

/// ------------------- Widgets -------------------

/// Ô nhập tài khoản / mật khẩu
class InputField extends StatelessWidget {
  final String hintText;
  final TextEditingController controller;
  final double width;
  final double height;
  final bool isPassword;
  final bool show;
  final VoidCallback? toggle;

  const InputField({
    super.key,
    required this.hintText,
    required this.controller,
    required this.width,
    required this.height,
    this.isPassword = false,
    this.show = false,
    this.toggle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      decoration: BoxDecoration(
        color: const Color(0xFFEBEBEB),
        borderRadius: BorderRadius.circular(50.r),
        border: Border.all(color: Colors.black.withOpacity(0.4)),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: controller,
              obscureText: isPassword && !show,
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: hintText,
                hintStyle: TextStyle(
                  color: Colors.black.withOpacity(0.3),
                  fontSize: 24.sp,
                  fontFamily: 'SF Pro Rounded',
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
          if (isPassword)
            GestureDetector(
              onTap: toggle,
              child: Icon(
                show ? Icons.visibility_off : Icons.visibility,
                color: Colors.black.withOpacity(0.6),
                size: 24.sp,
              ),
            ),
        ],
      ),
    );
  }
}

/// Checkbox điều khoản
class CheckBoxTerms extends StatelessWidget {
  final bool isChecked;
  final VoidCallback onChanged;

  const CheckBoxTerms({
    super.key,
    required this.isChecked,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onChanged,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: 22.w,
              height: 22.w,
              decoration: BoxDecoration(
                color: isChecked
                    ? const Color(0xFFFFB901)
                    : const Color(0xFFD7D7D7),
                borderRadius: BorderRadius.circular(3.r),
                border: Border.all(color: Colors.black.withOpacity(0.3)),
              ),
              child: isChecked
                  ? const Icon(Icons.check, size: 16, color: Colors.white)
                  : null,
            ),
            SizedBox(width: 10.w),
            Expanded(
              child: Wrap(
                children: [
                  Text(
                    'Đồng ý với ',
                    style: TextStyle(fontSize: 14.sp, color: Colors.black),
                  ),
                  GestureDetector(
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const TermsPage()),
                    ),
                    child: Text(
                      'điều khoản và điều kiện',
                      style: TextStyle(
                        color: const Color(0xFFFFB901),
                        decoration: TextDecoration.underline,
                        fontSize: 14.sp,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Thông báo lỗi
class ErrorBox extends StatelessWidget {
  final String message;
  final double width;

  const ErrorBox({
    super.key,
    required this.message,
    required this.width,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
      decoration: BoxDecoration(
        color: Colors.red.shade50,
        borderRadius: BorderRadius.circular(50.r),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.warning_amber_rounded,
              color: Colors.red.shade700, size: 20.sp),
          SizedBox(width: 8.w),
          Flexible(
            child: Text(
              message,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.red.shade700,
                fontSize: 15.sp,
                fontFamily: 'SF Pro Rounded',
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Nút đăng ký
class PrimaryButton extends StatelessWidget {
  final String text;
  final double width;
  final double height;
  final VoidCallback onTap;

  const PrimaryButton({
    super.key,
    required this.text,
    required this.width,
    required this.height,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: width,
        height: height,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.circular(50.r),
          border: Border.all(color: Colors.black.withOpacity(0.4)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 6,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Text(
          text,
          style: TextStyle(
            color: Colors.white,
            fontSize: 24.sp,
            fontFamily: 'SF Pro Rounded',
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }
}
