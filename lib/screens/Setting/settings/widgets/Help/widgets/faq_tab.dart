// lib/tabs/faq_tab.dart
import 'package:flutter/material.dart';

class FAQTab extends StatefulWidget {
  final List<String> faqTopics;
  const FAQTab({super.key, required this.faqTopics});

  @override
  State<FAQTab> createState() => _FAQTabState();
}

class _FAQTabState extends State<FAQTab> {
  static const Color kPrimaryYellow = Color(0xFFFFB901);

  final Map<String, String> faqAnswers = {
    'Làm sao để đăng ký tài khoản Cookhub?':
    'Mở ứng dụng → Chọn “Đăng ký” → Nhập số điện thoại → Nhận mã OTP → Điền thông tin → Hoàn tất trong 30 giây!',
    'Sự cố kỹ thuật':
    '• Ứng dụng bị crash: Cập nhật phiên bản mới nhất.\n'
        '• Không nhận OTP: Chờ 60 giây hoặc liên hệ Hotline.\n'
        '• Màn hình trắng: Xóa cache hoặc cài lại ứng dụng.',
    'Giới thiệu về Cookhub':
    'Cookhub là ứng dụng đặt món ăn nhanh, giao tận nơi với hàng nghìn quán ăn tại hơn 25 tỉnh thành Việt Nam. Giao hàng trong 25-35 phút, hỗ trợ 24/7, hoàn tiền 100% nếu lỗi từ hệ thống.',
    'Giới thiệu về AI trên Cookhub':
    'AI Cookhub giúp:\n'
        '• Gợi ý món ăn theo sở thích của bạn\n'
        '• Dự đoán thời gian giao hàng chính xác\n'
        '• Tự động chọn shipper gần nhất\n'
        '• Phát hiện gian lận đơn hàng',
    'Chính sách thanh toán và hoàn tiền':
    '• Hỗ trợ: Tiền mặt, Momo, ZaloPay, thẻ ngân hàng\n'
        '• Hủy đơn trong 2 phút: Miễn phí\n'
        '• Hủy do quán/Cookhub: Hoàn 100% trong 1-3 ngày\n'
        '• Hủy do khách sau 2 phút: Tùy quán',
    'Quản lý tài khoản':
    'Vào “Cá nhân” để:\n'
        '• Thay đổi số điện thoại\n'
        '• Cập nhật địa chỉ thường dùng\n'
        '• Xem lịch sử đơn hàng\n'
        '• Đổi mật khẩu / Đăng xuất tất cả thiết bị',

  };

  final Set<int> _expandedIndices = {};

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final cardColor = isDark ? Colors.grey[850] : Colors.white;
    final questionTextColor = isDark ? Colors.white : Colors.black87;
    final answerBgColor = isDark ? Colors.grey[900] : const Color(0xFFF5F5F5);
    final answerTextColor = isDark ? Colors.white70 : Colors.black87;
    final borderColor = isDark ? Colors.white12 : Colors.grey.shade200;
    final bottomBorderColor = isDark ? Colors.white12 : Colors.grey.shade300;
    final shadowColor = isDark ? Colors.black.withOpacity(0.7) : Colors.black.withOpacity(0.04);

    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 40),
      itemCount: widget.faqTopics.length,
      itemBuilder: (context, index) {
        final String question = widget.faqTopics[index];
        final bool isExpanded = _expandedIndices.contains(index);

        return AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          curve: Curves.fastOutSlowIn,
          margin: const EdgeInsets.only(bottom: 16),
          decoration: BoxDecoration(
            color: cardColor,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: borderColor),
            boxShadow: [
              BoxShadow(
                color: shadowColor,
                blurRadius: 12,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Column(
            children: [
              // === PHẦN CÂU HỎI ===
              InkWell(
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(16),
                  topRight: const Radius.circular(16),
                  bottomLeft: Radius.circular(isExpanded ? 0 : 16),
                  bottomRight: Radius.circular(isExpanded ? 0 : 16),
                ),
                onTap: () {
                  setState(() {
                    if (isExpanded) {
                      _expandedIndices.remove(index);
                    } else {
                      _expandedIndices.add(index);
                    }
                  });
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          question,
                          style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.w700,
                            color: questionTextColor,
                          ),
                        ),
                      ),
                      AnimatedRotation(
                        turns: isExpanded ? 0.5 : 0.0,
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.fastOutSlowIn,
                        child: const Icon(
                          Icons.keyboard_arrow_down_rounded,
                          color: kPrimaryYellow,
                          size: 30,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // === PHẦN TRẢ LỜI ===
              AnimatedSize(
                duration: const Duration(milliseconds: 300),
                curve: Curves.fastOutSlowIn,
                alignment: Alignment.topCenter,
                child: isExpanded
                    ? Container(
                  width: double.infinity,
                  padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
                  decoration: BoxDecoration(
                    color: answerBgColor,
                    borderRadius: const BorderRadius.vertical(bottom: Radius.circular(16)),
                    border: Border(top: BorderSide(color: bottomBorderColor, width: 1)),
                  ),
                  child: Text(
                    faqAnswers[question] ?? "Đang cập nhật câu trả lời...",
                    style: TextStyle(
                      fontSize: 15,
                      height: 1.6,
                      color: answerTextColor,
                    ),
                  ),
                )
                    : const SizedBox.shrink(),
              ),
            ],
          ),
        );
      },
    );
  }
}
