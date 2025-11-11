// lib/navbar/ios_navbar.dart
import 'package:flutter/cupertino.dart';
import 'package:cupertino_native/cupertino_native.dart';

class NavBarIOS extends StatefulWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const NavBarIOS({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  State<NavBarIOS> createState() => _NavBarIOSState();
}

class _NavBarIOSState extends State<NavBarIOS> {
  // Danh sách tab – giữ nguyên như hướng dẫn pub.dev
  final List<CNTabBarItem> _items = const [
    CNTabBarItem(label: 'Trang chủ', icon: CNSymbol('house.fill')),
    CNTabBarItem(label: 'Tìm kiếm', icon: CNSymbol('magnifyingglass')),
    CNTabBarItem(label: 'Tạo mới', icon: CNSymbol('plus.app.fill')),
    CNTabBarItem(label: 'Hồ sơ', icon: CNSymbol('person.crop.circle')),
    CNTabBarItem(label: 'Cài đặt', icon: CNSymbol('gearshape.fill')),
  ];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      bottom: false, //
      child: Padding(
        // CHỈNH VỊ TRÍ TẠI ĐÂY
        padding: EdgeInsets.symmetric(
          horizontal: 0, //
        ),
        child: CNTabBar(
          items: _items,
          currentIndex: widget.currentIndex,
          tint: CupertinoColors.systemRed, // Màu khi active
          height: 90,
          onTap: widget.onTap,
        ),
      ),
    );
  }
}