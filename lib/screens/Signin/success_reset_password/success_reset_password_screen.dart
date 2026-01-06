import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../signup_successfully/widgets/success_button.dart';
import '../signup_successfully/widgets/success_header.dart';
import '../signup_successfully/widgets/success_icon.dart';
import 'logic/success_reset_provider.dart';

class ResetSuccessScreen extends ConsumerWidget {
  const ResetSuccessScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: size.width * 0.08,
              vertical: size.height * 0.1,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const ResetSuccessHeader(),
                SizedBox(height: size.height * 0.08),
                const ResetSuccessIcon(),
                SizedBox(height: size.height * 0.1),
                ResetSuccessButton(
                  onPressed: () {
                    // Reset lại trạng thái thành công về false
                    ref.read(resetSuccessProvider.notifier).state = false;

                    // Xóa toàn bộ stack và quay về màn hình đăng nhập
                    Navigator.pushNamedAndRemoveUntil(
                      context,
                      '/sign_in',
                          (route) => false,
                    );
                  },
                ),
                SizedBox(height: size.height * 0.05),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
