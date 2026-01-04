/// Sơn – WelcomeScreen

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../Main_layout/main_layout.dart';
import '../../Home_page/mainpage_guest/home_screen.dart';
import 'widgets/welcome_logo.dart';
import 'widgets/welcome_texts.dart';
import 'widgets/welcome_buttons.dart';
import 'widgets/welcome_background.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        width: 1.sw,
        height: 1.sh,
        child: Stack(
          children: [

            /// Background
            const WelcomeBackground(),

            /// Logo
            Positioned(
              top: 0.15.sh,     //
              left: 0.05.sw,   //
              child: const WelcomeLogo(),
            ),

            /// Texts
            Positioned(
              top: 0.60.sh,
              left: 0.07.sw,
              right: 0.07.sw,
              child: const WelcomeTexts(),
            ),

            /// Buttons
            Positioned(
              top: 0.84.sh,
              left: 0.05.sw,
              right: 0.05.sw,
              child: const WelcomeButtons(),
            ),

            /// Guest Button
            Positioned(
              top: 0.94.sh,
              left: 0,
              right: 0,
              child: GestureDetector(
                onTap: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const MainLayout(),
                    ),
                  );
                },
                child: Text(
                  'Tiếp tục với tư cách Khách'.tr(),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 20.sp,
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
