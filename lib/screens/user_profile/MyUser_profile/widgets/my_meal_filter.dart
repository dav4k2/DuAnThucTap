// lib/widgets/my_meal_filter.dart
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../logic/my_profile_provider.dart';   // dùng provider của trang cá nhân

class MyMealFilter extends ConsumerWidget {
  const MyMealFilter({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cur = ref.watch(myMealTabProvider);           // đổi provider
    final notifier = ref.read(myMealTabProvider.notifier); // đổi provider

    final bgColor = Theme.of(context).scaffoldBackgroundColor;
    final textColor = Theme.of(context).textTheme.bodyMedium!.color!;

    return Padding(
      padding: EdgeInsets.only(top: 0.h),
      child: Container(
        color: bgColor,
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _chip(context, 'Tất cả'.tr(), MealTab.tatCa, cur == MealTab.tatCa, notifier, textColor),
            _chip(context, 'Bữa sáng'.tr(), MealTab.buaSang, cur == MealTab.buaSang, notifier, textColor),
            _chip(context, 'Bữa trưa'.tr(), MealTab.buaTrua, cur == MealTab.buaTrua, notifier, textColor),
            _chip(context, 'Ăn vặt'.tr(), MealTab.anVat, cur == MealTab.anVat, notifier, textColor),
          ],
        ),
      ),
    );
  }

  Widget _chip(
      BuildContext context,
      String text,
      MealTab tab,
      bool active,
      StateController<MealTab> notifier,
      Color textColor,
      ) {
    return Expanded(
      child: GestureDetector(
        onTap: () => notifier.state = tab,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          margin: EdgeInsets.symmetric(horizontal: 4.w),
          padding: EdgeInsets.symmetric(vertical: 8.h),
          decoration: BoxDecoration(
            color: active
                ? const Color(0xFFFFB901)
                : Theme.of(context).brightness == Brightness.dark
                ? Colors.white.withOpacity(0.15)
                : const Color(0xFFD9D9D9),
            borderRadius: BorderRadius.circular(25.r),
          ),
          alignment: Alignment.center,
          child: Text(
            text,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 13.sp,
              fontWeight: FontWeight.w500,
              color: active ? Colors.black : textColor,
              height: 1.2,
            ),
          ),
        ),
      ),
    );
  }
}