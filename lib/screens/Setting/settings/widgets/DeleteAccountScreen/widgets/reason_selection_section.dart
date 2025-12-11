// lib/screens/delete_account/widgets/reason_selection_section.dart
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class ReasonSelectionSection extends StatelessWidget {
  final int? selectedReason;
  final ValueChanged<int?> onReasonChanged;

   ReasonSelectionSection({
    super.key,
    required this.selectedReason,
    required this.onReasonChanged,
  });

  final List<String> _reasons =  [
    'Không còn mục đích sử dụng'.tr(),
    'Tôi không biết dùng ứng dụng này'.tr(),
    'Quá nhiều thông báo'.tr(),
    'Vấn đề bảo mật'.tr(),
    'Lý do khác'.tr(),
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
         Text(
          'Cho chúng tôi biết lý do bạn rời đi:'.tr(),
          style: TextStyle(fontSize: 17, fontWeight: FontWeight.w600, fontFamily: 'SF Pro'),
        ),
        const SizedBox(height: 20),
        ...List.generate(_reasons.length, (index) {
          final isSelected = selectedReason == index;
          return GestureDetector(
            onTap: () => onReasonChanged(index),
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 12),
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: const Color(0xFFC6BFBF).withOpacity(0.5),
                    width: 0.5,
                  ),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(_reasons[index], style: const TextStyle(fontSize: 16, fontFamily: 'SF Pro')),
                  Container(
                    width: 25,
                    height: 25,
                    decoration: ShapeDecoration(
                      shape: OvalBorder(
                        side: BorderSide(
                          width: 1.5,
                          color: isSelected ? const Color(0xFFFFB901) : const Color(0xFFC6BFBF),
                        ),
                      ),
                    ),
                    child: isSelected
                        ? const Center(
                      child: CircleAvatar(
                        radius: 8.5,
                        backgroundColor: Color(0xFFFFB901),
                      ),
                    )
                        : null,
                  ),
                ],
              ),
            ),
          );
        }),
      ],
    );
  }
}