import 'package:flutter/material.dart';

void main() {
  runApp(const MaterialApp(
    home: NotificationSettingsScreen(),
    debugShowCheckedModeBanner: false,
  ));
}

class NotificationSettingsScreen extends StatefulWidget {
  const NotificationSettingsScreen({Key? key}) : super(key: key);

  @override
  State<NotificationSettingsScreen> createState() => _NotificationSettingsScreenState();
}

class _NotificationSettingsScreenState extends State<NotificationSettingsScreen> {
  // --- Biến trạng thái ---
  bool isPaused = false; // Tạm dừng tất cả
  bool postAndComment = true;
  bool sleepMode = false;
  bool followNotifications = true;
  bool emailNotifications = true;

  // Xóa bỏ hàm _showToggleDialog

  // --- Hàm xử lý thay đổi trạng thái thông báo ---
  // Hàm này kiểm tra isPaused trước khi cho phép bật thông báo
  void _handleToggle(String notificationName, bool newValue, Function(bool) setter) {
    // 1. Nếu đang TẠM DỪNG và người dùng đang cố gắng BẬT (newValue = true) một thông báo
    if (isPaused && newValue) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Vui lòng tắt chế độ Tạm dừng để bật thông báo"),
          backgroundColor: Colors.redAccent,
          duration: Duration(seconds: 2),
        ),
      );
      // Ngăn không cho trạng thái thay đổi (Switch sẽ trở lại vị trí cũ)
      return;
    }

    // 2. Nếu không bị tạm dừng hoặc người dùng đang TẮT thông báo
    setState(() {
      setter(newValue);
    });
  }

  @override
  Widget build(BuildContext context) {
    // Giá trị hiển thị thực tế (bị TẮT nếu isPaused = true)
    final bool effectivePost = isPaused ? false : postAndComment;
    final bool effectiveSleep = isPaused ? false : sleepMode;
    final bool effectiveFollow = isPaused ? false : followNotifications;
    final bool effectiveEmail = isPaused ? false : emailNotifications;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Cài đặt thông báo',
          style: TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.w700,
            fontFamily: 'SF Pro Rounded',
          ),
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
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600, color: Colors.black87),
            ),
          ),
          const SizedBox(height: 20),

          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 28),
              children: [
                // TẠM DỪNG - Switch vàng đẹp
                _buildMasterSwitch(),

                const SizedBox(height: 32),

                // Các mục khác đã được thay bằng Switch
                _buildSwitchRow(
                  title: 'Chế độ ngủ',
                  value: effectiveSleep,
                  actualValue: sleepMode,
                  onChanged: (newValue) => _handleToggle('Chế độ ngủ', newValue, (val) => sleepMode = val),
                ),
                const SizedBox(height: 28),
                _buildSwitchRow(
                  title: 'Bài viết và bình luận',
                  value: effectivePost,
                  actualValue: postAndComment,
                  onChanged: (newValue) => _handleToggle('Bài viết và bình luận', newValue, (val) => postAndComment = val),
                ),
                const SizedBox(height: 28),
                _buildSwitchRow(
                  title: 'Theo dõi và người theo dõi',
                  value: effectiveFollow,
                  actualValue: followNotifications,
                  onChanged: (newValue) => _handleToggle('Theo dõi và người theo dõi', newValue, (val) => followNotifications = val),
                ),
                const SizedBox(height: 28),
                _buildSwitchRow(
                  title: 'Thông báo qua email',
                  value: effectiveEmail,
                  actualValue: emailNotifications,
                  onChanged: (newValue) => _handleToggle('Thông báo qua email', newValue, (val) => emailNotifications = val),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Switch chính "Tạm dừng" - giữ nguyên
  Widget _buildMasterSwitch() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            'Tạm dừng tất cả',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600, color: Colors.black87),
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
                    color: isPaused ? const Color(0xFFFFB901) : Colors.grey.shade600,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Thay thế _buildPopupRow bằng _buildSwitchRow dùng widget Switch thực tế
  Widget _buildSwitchRow({
    required String title,
    required bool value, // Giá trị hiển thị (effectiveValue)
    required bool actualValue, // Giá trị thực tế (postAndComment, sleepMode,...)
    required ValueChanged<bool> onChanged,
  }) {
    // Xác định xem mục này có bị vô hiệu hóa (disabled) bởi chế độ Tạm dừng không
    final bool isDisabled = isPaused && actualValue; // Chỉ vô hiệu hóa nếu đang Tạm dừng VÀ thông báo đó đang BẬT (tránh nhầm lẫn)


    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 4),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        // Màu nền hơi xám khi đang Tạm dừng (giống code cũ)
        color: isPaused ? Colors.grey.shade50 : null,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 19,
              fontWeight: FontWeight.w600,
              // Mờ đi nếu đang ở chế độ Tạm dừng
              color: isPaused ? Colors.grey.shade400 : Colors.black87,
            ),
          ),
          // Sử dụng widget Switch của Flutter
          Switch(
            // Giá trị hiển thị: sẽ là false nếu isPaused = true
            value: value,
            // Khi người dùng gạt
            onChanged: (newValue) {
              // Gọi hàm xử lý, hàm này sẽ chặn nếu đang Tạm dừng và cố gắng bật
              onChanged(newValue);
            },
            // Màu sắc tùy chỉnh cho Switch
            activeTrackColor: const Color(0xFFFFB901).withOpacity(0.5),
            activeColor: const Color(0xFFFFB901),
            inactiveThumbColor: Colors.white,
            inactiveTrackColor: Colors.grey.shade300,
          ),
        ],
      ),
    );
  }
}