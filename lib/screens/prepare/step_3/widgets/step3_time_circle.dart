// File: step_timer_circle.dart
import 'package:flutter/material.dart';
import 'package:fontend/screens/prepare/step_3_3/step_3_3_screen.dart';
import 'dart:async';

class StepTimerCircle3 extends StatefulWidget {
  const StepTimerCircle3({super.key});

  @override
  State<StepTimerCircle3> createState() => _StepTimerCircleState();
}

class _StepTimerCircleState extends State<StepTimerCircle3> {
  int _timeLeft = 5;
  final int _totalTime = 5;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_timeLeft > 0) {
        setState(() {
          _timeLeft--;
        });
      } else {
        timer.cancel();
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double progress = _timeLeft / _totalTime;
    final width = MediaQuery.of(context).size.width;

    return Positioned(
      top: 120,
      left: 0,
      width: width,
      height: 160,
      child: Stack(
        // Căn giữa theo chiều dọc cho tất cả các con
        alignment: Alignment.center,
        children: [

          // ==================================================
          // 1. VÒNG TRÒN (Luôn ở chính giữa màn hình)
          // ==================================================
          SizedBox(
            width: 140,
            height: 140,
            child: Stack(
              alignment: Alignment.center,
              children: [
                // Vòng trắng nền
                SizedBox(
                  width: 140,
                  height: 140,
                  child: CircularProgressIndicator(
                    value: 1.0,
                    strokeWidth: 14,
                    backgroundColor: Colors.white,
                    valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                ),
                // Vòng đen tiến trình
                SizedBox(
                  width: 140,
                  height: 140,
                  child: CircularProgressIndicator(
                    value: progress,
                    strokeWidth: 14,
                    backgroundColor: Colors.transparent,
                    valueColor: const AlwaysStoppedAnimation<Color>(Colors.black),
                  ),
                ),
                // Số giây
                Text(
                  "$_timeLeft",
                  style: const TextStyle(
                    fontSize: 64,
                    fontWeight: FontWeight.w800,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
          ),

          // ==================================================
          // 2. NÚT CHUYỂN TIẾP
          // ==================================================
          Positioned(
            // 👇 CHỈNH SỐ NÀY ĐỂ THẲNG HÀNG VỚI CHỮ "THEO"
            // Nếu nút đang lệch phải quá -> Tăng số này lên (ví dụ 50, 60)
            // Nếu nút đang lệch trái quá -> Giảm số này xuống (ví dụ 30, 20)
            right: 40,

            child: GestureDetector(
              onTap: () {
                _timer?.cancel();
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const StepTimerScreen3(),
                  ),
                );
              },
              child: Container(
                color: Colors.transparent, // Tăng diện tích bấm
                padding: const EdgeInsets.all(10),
                child: const Icon(
                  Icons.arrow_forward_ios,
                  color: Colors.black,
                  size: 40,
                ),
              ),
            ),
          ),

        ],
      ),
    );
  }
}