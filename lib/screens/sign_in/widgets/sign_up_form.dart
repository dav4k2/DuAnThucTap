import 'package:flutter/material.dart';

import '../../dieu_khoan/dkhoan.dart';

class SignUpForm extends StatefulWidget {
  const SignUpForm({super.key});

  @override
  State<SignUpForm> createState() => _SignUpFormState();
}

class _SignUpFormState extends State<SignUpForm> {
  bool isChecked = false;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isSmallScreen = size.height < 700;

    // 📏 Biến responsive dễ chỉnh
    final topPadding = size.height * 0.00;
    final bottomPadding = size.height * 0.03;
    final fieldSpacing = size.height * 0.03;
    final fieldWidth = size.width * 0.88;
    final fieldHeight = size.height * 0.075;
    final checkBoxSpacing = size.height * 0.02;

    return Padding(
      padding: EdgeInsets.only(top: topPadding, bottom: bottomPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          _buildInput('Tài khoản', fieldWidth, fieldHeight),
          SizedBox(height: fieldSpacing),
          _buildInput('Mật khẩu', fieldWidth, fieldHeight),
          SizedBox(height: fieldSpacing),
          _buildInput('Nhập lại mật khẩu', fieldWidth, fieldHeight),

          SizedBox(height: checkBoxSpacing),

          _buildCheckbox(context, fieldWidth),

          SizedBox(height: isSmallScreen ? 15 : fieldSpacing * 0.8),

          _buildButton('Đăng ký', fieldWidth, fieldHeight, isPrimary: true),
        ],
      ),
    );
  }

  // 🔹 Ô nhập liệu
  Widget _buildInput(String placeholder, double width, double height) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: const Color(0xFFEBEBEB),
        border: Border.all(color: Colors.black.withOpacity(0.4)),
        borderRadius: BorderRadius.circular(height / 2),
      ),
      alignment: Alignment.centerLeft,
      padding: EdgeInsets.symmetric(horizontal: width * 0.05),
      child: Text(
        placeholder,
        style: TextStyle(
          color: Colors.black.withOpacity(0.3),
          fontSize: width * 0.055,
          fontFamily: 'SF Pro Rounded',
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }

  // Checkbox
  Widget _buildCheckbox(BuildContext context, double width) {
    return GestureDetector(
      onTap: () => setState(() => isChecked = !isChecked),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: width * 0.03), 
        child: SizedBox(
          width: width,
          height: 40,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
         
              Container(
                width: 22,
                height: 22,
                decoration: BoxDecoration(
                  color: isChecked ? const Color(0xFFFFB901) : const Color(0xFFD7D7D7),
                  borderRadius: BorderRadius.circular(3),
                  border: Border.all(color: Colors.black.withOpacity(0.3)),
                ),
                child: isChecked
                    ? const Icon(Icons.check, size: 16, color: Colors.white)
                    : null,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: 'Đồng ý với ',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: width * 0.035,
                          fontFamily: 'SF Pro Rounded',
                          fontWeight: FontWeight.w300,
                          height: 1.4,
                        ),
                      ),
                      // Điều khoản
                      WidgetSpan(
                        child: GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const TermsPage(), // Thay class trang điều khoản tại đây
                              ),
                            );
                          },
                          child: Text(
                            'điều khoản',
                            style: TextStyle(
                              color: const Color(0xFFFFB901),
                              fontSize: width * 0.035,
                              fontFamily: 'SF Pro Rounded',
                              fontWeight: FontWeight.w400,
                              decoration: TextDecoration.underline,
                              height: 1.4,
                            ),
                          ),
                        ),
                      ),
                      TextSpan(
                        text: ' và ',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: width * 0.035,
                          fontFamily: 'SF Pro Rounded',
                          fontWeight: FontWeight.w300,
                          height: 1.4,
                        ),
                      ),
                      // điều kiện
                      WidgetSpan(
                        child: GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const TermsPage(), // Thay class trang điều kiện tại đây
                              ),
                            );
                          },
                          child: Text(
                            'điều kiện',
                            style: TextStyle(
                              color: const Color(0xFFFFB901),
                              fontSize: width * 0.035,
                              fontFamily: 'SF Pro Rounded',
                              fontWeight: FontWeight.w400,
                              decoration: TextDecoration.underline,
                              height: 1.4,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Nút đăng ký
  Widget _buildButton(String text, double width, double height, {bool isPrimary = false}) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: isPrimary ? Colors.black : Colors.white,
        borderRadius: BorderRadius.circular(height / 2),
        border: Border.all(color: Colors.black.withOpacity(0.4)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      alignment: Alignment.center,
      child: Text(
        text,
        style: TextStyle(
          color: isPrimary ? Colors.white : Colors.black,
          fontSize: width * 0.055,
          fontFamily: 'SF Pro Rounded',
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

// Tạo tạm trang mẫu để chạy được 


