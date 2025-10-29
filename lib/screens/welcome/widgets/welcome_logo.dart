///Sơn
///Logo
import 'package:flutter/material.dart';

class WelcomeLogo extends StatelessWidget {
  const WelcomeLogo({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 300,
      height: 300,
      margin: const EdgeInsets.symmetric(horizontal: 36),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(50),
        image: const DecorationImage(
          image: AssetImage("image/logo.png"),
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
