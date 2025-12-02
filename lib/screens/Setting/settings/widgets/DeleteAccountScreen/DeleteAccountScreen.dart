// lib/screens/delete_account/delete_account_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fontend/screens/Setting/settings/widgets/DeleteAccountScreen/widgets/account_deleted_success_screen.dart';
import 'widgets/avatar_warning_section.dart';
import 'widgets/reason_selection_section.dart';
import 'widgets/other_reason_input.dart';
import 'widgets/consequence_section.dart';
import 'widgets/delete_account_button.dart';

class DeleteAccountScreen extends StatefulWidget {
  const DeleteAccountScreen({super.key});

  @override
  State<DeleteAccountScreen> createState() => _DeleteAccountScreenState();
}

class _DeleteAccountScreenState extends State<DeleteAccountScreen> {
  int? selectedReason;
  final TextEditingController _otherController = TextEditingController();
  static const int maxOtherReasonLength = 200;

  @override
  void initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      systemNavigationBarColor: Colors.transparent,
    ));
  }

  @override
  void dispose() {
    _otherController.dispose();
    super.dispose();
  }

  void _onReasonChanged(int? value) {
    setState(() => selectedReason = value);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Xóa tài khoản',
          style: TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.w700,
            fontFamily: 'SF Pro Rounded',
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Column(
            children: [
              const SizedBox(height: 20),
              const AvatarWarningSection(),
              const SizedBox(height: 32),

              ReasonSelectionSection(
                selectedReason: selectedReason,
                onReasonChanged: _onReasonChanged,
              ),

              OtherReasonInput(
                isVisible: selectedReason == 4,
                controller: _otherController,
                maxLength: maxOtherReasonLength,
                onChanged: (_) => setState(() {}),
              ),

              const SizedBox(height: 32),
              const ConsequenceSection(),
              const SizedBox(height: 48),

              DeleteAccountButton(
                isEnabled: selectedReason != null,
                selectedReason: selectedReason,
                otherReasonText: selectedReason == 4 ? _otherController.text : null,
                onDeleteConfirmed: () {

                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => const AccountDeletionSuccessScreen()),
                        (route) => false, // xóa tất cả các trang trước
                  );
                },
              ),


              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  String _getReasonText(int index) {
    const reasons = [
      'Không còn mục đích sử dụng',
      'Tôi không biết dùng ứng dụng này',
      'Quá nhiều thông báo',
      'Vấn đề bảo mật',
      'Lý do khác',
    ];
    return reasons[index];
  }
}