import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../Remove/enter_verification_code/widgets/error_message.dart';
import '../../logic/password_reset_provider.dart';
import '../../settings_screen.dart';

const Color kPrimaryColor = Color(0xFFFFB901);

class PasswordResetScreen extends ConsumerStatefulWidget {
  const PasswordResetScreen({super.key});

  @override
  ConsumerState<PasswordResetScreen> createState() => _PasswordResetScreenState();
}

class _PasswordResetScreenState extends ConsumerState<PasswordResetScreen> {
  final _currentPassController = TextEditingController();
  final _newPassController = TextEditingController();
  final _confirmPassController = TextEditingController();

  bool _isCurrentPasswordVisible = false;
  bool _isNewPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;

  String _currentPassError = '';
  String _newPassError = '';
  String _confirmPassError = '';

  @override
  void dispose() {
    _currentPassController.dispose();
    _newPassController.dispose();
    _confirmPassController.dispose();
    super.dispose();
  }

  void _submitReset() async {
    setState(() {
      _currentPassError = '';
      _newPassError = '';
      _confirmPassError = '';
    });

    final controller = ref.read(passwordResetProvider.notifier);
    await controller.resetPassword(
      currentPassword: _currentPassController.text.trim(),
      newPassword: _newPassController.text.trim(),
      confirmPassword: _confirmPassController.text.trim(),
    );
  }

  void _handleProviderErrors(PasswordResetState next) {
    if (next.errorMessage == null || next.errorMessage!.isEmpty) return;

    setState(() {
      _currentPassError = '';
      _newPassError = '';
      _confirmPassError = '';
    });

    final error = next.errorMessage!;
    if (error.contains('không khớp'.tr()) || error.contains('không trùng'.tr())) {
      _confirmPassError = error;
    } else if (error.contains('hiện tại'.tr()) || error.contains('sai'.tr()) || error.contains('không chính xác'.tr())) {
      _currentPassError = error;
    } else if (error.contains('ít nhất'.tr()) || error.contains('ký tự')) {
      _newPassError = error;
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(error), backgroundColor: Colors.redAccent),
      );
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(passwordResetProvider);
    final width = MediaQuery.of(context).size.width - 56;
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    ref.listen<PasswordResetState>(passwordResetProvider, (previous, next) {
      if (next.errorMessage != null && next.errorMessage!.isNotEmpty) {
        if (next.errorMessage!.contains('thành công'.tr())) {
          ScaffoldMessenger.of(context).showSnackBar(
             SnackBar(
              content: Text('Đổi mật khẩu thành công!'.tr()),
              backgroundColor: Colors.green,
              duration: Duration(seconds: 2),
            ),
          );
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (_) => const SettingsScreen()),
          );
        } else {
          _handleProviderErrors(next);
        }
      }
    });

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: theme.iconTheme.color),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Cài đặt mật khẩu'.tr(),
          style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 28.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
             SizedBox(height: 20),
            _buildLabel('Mật khẩu hiện tại'.tr(), theme),
            _buildPasswordField(
              controller: _currentPassController,
              hintText: 'Nhập mật khẩu hiện tại'.tr(),
              isVisible: _isCurrentPasswordVisible,
              toggleVisibility: () => setState(() => _isCurrentPasswordVisible = !_isCurrentPasswordVisible),
              theme: theme,
            ),
            const SizedBox(height: 8),
            if (_currentPassError.isNotEmpty) ...[
              ErrorMessage(message: _currentPassError, width: width),
              const SizedBox(height: 8),
            ],

            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: () {},
                child: Text(
                  'Quên mật khẩu ?'.tr(),
                  style: TextStyle(
                    color: kPrimaryColor,
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),

            _buildLabel('Mật khẩu mới'.tr(), theme),
            _buildPasswordField(
              controller: _newPassController,
              hintText: 'Nhập mật khẩu mới (tối thiểu 6 ký tự)'.tr(),
              isVisible: _isNewPasswordVisible,
              toggleVisibility: () => setState(() => _isNewPasswordVisible = !_isNewPasswordVisible),
              theme: theme,
            ),
            const SizedBox(height: 8),
            if (_newPassError.isNotEmpty) ...[
              ErrorMessage(message: _newPassError, width: width),
              const SizedBox(height: 8),
            ],

            const SizedBox(height: 24),

            _buildLabel('Nhập lại mật khẩu'.tr(), theme),
            _buildPasswordField(
              controller: _confirmPassController,
              hintText: 'Nhập lại mật khẩu mới'.tr(),
              isVisible: _isConfirmPasswordVisible,
              toggleVisibility: () => setState(() => _isConfirmPasswordVisible = !_isConfirmPasswordVisible),
              theme: theme,
            ),
            const SizedBox(height: 8),
            if (_confirmPassError.isNotEmpty) ...[
              ErrorMessage(message: _confirmPassError, width: width),
              const SizedBox(height: 8),
            ],

            const SizedBox(height: 50),

            GestureDetector(
              onTap: _submitReset,
              child: Container(
                height: 65,
                width: double.infinity,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: kPrimaryColor,
                  borderRadius: BorderRadius.circular(50),
                ),
                child: state.isLoading
                    ? const SizedBox(
                  width: 30,
                  height: 30,
                  child: CircularProgressIndicator(color: Colors.black, strokeWidth: 3),
                )
                    :  Text(
                  'CẬP NHẬT'.tr(),
                  style: TextStyle(color: Colors.black, fontSize: 22, fontWeight: FontWeight.w800),
                ),
              ),
            ),

            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildLabel(String text, ThemeData theme) => Padding(
    padding: const EdgeInsets.only(left: 10, bottom: 8),
    child: Text(
      text,
      style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w500),
    ),
  );

  Widget _buildPasswordField({
    required TextEditingController controller,
    required String hintText,
    required bool isVisible,
    required VoidCallback toggleVisibility,
    required ThemeData theme,
  }) {
    final isDark = theme.brightness == Brightness.dark;
    return Container(
      height: 65,
      decoration: BoxDecoration(
        color: isDark ? Colors.grey[800] : const Color(0xFFEBEBEB),
        borderRadius: BorderRadius.circular(50),
        border: Border.all(color: isDark ? Colors.white24 : Colors.black.withOpacity(0.4)),
      ),
      child: TextFormField(
        controller: controller,
        obscureText: !isVisible,
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w500,
          color: isDark ? Colors.white : Colors.black,
        ),
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: hintText,
          hintStyle: TextStyle(color: isDark ? Colors.white54 : Colors.black54, fontSize: 18),
          contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
          suffixIcon: IconButton(
            icon: Icon(isVisible ? Icons.visibility : Icons.visibility_off, color: kPrimaryColor),
            onPressed: toggleVisibility,
          ),
        ),
      ),
    );
  }
}
