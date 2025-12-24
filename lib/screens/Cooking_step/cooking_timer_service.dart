// lib/services/cooking_timer_service.dart
import 'dart:async';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:live_activities/live_activities.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:workmanager/workmanager.dart';

class CookingTimerService {
  static final CookingTimerService _instance = CookingTimerService._internal();
  factory CookingTimerService() => _instance;
  CookingTimerService._internal();

  final FlutterLocalNotificationsPlugin _notificationsPlugin =
  FlutterLocalNotificationsPlugin();

  Timer? _backgroundTimer;

  // Track app state
  bool _isAppInForeground = true;

  // Timer state
  int _remainingSeconds = 0;
  bool _isRunning = false;
  String _stepTitle = '';
  int _stepNumber = 0;

  // Getters
  int get remainingSeconds => _remainingSeconds;
  bool get isRunning => _isRunning;

  // Set app foreground state
  void setAppInForeground(bool isInForeground) {
    _isAppInForeground = isInForeground;
    if (isInForeground) {
      // App vào foreground -> ẩn notification NGAY LẬP TỨC
      _notificationsPlugin.cancel(999);
    } else {
      // App vào background -> hiện notification nếu timer đang chạy
      if (_isRunning && _remainingSeconds > 0) {
        _updateNotification();
      }
    }
  }

  // Force update notification immediately (khi pause/resume)
  Future<void> forceUpdateNotification() async {
    if (!_isAppInForeground && _isRunning && _remainingSeconds > 0) {
      await _updateNotification();
    }
  }

  // Initialize service
  Future<void> initialize() async {
    await _initNotifications();
    await _restoreTimerState();
  }

  // Initialize local notifications
  Future<void> _initNotifications() async {
    const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosSettings = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    const settings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await _notificationsPlugin.initialize(
      settings,
      onDidReceiveNotificationResponse: _onNotificationTap,
    );

    // Request permissions và setup foreground service behavior
    if (Platform.isAndroid) {
      final androidPlugin = _notificationsPlugin
          .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>();

      await androidPlugin?.requestNotificationsPermission();

      // Enable foreground service behavior
      await androidPlugin?.requestExactAlarmsPermission();
    }
  }

  // Handle notification action
  void _onNotificationTap(NotificationResponse response) {
    if (response.actionId == 'stop_timer') {
      // Người dùng bấm "Dừng" trên notification
      stopTimer();
    }
  }

  // Start cooking timer
  Future<void> startTimer({
    required int durationSeconds,
    required String stepTitle,
    required int stepNumber,
  }) async {
    _remainingSeconds = durationSeconds;
    _stepTitle = stepTitle;
    _stepNumber = stepNumber;
    _isRunning = true;

    await _saveTimerState();
    await _startLiveActivity();
    await _startBackgroundTimer();

    // Tạo foreground service notification cho Android
    if (Platform.isAndroid) {
      await _startForegroundService();
    }
  }

  // Start foreground service (Android only)
  Future<void> _startForegroundService() async {
    try {
      const androidDetails = AndroidNotificationDetails(
        'cooking_timer_foreground',
        'Timer đang chạy',
        channelDescription: 'Giữ timer chạy trong background',
        importance: Importance.low,
        priority: Priority.low,
        ongoing: true,
        autoCancel: false,
        showWhen: false,
        playSound: false,
        enableVibration: false,
        category: AndroidNotificationCategory.service,
        visibility: NotificationVisibility.secret, // Ẩn nội dung
      );

      const details = NotificationDetails(android: androidDetails);

      await _notificationsPlugin.show(
        998, // ID khác với notification hiển thị
        'Timer đang chạy',
        'Đang theo dõi thời gian nấu ăn',
        details,
      );
    } catch (e) {
      debugPrint('Error starting foreground service: $e');
    }
  }

  // Pause timer
  Future<void> pauseTimer() async {
    _isRunning = false;
    _backgroundTimer?.cancel();
    await _saveTimerState();
    await _updateLiveActivity();
  }

  // Resume timer
  Future<void> resumeTimer() async {
    _isRunning = true;
    await _saveTimerState();
    await _startBackgroundTimer();
    await _updateLiveActivity();
  }

  // Stop timer completely
  Future<void> stopTimer() async {
    _isRunning = false;
    _remainingSeconds = 0;
    _backgroundTimer?.cancel();

    await _clearTimerState();
    await _endLiveActivity();
    await _notificationsPlugin.cancel(999); // Timer notification
    await _notificationsPlugin.cancel(998); // Foreground service notification
  }

  // Start background timer
  Future<void> _startBackgroundTimer() async {
    _backgroundTimer?.cancel();

    _backgroundTimer = Timer.periodic(const Duration(seconds: 1), (timer) async {
      if (!_isRunning) return;

      if (_remainingSeconds > 0) {
        _remainingSeconds--;
        await _saveTimerState();

        // Update mỗi 5 giây - CHỈ KHI APP Ở BACKGROUND
        if (_remainingSeconds % 5 == 0 && !_isAppInForeground) {
          await _updateLiveActivity();
        }
      } else {
        timer.cancel();
        await _onTimerComplete();
      }
    });
  }

