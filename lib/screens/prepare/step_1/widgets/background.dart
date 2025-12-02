import 'package:flutter/material.dart';

class StepBackground1 extends StatelessWidget {
  final Widget child;

  const StepBackground1({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: ShapeDecoration(
        color: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(50),
        ),
      ),
      child: child,
    );
  }
}
