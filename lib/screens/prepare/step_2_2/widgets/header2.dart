import 'package:flutter/material.dart';

class StepHeader2 extends StatelessWidget {
  const StepHeader2({super.key});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 20,
      left: 16,
      right: 16,
      child: Padding(
        padding: const EdgeInsets.only(top: 30), // ↓ hạ xuống thêm
        child: Row(
          children: [
            GestureDetector(
              onTap: () => Navigator.pop(context),
              child: const Icon(Icons.arrow_back, size: 28),
            ),
          ],
        ),
      ),
    );
  }
}
