// lib/screens/survey/widgets/survey_category_chip.dart  ← FILE MỚI (thay thế file cũ)
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../logic/survey_provider.dart';

class SurveyCategoryChip extends ConsumerWidget {
  final String label;

  const SurveyCategoryChip({super.key, required this.label});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selected = ref.watch(surveyProvider).favoriteCategories;
    final isSelected = selected.contains(label);

    return GestureDetector(
      onTap: () => ref.read(surveyProvider.notifier).toggleCategory(label),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFFFB901) : Colors.transparent,
          borderRadius: BorderRadius.circular(30.r),
          border: Border.all(
            color: isSelected ? const Color(0xFFFFB901) : const Color(0xFF8F8F8F),
            width: 1.5,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : const Color(0xFF8F8F8F),
            fontSize: 16.sp,
            fontFamily: 'SF Pro',
            fontWeight: FontWeight.w400,
          ),
        ),
      ),
    );
  }
}