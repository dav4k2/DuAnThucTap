import 'package:flutter/material.dart';
import 'widgets/welcome_background.dart';
import 'widgets/welcome_logo.dart';
import 'widgets/welcome_texts.dart';
import 'widgets/welcome_buttons.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: 402,
        height: 874,
        decoration: BoxDecoration(
          color: const Color(0xFFFFB901),
          borderRadius: BorderRadius.circular(50),
        ),
        child: Stack(
          children: [
            const WelcomeBackground(),

            // logo
            const Positioned(
              top: 120,
              left: 15,
              child: WelcomeLogo(),
            ),

            // texts
            const Positioned(
              left: 26,
              top: 520,
              child: WelcomeTexts(),
            ),

            // buttons
            const Positioned(
              top: 742,
              left: 12,
              child: WelcomeButtons(),
            ),

            // dòng “tiếp tục với tư cách khách”
            const Positioned(
              left: 80,
              top: 831,
              child: Text(
                'Tiếp tục với tư cách Khách',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 20,
                  fontFamily: 'SF Pro Rounded',
                  fontWeight: FontWeight.w400,
                  decoration: TextDecoration.underline,
                  height: 1.5,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
