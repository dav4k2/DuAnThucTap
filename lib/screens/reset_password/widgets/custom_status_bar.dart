import 'package:flutter/material.dart';

class CustomStatusBar extends StatelessWidget {
  const CustomStatusBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 21, left: 16, right: 16, bottom: 19),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            '9:41',
            style: TextStyle(
              color: Colors.black,
              fontSize: 17,
              fontFamily: 'SF Pro',
              fontWeight: FontWeight.w600,
              height: 1.29,
            ),
          ),
          Row(
            children: [
              Opacity(
                opacity: 0.35,
                child: Container(
                  width: 25,
                  height: 13,
                  decoration: BoxDecoration(
                    border: Border.all(width: 1, color: Colors.black),
                    borderRadius: BorderRadius.circular(4.3),
                  ),
                ),
              ),
              const SizedBox(width: 6),
              Container(
                width: 21,
                height: 9,
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(2.5),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
