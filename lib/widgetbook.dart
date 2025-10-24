import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';
import 'screens/sign_in/widgets/sign_in_form.dart';
import 'screens/sign_in/widgets/sign_in_tabs.dart';
import 'screens/sign_in/widgets/sign_in_social_buttons.dart';
import 'screens/sign_in/sign_in_screen.dart';

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
              name: 'SignInScreen',
              useCases: [
                WidgetbookUseCase(
                  name: 'Default',
                  builder: (context) => const SignInScreen(),
                ),
              ],
            ),
            WidgetbookComponent(
              name: 'SignInForm',
              useCases: [
                WidgetbookUseCase(
                  name: 'Default',
                  builder: (context) => const SignInForm(),
                ),
              ],
            ),
            WidgetbookComponent(
              name: 'SignInTabs',
              useCases: [
                WidgetbookUseCase(
                  name: 'Default',
                  builder: (context) => SignInTabs(
                    onTabChanged: (isSignIn) {
                      debugPrint('Tab changed: $isSignIn');
                    },
                  ),
                ),
              ],
            ),
            WidgetbookComponent(
              name: 'SignInSocialButtons',
              useCases: [
                WidgetbookUseCase(
                  name: 'Default',
                  builder: (context) => const SignInSocialButtons(),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }
}
