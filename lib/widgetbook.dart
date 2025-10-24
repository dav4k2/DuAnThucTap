import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';
import 'screens/sign_in/widgets/sign_in_tabs.dart';
import 'screens/sign_in/widgets/sign_in_form.dart';
import 'screens/sign_in/sign_in_screen.dart';
import 'screens/sign_in/widgets/sign_in_social_buttons.dart';


void main() {
  runApp(
    Widgetbook.material(
      directories: [
        WidgetbookFolder(
          name: 'Welcome',
          children: [
            //text đăng nhập đăng ký
            WidgetbookComponent(
              name: 'signin',
              useCases: [
                WidgetbookUseCase(
                  name: 'Default',
                  builder: (context) => Scaffold(
                    body: Center(
                      child: SignInTabs(
                        onTabChanged: (isSignIn) {
                          // ở đây tạm thời chỉ in ra log cho widgetbook test
                          print('Tab changed: $isSignIn');
                        },
                      ),
                    ),
                  ),
                ),
              ],
            ),

            WidgetbookComponent(
              name: 'SignInBackground',
              useCases: [
                WidgetbookUseCase(
                  name: 'Default',
                  builder: (context) => const Scaffold(
                    body: Center(child: SignInForm()),
                  ),
                ),
              ],
            ),

            WidgetbookComponent(
              name: 'aa',
              useCases: [
                WidgetbookUseCase(
                  name: 'Default',
                  builder: (context) => const Scaffold(
                    body: Center(child: SignInScreen()),
                  ),
                ),
              ],
            ),

            WidgetbookComponent(
              name: 'social',
              useCases: [
                WidgetbookUseCase(
                  name: 'Default',
                  builder: (context) => const Scaffold(
                    body: Center(child: SignInSocialButtons()),
                  ),
                ),
              ],
            ),

            
          ],
          
        ),
      ],
    ),
  );
}
