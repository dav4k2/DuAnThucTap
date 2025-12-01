import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../logic/interest_provider.dart';

class CategoryGrid extends ConsumerWidget {
  const CategoryGrid({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selected = ref.watch(selectedCategoriesProvider);

    final categories = [
      'Healthy', 'Đồ cay', 'Đồ ngọt', 'Đồ ăn nhanh', 'Mỳ', 'Ăn sáng', 'Bánh',
      'Súp', 'Đồ chay', 'Ăn trưa', 'Ăn tối', 'Đồ chua', 'Ăn vặt', 'Salad',
      'Món nước', 'Món khô', 'Món trộn', 'Cháo', 'Món Âu', 'Món Á', 'Cơm',
      'Bánh kẹp', 'Pizza', 'Đường phố'
    ];

    final width = MediaQuery.of(context).size.width;
    final crossAxisCount = width < 400 ? 3 : 4;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: categories.length,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: crossAxisCount,
          mainAxisSpacing: 16,
          crossAxisSpacing: 10,
          childAspectRatio: 2.5,
        ),
        itemBuilder: (context, index) {
          final item = categories[index];
          final isSelected = selected.contains(item);

          return GestureDetector(
            onTap: () {
              final current = [...selected];
              if (isSelected) {
                current.remove(item);
              } else {
                current.add(item);
              }
              ref.read(selectedCategoriesProvider.notifier).state = current;
            },
            child: Container(
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: isSelected ? const Color(0xFFFFC735) : Colors.grey[200],
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                item,
                style: TextStyle(
                  color: isSelected ? Colors.white : Colors.grey[700],
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
