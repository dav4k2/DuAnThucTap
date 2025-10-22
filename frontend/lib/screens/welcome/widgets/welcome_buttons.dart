import 'package:flutter/material.dart';

class WelcomeButtons extends StatelessWidget {
  const WelcomeButtons({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 380, // giống container parent
      height: 70,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Nút Đăng nhập
          Expanded(
            child: ElevatedButton(
              onPressed: () {
                // TODO: thêm hành động đăng nhập
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(50),
                ),
                shadowColor: const Color(0x3F000000),
                elevation: 4,
                fixedSize: const Size.fromHeight(70),
              ),
              child: const Text(
                'Đăng nhập',
                style: TextStyle(
                  fontSize: 24,
                  fontFamily: 'SF Pro Rounded',
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                  height: 1.25,
                ),
              ),
            ),
          ),

          const SizedBox(width: 16), // khoảng cách giữa 2 nút

          // Nút Đăng ký
          Expanded(
            child: ElevatedButton(
              onPressed: () {
                // TODO: thêm hành động đăng ký
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                side: BorderSide(color: Colors.black.withOpacity(0.4)),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(50),
                ),
                shadowColor: const Color(0x3F000000),
                elevation: 4,
                fixedSize: const Size.fromHeight(70),
              ),
              child: const Text(
                'Đăng ký',
                style: TextStyle(
                  fontSize: 24,
                  fontFamily: 'SF Pro Rounded',
                  fontWeight: FontWeight.w700,
                  color: Colors.black,
                  height: 1.25,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
