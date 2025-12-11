// lib/tabs/contact_tab.dart
import 'package:easy_localization/easy_localization.dart';
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
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final backgroundColor = isDark ? Colors.grey[900] : Colors.white;
    final cardShadow = isDark ? Colors.black.withOpacity(0.7) : Colors.black.withOpacity(0.04);
    final titleColor = isDark ? Colors.white70 : Colors.black54;
    final valueColor = isDark ? Colors.white : Colors.black87;
    final trailingColor = isDark ? Colors.white38 : Colors.black38;

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
          Text(
            'Chúng tôi luôn sẵn sàng hỗ trợ bạn 24/7'.tr(),
            style: TextStyle(fontSize: 15, color: titleColor, height: 1.4),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 48),

          // Danh sách liên hệ
          _buildItem(
            icon: Icons.phone_outlined,
            color: Colors.green,
            title: "Hotline",
            value: phone,
            onTap: () => _launch("tel:$phone"),
            isDark: isDark,
            cardShadow: cardShadow,
            titleColor: titleColor,
            valueColor: valueColor,
            trailingColor: trailingColor,
          ),
          _buildItem(
            icon: Icons.chat_outlined,
            color: const Color(0xFF0068FF),
            title: "Zalo",
            value: zalo,
            onTap: () => _launch("https://zalo.me/$zalo"),
            isDark: isDark,
            cardShadow: cardShadow,
            titleColor: titleColor,
            valueColor: valueColor,
            trailingColor: trailingColor,
          ),
          _buildItem(
            icon: Icons.email_outlined,
            color: Colors.red,
            title: "Email",
            value: email,
            onTap: () => _launch("mailto:$email"),
            isDark: isDark,
            cardShadow: cardShadow,
            titleColor: titleColor,
            valueColor: valueColor,
            trailingColor: trailingColor,
          ),
          _buildItem(
            icon: FontAwesomeIcons.facebookF,
            color: const Color(0xFF1877F2),
            title: "Facebook",
            value: "Cookhub Official",
            onTap: () => _launch(facebook),
            isDark: isDark,
            cardShadow: cardShadow,
            titleColor: titleColor,
            valueColor: valueColor,
            trailingColor: trailingColor,
          ),
          _buildItem(
            icon: FontAwesomeIcons.instagram,
            color: const Color(0xFFE4405F),
            title: "Instagram",
            value: "@cookhub.vn",
            onTap: () => _launch(instagram),
            isDark: isDark,
            cardShadow: cardShadow,
            titleColor: titleColor,
            valueColor: valueColor,
            trailingColor: trailingColor,
          ),
          _buildItem(
            icon: FontAwesomeIcons.xTwitter,
            color: Colors.black,
            title: "X (Twitter)",
            value: "@cookhubvn",
            onTap: () => _launch(xTwitter),
            isDark: isDark,
            cardShadow: cardShadow,
            titleColor: titleColor,
            valueColor: valueColor,
            trailingColor: trailingColor,
          ),
          _buildItem(
            icon: FontAwesomeIcons.youtube,
            color: const Color(0xFFFF0000),
            title: "YouTube",
            value: "@cookhubvn",
            onTap: () => _launch(youtube),
            isDark: isDark,
            cardShadow: cardShadow,
            titleColor: titleColor,
            valueColor: valueColor,
            trailingColor: trailingColor,
          ),

          const SizedBox(height: 60),
          Text(
            '© 2025 Cookhub. All rights reserved.',
            style: TextStyle(fontSize: 12, color: trailingColor),
          ),
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
    required bool isDark,
    required Color cardShadow,
    required Color titleColor,
    required Color valueColor,
    required Color trailingColor,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      decoration: BoxDecoration(
        color: isDark ? Colors.grey[850] : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: isDark ? Colors.white12 : Colors.grey.shade200),
        boxShadow: [BoxShadow(color: cardShadow, blurRadius: 10, offset: const Offset(0, 4))],
      ),
      child: ListTile(
        onTap: onTap,
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        leading: Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(shape: BoxShape.circle, color: color),
          child: Icon(icon, color: Colors.white, size: 24),
        ),
        title: Text(title, style: TextStyle(fontSize: 14, color: titleColor, fontWeight: FontWeight.w500)),
        subtitle: Text(value, style: TextStyle(fontSize: 17, fontWeight: FontWeight.w600, color: valueColor)),
        trailing: Icon(Icons.arrow_forward_ios, size: 18, color: trailingColor),
      ),
    );
  }
}
