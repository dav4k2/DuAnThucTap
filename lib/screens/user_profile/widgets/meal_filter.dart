// lib/widgets/meal_filter.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../logic/chef_provider.dart';

class MealFilter extends ConsumerWidget {
  const MealFilter({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cur = ref.watch(mealTabProvider);
    final notifier = ref.read(mealTabProvider.notifier);

    return Padding(
      padding: EdgeInsets.only(top: 0.h), // sát mép trên
      child: Container(
        color: Colors.white,
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _chip('Tất cả', MealTab.tatCa, cur == MealTab.tatCa, notifier),
            _chip('Bữa sáng', MealTab.buaSang, cur == MealTab.buaSang, notifier),
            _chip('Bữa trưa', MealTab.buaTrua, cur == MealTab.buaTrua, notifier),
            _chip('Ăn vặt', MealTab.anVat, cur == MealTab.anVat, notifier),
          ],
        ),
      ),
    );
  }

  Widget _chip(String text, MealTab tab, bool active, StateController<MealTab> notifier) {
    return Expanded(
      child: GestureDetector(
        onTap: () => notifier.state = tab,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          margin: EdgeInsets.symmetric(horizontal: 4.w),
          padding: EdgeInsets.symmetric(vertical: 8.h),
          decoration: BoxDecoration(
            color: active ? const Color(0xFFFFB901) : const Color(0xFFD9D9D9),
            borderRadius: BorderRadius.circular(25.r),
          ),
          alignment: Alignment.center,
          child: Text(
            text,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 13.sp,
              fontWeight: FontWeight.w500,
              color: Colors.black,
              height: 1.2,
            ),
          ),
        ),
      ),
    );
  }
}
