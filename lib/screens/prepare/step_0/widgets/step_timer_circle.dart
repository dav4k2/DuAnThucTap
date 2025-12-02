// File: step_timer_circle.dart
import 'package:flutter/material.dart';
import 'dart:async';

class StepTimerCircle extends StatefulWidget {
  const StepTimerCircle({super.key});

  @override
  State<StepTimerCircle> createState() => _StepTimerCircleState();
}

class _StepTimerCircleState extends State<StepTimerCircle> {
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

  void _resetTimer() {
    setState(() {
      _timeLeft = _totalTime;
    });
    _startTimer();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double progress = _timeLeft / _totalTime;

    return Positioned(
      top: 120,
      left: 0,
      right: 0,
      child: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // 1. Vòng đếm thời gian
            Stack(
              alignment: Alignment.center,
              children: [
                // Vòng nền trắng mờ
                SizedBox(
                  width: 140,
                  height: 140,
                  child: CircularProgressIndicator(
                    value: 1.0,
                    strokeWidth: 14,
                    backgroundColor: Colors.white.withOpacity(0.3),
                    valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                ),

                // Vòng xanh lá giảm dần theo thời gian
                SizedBox(
                  width: 140,
                  height: 140,
                  child: CircularProgressIndicator(
                    value: progress,
                    strokeWidth: 14,
                    backgroundColor: Colors.transparent,
                    valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF22DB53)),
                  ),
                ),

                // Vòng vàng/cam bên trong
                Container(
                  width: 120,
                  height: 120,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Color(0xFFFFA500),
                  ),
                  child: Center(
                    child: Text(
                      "$_timeLeft",
                      style: const TextStyle(
                        fontSize: 64,
                        fontWeight: FontWeight.w800,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
              ],
            ),

            // 2. Khoảng cách giữa vòng tròn và nút
            const SizedBox(width: 32),

            // 3. Mũi tên ">" bên phải
            GestureDetector(
              onTap: _resetTimer,
              child: const Icon(
                Icons.arrow_forward_ios,
                color: Colors.black,
                size: 40,
              ),
            ),
          ],
        ),
      ),
    );
  }
}