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
        const SnackBar(
          content: Text("Vui lòng tắt chế độ Tạm dừng để bật thông báo"),
          backgroundColor: Colors.redAccent,
          duration: Duration(seconds: 2),
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
        title: const Text(
          'Cài đặt thông báo',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
        ),
        centerTitle: true,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(left: 28, top: 10),
            child: Text(
              'Thông báo đẩy',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
            ),
          ),
          const SizedBox(height: 20),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 28),
              children: [
                _buildMasterSwitch(),
                const SizedBox(height: 32),
                _buildSwitchRow(
                  title: 'Chế độ ngủ',
                  value: effectiveSleep,
                  actualValue: sleepMode,
                  onChanged: (v) => _handleToggle('Chế độ ngủ', v, (val) => sleepMode = val),
                ),
                const SizedBox(height: 28),
                _buildSwitchRow(
                  title: 'Bài viết và bình luận',
                  value: effectivePost,
                  actualValue: postAndComment,
                  onChanged: (v) => _handleToggle('Bài viết và bình luận', v, (val) => postAndComment = val),
                ),
                const SizedBox(height: 28),
                _buildSwitchRow(
                  title: 'Theo dõi và người theo dõi',
                  value: effectiveFollow,
                  actualValue: followNotifications,
                  onChanged: (v) => _handleToggle('Theo dõi và người theo dõi', v, (val) => followNotifications = val),
                ),
                const SizedBox(height: 28),
                _buildSwitchRow(
                  title: 'Thông báo qua email',
                  value: effectiveEmail,
                  actualValue: emailNotifications,
                  onChanged: (v) => _handleToggle('Thông báo qua email', v, (val) => emailNotifications = val),
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
          const Text(
            'Tạm dừng tất cả',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
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
        // Không set màu → để theme tự động dark/light
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 19, fontWeight: FontWeight.w600),
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
