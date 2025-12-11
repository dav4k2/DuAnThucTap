// lib/screens/delete_account/widgets/delete_account_button.dart

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'DeleteAccount.dart';

class DeleteAccountButton extends StatelessWidget {
  final bool isEnabled;
  final int? selectedReason;
  final String? otherReasonText;
  final VoidCallback onDeleteConfirmed; // Đổi tên cho rõ: chỉ gọi khi xác nhận thật

  const DeleteAccountButton({
    super.key,
    required this.isEnabled,
    required this.selectedReason,
    this.otherReasonText,
    required this.onDeleteConfirmed,
  });

  void _showConfirmDialog(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) => DeleteAccountBottomSheet(
        onConfirm: () {
          // Đây mới là lúc thực sự xóa tài khoản
          onDeleteConfirmed();
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: MediaQuery.of(context).size.width * 0.9,
        height: 70,
        child: ElevatedButton(
          onPressed: isEnabled
              ? () => _showConfirmDialog(context)
              : null,
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFFFFB901),
            disabledBackgroundColor: const Color(0xFFFFB901).withOpacity(0.5),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
            elevation: 4,
          ),
          child:  Text(
            'Xóa tài khoản'.tr(),
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: Colors.black,
              fontFamily: 'SF Pro',
            ),
          ),
        ),
      ),
    );
  }
}