import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../logic/cook_level_provider.dart';

class CookingOptionButton extends ConsumerWidget {
  final String label;
  const CookingOptionButton({super.key, required this.label});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selected = ref.watch(cookingLevelProvider);

    final isActive = selected == label;
    final color = isActive ? const Color(0xFFFFB901) : Colors.black;
    final borderColor = isActive ? const Color(0xFFFFB901) : Colors.black26;

    return GestureDetector(
      onTap: () => ref.read(cookingLevelProvider.notifier).state = label,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: borderColor, width: 1),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 4,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 26,
              height: 26,
              margin: const EdgeInsets.only(right: 16),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: borderColor, width: 1),
              ),
              child: isActive
                  ? Center(
                child: Container(
                  width: 14,
                  height: 14,
                  decoration: BoxDecoration(
                    color: color,
                    shape: BoxShape.circle,
                  ),
                ),
              )
                  : null,
            ),
            Expanded(
              child: Text(
                label,
                style: TextStyle(
                  color: color,
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                  fontFamily: 'SF Pro Rounded',
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
