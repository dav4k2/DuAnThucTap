// lib/widgets/recipe_run_widgets.dart
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:fontend/screens/Cooking_step/recipe_step_model.dart';

import 'cooking_timer_service.dart';

// --- HEADER, TITLE, DESCRIPTION, IMAGE (GIỮ NGUYÊN) ---
class RecipeRunHeader extends StatelessWidget {
  final VoidCallback onTapBack;
  const RecipeRunHeader({super.key, required this.onTapBack});
  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 50, left: 16,
      child: GestureDetector(
        onTap: onTapBack,
        child: const Icon(Icons.arrow_back, size: 30, color: Colors.black),
      ),
    );
  }
}

class RecipeRunTitle extends StatelessWidget {
  final int stepIndex;
  const RecipeRunTitle({super.key, required this.stepIndex});
  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 100, left: 0, right: 0,
      child: Text("Bước ${stepIndex + 1}", textAlign: TextAlign.center, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w700, fontFamily: "SF Pro Rounded")),
    );
  }
}

class RecipeRunDescription extends StatelessWidget {
  final String text;
  const RecipeRunDescription({super.key, required this.text});
  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 150, left: 24, right: 24,
      child: Text(text, textAlign: TextAlign.center, style: const TextStyle(fontSize: 16, height: 1.4, color: Colors.black54)),
    );
  }
}

class RecipeRunImage extends StatelessWidget {
  final String imagePath;
  const RecipeRunImage({super.key, required this.imagePath});
  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 240, left: 20, right: 20,
      child: Container(
        height: 200,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          image: DecorationImage(image: AssetImage(imagePath), fit: BoxFit.cover, onError: (e, s) => const AssetImage("image/p3.png")),
        ),
      ),
    );
  }
}

// ============================================================
// BOTTOM CARD - WITH LIVE ACTIVITIES INTEGRATION
// ============================================================

class RecipeSmartBottomCard extends StatefulWidget {
  final RecipeStep stepData;
  final RecipeStep? nextStepData;
  final VoidCallback onNextPage;
  final VoidCallback onPrevPage;
  final int stepNumber;

  const RecipeSmartBottomCard({
    super.key,
    required this.stepData,
    required this.nextStepData,
    required this.onNextPage,
    required this.onPrevPage,
    required this.stepNumber,
  });

  @override
  State<RecipeSmartBottomCard> createState() => _RecipeSmartBottomCardState();
}

class _RecipeSmartBottomCardState extends State<RecipeSmartBottomCard> {
  late bool _isPreparing;
  Timer? _timer;
  late int _currentTime;
  bool _isPaused = true;
  bool _hasStartedOnce = false;

  final Color _greenColor = const Color(0xFF00C853);
  final _timerService = CookingTimerService();

  @override
  void initState() {
    super.initState();
    _initializeService();
    _initStep();
  }

  Future<void> _initializeService() async {
    await _timerService.initialize();
  }

  @override
  void didUpdateWidget(RecipeSmartBottomCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.stepData != widget.stepData) {
      _initStep();
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _initStep() {
    _timer?.cancel();
    _timerService.stopTimer();

    _isPreparing = true;
    _currentTime = widget.stepData.prepTime;
    _isPaused = false;
    _hasStartedOnce = false;
    _startTimer();
  }

  void _startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_isPaused) return;

