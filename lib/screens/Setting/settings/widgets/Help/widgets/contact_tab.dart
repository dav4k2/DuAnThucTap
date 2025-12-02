// lib/tabs/contact_tab.dart
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class ContactTab extends StatelessWidget {
  const ContactTab({super.key});

  static const String phone = "03618183636";
  static const String zalo = "03618183636";
  static const String email = "sonchimto@cookhub.vn";
  static const String facebook   = "https://facebook.com/cookhub.vn";
  static const String instagram  = "https://instagram.com/cookhub.vn";
  static const String xTwitter   = "https://x.com/cookhubvn";
  static const String youtube    = "https://youtube.com/@cookhubvn";

  static const Color kPrimaryYellow = Color(0xFFFFB901);

  Future<void> _launch(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      child: Column(
        children: [
          // Logo + mô tả
          Container(
            padding: const EdgeInsets.all(28),
            decoration: const BoxDecoration(shape: BoxShape.circle, color: kPrimaryYellow),
            child: const Icon(Icons.support_agent_rounded, size: 52, color: Colors.white),
          ),
          const SizedBox(height: 20),
          const Text(
            'Chúng tôi luôn sẵn sàng hỗ trợ bạn 24/7',
            style: TextStyle(fontSize: 15, color: Colors.black54, height: 1.4),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 48),

          // Danh sách liên hệ
          _buildItem(icon: Icons.phone_outlined, color: Colors.green, title: "Hotline", value: phone, onTap: () => _launch("tel:$phone")),
          _buildItem(icon: Icons.chat_outlined, color: const Color(0xFF0068FF), title: "Zalo", value: zalo, onTap: () => _launch("https://zalo.me/$zalo")),
          _buildItem(icon: Icons.email_outlined, color: Colors.red, title: "Email", value: email, onTap: () => _launch("mailto:$email")),
          _buildItem(icon: FontAwesomeIcons.facebookF, color: const Color(0xFF1877F2), title: "Facebook", value: "Cookhub Official", onTap: () => _launch(facebook)),
          _buildItem(icon: FontAwesomeIcons.instagram, color: const Color(0xFFE4405F), title: "Instagram", value: "@cookhub.vn", onTap: () => _launch(instagram)),
          _buildItem(icon: FontAwesomeIcons.xTwitter, color: Colors.black, title: "X (Twitter)", value: "@cookhubvn", onTap: () => _launch(xTwitter)),
          _buildItem(icon: FontAwesomeIcons.youtube, color: const Color(0xFFFF0000), title: "YouTube", value: "@cookhubvn", onTap: () => _launch(youtube)),

          const SizedBox(height: 60),
          const Text('© 2025 Cookhub. All rights reserved.', style: TextStyle(fontSize: 12, color: Colors.black38)),
          const SizedBox(height: 40),
        ],
      ),
    );
  }

  Widget _buildItem({
    required IconData icon,
    required Color color,
    required String title,
    required String value,
    required VoidCallback onTap,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 10, offset: const Offset(0, 4))],
      ),
      child: ListTile(
        onTap: onTap,
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        leading: Container(width: 48, height: 48, decoration: BoxDecoration(shape: BoxShape.circle, color: color), child: Icon(icon, color: Colors.white, size: 24)),
        title: Text(title, style: const TextStyle(fontSize: 14, color: Colors.black54, fontWeight: FontWeight.w500)),
        subtitle: Text(value, style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w600, color: Colors.black87)),
        trailing: const Icon(Icons.arrow_forward_ios, size: 18, color: Colors.black38),
      ),
    );
  }
}