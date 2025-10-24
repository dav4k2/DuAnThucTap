import 'package:flutter/material.dart';
import 'widgets/welcome_logo.dart';
import 'widgets/welcome_texts.dart';
import 'widgets/welcome_buttons.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final height = size.height;
    final width = size.width;

    return Scaffold(
      backgroundColor: const Color(0xFFFFB901), // nền vàng cho phần trên
      body: Column(
        children: [
          // Phần trên: logo (vàng)
          Expanded(
            flex: 5,
            child: Center(
              child: WelcomeLogo(),
            ),
          ),

          // Phần dưới: nền xám, bo góc trên
          Expanded(
            flex: 5,
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: const Color(0xFFF3F3F3),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(width * 0.12),
                  topRight: Radius.circular(width * 0.12),
                ),
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: width * 0.08),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: height * 0.04),

                    // Texts
                    const WelcomeTexts(),
                    SizedBox(height: height * 0.04),

                    // Buttons
                    const WelcomeButtons(),
                    const Spacer(),

                    // “Tiếp tục với tư cách Khách”
                    Center(
                      child: Text(
                        'Tiếp tục với tư cách Khách',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                          fontFamily: 'SF Pro Rounded',
                          fontWeight: FontWeight.w400,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                    SizedBox(height: height * 0.03),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
