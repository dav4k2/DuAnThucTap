/*import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';
import 'screens/sign_in/widgets/sign_in_form.dart';
import 'screens/sign_in/widgets/sign_in_social_buttons.dart';
import 'screens/sign_in/widgets/sign_in_background.dart';
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
              name: 'SignInSocialButtons',
              useCases: [
                WidgetbookUseCase(
                  name: 'Default',
                  builder: (context) =>
                      const Scaffold(body: Center(child: SignInForm())),
                ),
              ],
            ),
            WidgetbookComponent(
              name: 'test1',
              useCases: [
                WidgetbookUseCase(
                  name: '123',
                  builder: (context) => const Scaffold(
                    body: Center(child: SignInSocialButtons()),
                  ),
                ),
              ],
            ),
            WidgetbookComponent(
              name: 'test',
              useCases: [
                WidgetbookUseCase(
                  name: 'Default',
                  builder: (context) => Scaffold(
                    body: SignInBackground(
                      child: Center(child: SignInForm()),
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
                  builder: (context) => Scaffold(
                    body: SignInBackground(
                      child: Center(child: SignInScreen()),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }
}
*/