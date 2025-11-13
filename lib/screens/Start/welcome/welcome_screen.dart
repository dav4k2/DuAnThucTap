///Sơn
///Trang welcome

import 'package:flutter/material.dart';
import '../../../Main_layout/main_layout.dart';
import 'widgets/welcome_logo.dart';
import 'widgets/welcome_texts.dart';
import 'widgets/welcome_buttons.dart';
import 'widgets/welcome_background.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final height = size.height;
    final width = size.width;

    return Scaffold(
      body: SizedBox(
        width: double.infinity,
        height: double.infinity,
        child: Stack(
          children: [

            ///Back ground
            const WelcomeBackground(),

            /// Logo
            Positioned(
              top: height * 0.15,
              left: width * 0.075,
              child: const WelcomeLogo(),
            ),

            /// Texts
            Positioned(
              top: height * 0.6,
              left: width * 0.07,
              right: width * 0.07,
              child: const WelcomeTexts(),
            ),

            /// Buttons ĐN/ĐK
            Positioned(
              top: height * 0.84,
              left: width * 0.05,
              right: width * 0.05,
              child: const WelcomeButtons(),
            ),

            /// “Tiếp tục với tư cách Khách”
            Positioned(
              top: height * 0.95,
              left: 0,
              right: 0,
              child: GestureDetector(
                onTap: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => const MainLayout()),
                  );
                },
                child: Text(
                  'Tiếp tục với tư cách Khách',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: width * 0.05,
                    fontFamily: 'SF Pro Rounded',
                    fontWeight: FontWeight.w400,
                    decoration: TextDecoration.underline,
                    height: 1.5,
                  ),
                ),
              ),
            ),

          ],
        ),
      ),
    );
  }
}
