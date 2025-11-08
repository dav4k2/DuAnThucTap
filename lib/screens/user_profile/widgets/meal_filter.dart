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

    return Stack(
      children: [
        _item('Tất cả', 24.w, 545.h, MealTab.tatCa, cur == MealTab.tatCa, notifier),
        _item('Bữa sáng', 113.w, 545.h, MealTab.buaSang, cur == MealTab.buaSang, notifier),
        _item('Bữa trưa', 202.w, 545.h, MealTab.buaTrua, cur == MealTab.buaTrua, notifier),
        _item('Ăn vặt', 291.w, 546.h, MealTab.anVat, cur == MealTab.anVat, notifier),
      ],
    );
  }

  Widget _item(String text, double left, double top, MealTab tab, bool active, StateController<MealTab> notifier) {
    return Positioned(
      left: left,
      top: top,
      child: GestureDetector(
        onTap: () => notifier.state = tab,
        child: Container(
          width: 73.w,
          height: 25.h,
          decoration: BoxDecoration(
            color: active ? const Color(0xFFFFB901) : const Color(0xFFD9D9D9),
            borderRadius: BorderRadius.circular(30.r),
          ),
          alignment: Alignment.center,
          child: Text(text, style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w300, height: 1.69)),
        ),
      ),
    );
  }
}