      if (_currentTime > 0) {
        setState(() {
          _currentTime--;
        });
      } else {
        if (_isPreparing) {
          timer.cancel();
          _switchToCookingMode();
        } else {
          timer.cancel();
        }
      }
    });
  }

  void _switchToCookingMode() {
    setState(() {
      _isPreparing = false;
      _currentTime = widget.stepData.cookingTime;
      _isPaused = true;
      _hasStartedOnce = false;
    });
  }

  Future<void> _onMainButtonTap() async {
    if (widget.stepData.cookingTime == 0) {
      widget.onNextPage();
      return;
    }

    setState(() {
      if (!_hasStartedOnce) {
        _hasStartedOnce = true;
      }
      _isPaused = !_isPaused;
    });

    if (!_isPaused) {
      // Starting timer
      _startTimer();

      // Start background timer service
      await _timerService.startTimer(
        durationSeconds: _currentTime,
        stepTitle: widget.stepData.title,
        stepNumber: widget.stepNumber,
      );

      // Force update notification ngay lập tức nếu app ở background
      await _timerService.forceUpdateNotification();
    } else {
      // Pausing timer
      await _timerService.pauseTimer();

      // Force update notification ngay lập tức nếu app ở background
      await _timerService.forceUpdateNotification();
    }
  }

  String _formatTime(int totalSeconds) {
    int minutes = totalSeconds ~/ 60;
    int seconds = totalSeconds % 60;
    return "${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}";
  }

  // --- UI BUILD ---
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final bottomPadding = MediaQuery.of(context).padding.bottom;

    return Positioned(
      bottom: 0, left: 0, right: 0,
      child: Container(
        height: size.height * 0.42,
        padding: EdgeInsets.fromLTRB(20, 20, 20, bottomPadding + 10),
        decoration: const BoxDecoration(
          color: Color(0xFFFFC107),
          borderRadius: BorderRadius.vertical(top: Radius.circular(40), bottom: Radius.circular(0)),
        ),
        child: _isPreparing
            ? _buildTransitionUI()
            : _buildCookingUI(),
      ),
    );
  }

  Widget _buildTransitionUI() {
    double progress = widget.stepData.prepTime == 0 ? 0 : _currentTime / widget.stepData.prepTime;
    return Column(
      children: [
        const SizedBox(height: 10),
        const Text("Hãy sẵn sàng cho bước tiếp theo!", style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600, fontFamily: "SF Pro Rounded")),
        const SizedBox(height: 8),
        Text(widget.stepData.title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500, fontFamily: "SF Pro Rounded", color: Colors.black87)),
        const Spacer(),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(flex: 3),
              SizedBox(
                width: 120, height: 120,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    SizedBox.expand(child: CircularProgressIndicator(value: 1.0, strokeWidth: 16, color: Colors.white.withOpacity(0.4))),
                    SizedBox.expand(child: CircularProgressIndicator(value: progress, strokeWidth: 16, color: _greenColor, strokeCap: StrokeCap.round)),
                    Text(_currentTime.toString(), style: const TextStyle(fontSize: 92, fontWeight: FontWeight.w800, fontFamily: "SF Pro Rounded", color: Colors.black, height: 1.0)),
                  ],
                ),
              ),
              const Spacer(flex: 2),
              GestureDetector(onTap: _switchToCookingMode, child: const Icon(Icons.arrow_forward_ios, size: 35, color: Colors.black87)),
              const SizedBox(width: 10),
            ],
          ),
        ),
        const Spacer(flex: 2),
      ],
    );
  }

  Widget _buildCookingUI() {
    String btnText;
    IconData btnIcon;
    if (widget.stepData.cookingTime == 0) {
      btnText = "Hoàn thành"; btnIcon = Icons.check;
    } else if (!_hasStartedOnce) {
      btnText = "Bắt đầu"; btnIcon = Icons.play_arrow;
    } else if (_isPaused) {
      btnText = "Tiếp tục"; btnIcon = Icons.play_arrow;
    } else {
      btnText = "Tạm dừng"; btnIcon = Icons.pause;
    }

    return Column(
      children: [
        const SizedBox(height: 10),
        Text(widget.stepData.title, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w600, fontFamily: "SF Pro Rounded")),
        const Spacer(),
        Text(_formatTime(_currentTime), style: const TextStyle(fontSize: 60, fontWeight: FontWeight.w800, fontFamily: "SF Pro Rounded", color: Colors.black)),
        const Spacer(),
        GestureDetector(
          onTap: _onMainButtonTap,
          child: Container(
            width: 250, height: 60,
            decoration: BoxDecoration(color: _greenColor, borderRadius: BorderRadius.circular(30)),
            alignment: Alignment.center,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(btnIcon, color: Colors.white, size: 32),
                const SizedBox(width: 8),
                Text(btnText, style: const TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.w600, fontFamily: "SF Pro Rounded")),
              ],
            ),
          ),
        ),
        const SizedBox(height: 25),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              GestureDetector(
                onTap: () {
                  _timerService.stopTimer();
                  widget.onPrevPage();
                },
                child: const Text("Trước đó", style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
              ),
              Container(width: 1.5, height: 20, color: Colors.black87),
              GestureDetector(
                onTap: () {
                  _timerService.stopTimer();
                  widget.onNextPage();
                },
                child: Text(widget.nextStepData == null ? "Hoàn thành" : "Bỏ qua", style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
              ),
            ],
          ),
        ),
      ],
    );
  }
}