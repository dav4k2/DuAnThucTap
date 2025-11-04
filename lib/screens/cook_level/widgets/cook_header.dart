import 'package:flutter/material.dart';

class CookingHeader extends StatelessWidget {
  const CookingHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Row(
        children: [
          const Icon(Icons.arrow_back, color: Colors.black),
          const SizedBox(width: 12),
          Expanded(
            child: Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  width: width * 0.5,
                  height: 5,
                  decoration: BoxDecoration(
                    color: const Color(0xFFDADADA),
                    borderRadius: BorderRadius.circular(60),
                  ),
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Container(
                    width: width * 0.25,
                    height: 5,
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFC735),
                      borderRadius: BorderRadius.circular(60),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          const Text("1/2", style: TextStyle(color: Colors.black54)),
          const Spacer(),
          Text("Bỏ qua", style: TextStyle(color: Colors.black.withOpacity(0.7))),
        ],
      ),
    );
  }
}
