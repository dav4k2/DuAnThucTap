import 'package:flutter/material.dart';

class AppHeader extends StatelessWidget {
  const AppHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: const [
        Text(
          '9:41',
          style: TextStyle(fontSize: 17, fontWeight: FontWeight.w600),
        ),
        Icon(Icons.battery_full, color: Colors.black),
      ],
    );
  }
}
