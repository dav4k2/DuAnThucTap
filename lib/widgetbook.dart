import 'package:flutter/material.dart';

import 'package:fontend/screens/welcome/widgets/splash_page.dart';
import 'package:widgetbook/widgetbook.dart';


void main() {
  runApp(const WidgetBookApp());
}

class WidgetBookApp extends StatelessWidget {
  const WidgetBookApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Widgetbook.material(
      // ✅ Bắt buộc có 'directories' trong Widgetbook 3.x
      directories: [
        WidgetbookFolder(
          name: 'Sign In',
          children: [
            
            WidgetbookComponent(
              name: 'SignInSocialButtons',
              useCases: [
                WidgetbookUseCase(
                  name: 'Default',
                  builder: (context) =>
                      const Scaffold(body: Center(child: SplashPage())),
                ),
              ],
            ),


            
          ],
        ),
      ],
    );
  }
}
