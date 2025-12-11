import 'package:easy_localization/easy_localization.dart'; // <--- 1. IMPORT
import 'package:flutter/material.dart';

class NotificationSettingsScreen extends StatefulWidget {
  const NotificationSettingsScreen({Key? key}) : super(key: key);

  @override
  State<NotificationSettingsScreen> createState() => _NotificationSettingsScreenState();
}

class _NotificationSettingsScreenState extends State<NotificationSettingsScreen> {
  bool isPaused = false;
  bool postAndComment = true;
  bool sleepMode = false;
  bool followNotifications = true;
  bool emailNotifications = true;

  void _handleToggle(String notificationName, bool newValue, Function(bool) setter) {
    if (isPaused && newValue) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("turn_off_pause_warning".tr()), // <--- 2. DỊCH CẢNH BÁO
          backgroundColor: Colors.redAccent,
          duration: const Duration(seconds: 2),
        ),
      );
      return;
    }
    setState(() {
      setter(newValue);
    });
  }

  @override
  Widget build(BuildContext context) {
    // Logic giữ nguyên
    final effectivePost = isPaused ? false : postAndComment;
    final effectiveSleep = isPaused ? false : sleepMode;
    final effectiveFollow = isPaused ? false : followNotifications;
    final effectiveEmail = isPaused ? false : emailNotifications;

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'notifications_title'.tr(), // <--- 3. DỊCH TIÊU ĐỀ
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
        ),
        centerTitle: true,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 28, top: 10),
            child: Text(
              'push_header'.tr(), // <--- 4. DỊCH HEADER
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
            ),
          ),
          const SizedBox(height: 20),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 28),
              children: [
                _buildMasterSwitch(),
                const SizedBox(height: 32),

                // --- CÁC MỤC BÊN DƯỚI ĐÃ ĐƯỢC DỊCH ---
                _buildSwitchRow(
                  title: 'sleep_mode_toggle'.tr(),
                  value: effectiveSleep,
                  actualValue: sleepMode,
                  onChanged: (v) => _handleToggle('sleep_mode_toggle', v, (val) => sleepMode = val),
                ),
                const SizedBox(height: 28),
                _buildSwitchRow(
                  title: 'posts_comments'.tr(),
                  value: effectivePost,
                  actualValue: postAndComment,
                  onChanged: (v) => _handleToggle('posts_comments', v, (val) => postAndComment = val),
                ),
                const SizedBox(height: 28),
                _buildSwitchRow(
                  title: 'follow_notif'.tr(),
                  value: effectiveFollow,
                  actualValue: followNotifications,
                  onChanged: (v) => _handleToggle('follow_notif', v, (val) => followNotifications = val),
                ),
                const SizedBox(height: 28),
                _buildSwitchRow(
                  title: 'email_notif'.tr(),
                  value: effectiveEmail,
                  actualValue: emailNotifications,
                  onChanged: (v) => _handleToggle('email_notif', v, (val) => emailNotifications = val),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMasterSwitch() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'pause_all'.tr(), // <--- 5. DỊCH NÚT TẠM DỪNG
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
          ),
          GestureDetector(
            onTap: () => setState(() => isPaused = !isPaused),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              width: 76,
              height: 42,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                color: isPaused ? const Color(0xFFFFB901) : Colors.grey.shade300,
                boxShadow: isPaused
                    ? [BoxShadow(color: const Color(0xFFFFB901).withOpacity(0.5), blurRadius: 12, offset: const Offset(0, 4))]
                    : null,
              ),
              padding: const EdgeInsets.all(3),
              child: AnimatedAlign(
                duration: const Duration(milliseconds: 300),
                alignment: isPaused ? Alignment.centerRight : Alignment.centerLeft,
                child: Container(
                  width: 36,
                  height: 36,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white,
                    boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 6, offset: Offset(0, 2))],
                  ),
                  child: Icon(
                    isPaused ? Icons.pause_rounded : Icons.notifications_active_rounded,
                    size: 20,
                    color: isPaused ? const Color(0xFFFFB901) : Colors.grey,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSwitchRow({
    required String title,
    required bool value,
    required bool actualValue,
    required ValueChanged<bool> onChanged,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 4),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Expanded giúp text không bị tràn nếu ngôn ngữ dịch quá dài
          Expanded(
            child: Text(
              title,
              style: const TextStyle(fontSize: 19, fontWeight: FontWeight.w600),
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeTrackColor: const Color(0xFFFFB901).withOpacity(0.5),
            activeColor: const Color(0xFFFFB901),
          ),
        ],
      ),
    );
  }
}