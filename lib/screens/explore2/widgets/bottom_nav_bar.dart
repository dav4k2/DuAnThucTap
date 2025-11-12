import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../logic/home_provider.dart';

class BottomNavBar extends ConsumerWidget {
  const BottomNavBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedIndex = ref.watch(selectedIndexProvider);

    return BottomNavigationBar(
      currentIndex: selectedIndex,
      onTap: (i) => ref.read(selectedIndexProvider.notifier).state = i,
      selectedItemColor: Colors.orange,
      unselectedItemColor: Colors.black54,
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Trang chủ'),
        BottomNavigationBarItem(icon: Icon(Icons.add), label: 'Thêm công thức'),
        BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Hồ sơ'),
        BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'Cài đặt'),
      ],
    );
  }
}