  // Timer completed
  Future<void> _onTimerComplete() async {
    _isRunning = false;
    await _showCompletionNotification();
    await _endLiveActivity();
    await _clearTimerState();
  }

  // Start Live Activity (iOS Dynamic Island / Android simulation)
  Future<void> _startLiveActivity() async {
    try {
      // Chỉ hiện notification khi app ở background
      if (!_isAppInForeground) {
        await _updateNotification();
      }
    } catch (e) {
      debugPrint('Error starting notification: $e');
    }
  }

  // Update Live Activity
  Future<void> _updateLiveActivity() async {
    try {
      // Chỉ update notification khi app ở background
      if (!_isAppInForeground) {
        await _updateNotification();
      }
    } catch (e) {
      debugPrint('Error updating notification: $e');
    }
  }

  // End Live Activity
  Future<void> _endLiveActivity() async {
    try {
      await _notificationsPlugin.cancel(999);
    } catch (e) {
      debugPrint('Error ending notification: $e');
    }
  }

  // Update notification (Android & iOS)
  Future<void> _updateNotification() async {
    final minutes = _remainingSeconds ~/ 60;
    final seconds = _remainingSeconds % 60;
    final timeString = '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';

    final androidDetails = AndroidNotificationDetails(
      'cooking_timer_channel',
      'Đồng hồ nấu ăn',
      channelDescription: 'Hiển thị thời gian nấu ăn',
      importance: Importance.high,
      priority: Priority.high,
      ongoing: true,
      autoCancel: false,
      showWhen: false,
      usesChronometer: false,
      chronometerCountDown: true,
      category: AndroidNotificationCategory.progress,
      styleInformation: BigTextStyleInformation(
        'Thời gian còn lại: $timeString',
        contentTitle: 'Bước $_stepNumber: $_stepTitle',
        summaryText: _isRunning ? '⏱️ Đang nấu...' : '⏸️ Tạm dừng',
      ),
    );

    const iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: false,
      interruptionLevel: InterruptionLevel.timeSensitive,
    );

    final details = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    await _notificationsPlugin.show(
      999,
      'Bước $_stepNumber: $_stepTitle',
      '⏱️ Thời gian: $timeString ${_isRunning ? "(Đang đếm)" : "(Tạm dừng)"}',
      details,
    );
  }

  // Show completion notification
  Future<void> _showCompletionNotification() async {
    const androidDetails = AndroidNotificationDetails(
      'cooking_complete_channel',
      'Hoàn thành nấu ăn',
      channelDescription: 'Thông báo khi hoàn thành bước nấu',
      importance: Importance.max,
      priority: Priority.high,
      playSound: true,
      enableVibration: true,
    );

    const iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
      sound: 'default',
    );

    const details = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    await _notificationsPlugin.show(
      998,
      '✅ Hoàn thành!',
      'Bước $_stepNumber: $_stepTitle đã hoàn tất',
      details,
    );
  }

  // Save timer state to SharedPreferences
  Future<void> _saveTimerState() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('remaining_seconds', _remainingSeconds);
    await prefs.setBool('is_running', _isRunning);
    await prefs.setString('step_title', _stepTitle);
    await prefs.setInt('step_number', _stepNumber);
    await prefs.setInt('last_update', DateTime.now().millisecondsSinceEpoch);
  }

  // Restore timer state
  Future<void> _restoreTimerState() async {
    final prefs = await SharedPreferences.getInstance();

    final lastUpdate = prefs.getInt('last_update');
    if (lastUpdate == null) return;

    _remainingSeconds = prefs.getInt('remaining_seconds') ?? 0;
    _isRunning = prefs.getBool('is_running') ?? false;
    _stepTitle = prefs.getString('step_title') ?? '';
    _stepNumber = prefs.getInt('step_number') ?? 0;

    if (_isRunning && _remainingSeconds > 0) {
      // Calculate elapsed time while app was closed
      final now = DateTime.now().millisecondsSinceEpoch;
      final elapsedSeconds = (now - lastUpdate) ~/ 1000;

      _remainingSeconds = (_remainingSeconds - elapsedSeconds).clamp(0, double.infinity).toInt();

      if (_remainingSeconds > 0) {
        await _startBackgroundTimer();
        await _updateLiveActivity();
      } else {
        await _onTimerComplete();
      }
    }
  }

  // Clear timer state
  Future<void> _clearTimerState() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('remaining_seconds');
    await prefs.remove('is_running');
    await prefs.remove('step_title');
    await prefs.remove('step_number');
    await prefs.remove('last_update');
  }
}