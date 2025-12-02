import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// Màu vàng chính được sử dụng trong thiết kế Figma: #FFB901
const Color kPrimaryYellow = Color(0xFFFFB901);
const Color kBorderGrey = Color(0xFF666666); // Màu xám cho border, opacity 40%

void main() {
  // Đảm bảo Flutter binding đã sẵn sàng trước khi cấu hình hệ thống
  WidgetsFlutterBinding.ensureInitialized();

  // Ẩn Status Bar (thanh trạng thái)
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: [SystemUiOverlay.bottom]);
  // Ẩn Navigation Bar (thanh điều hướng dưới cùng / home indicator)
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);

  runApp(const HelpCenterApp());
}

class HelpCenterApp extends StatelessWidget {
  const HelpCenterApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Trung tâm trợ giúp',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.yellow,
        fontFamily: 'SF Pro', // Giả định phông chữ SF Pro có sẵn
        useMaterial3: true,
      ),
      home: const HelpCenterScreen(),
    );
  }
}

class HelpCenterScreen extends StatefulWidget {
  const HelpCenterScreen({super.key});

  @override
  State<HelpCenterScreen> createState() => _HelpCenterScreenState();
}

class _HelpCenterScreenState extends State<HelpCenterScreen> {
  // Dữ liệu giả lập cho Tab FAQ
  final List<String> faqTopics = [
    'Quyền riêng tư',
    'Sự cố kỹ thuật',
    'Giới thiệu về Cookhub',
    'Giới thiệu về AI trên Cookhub',
    'Chính sách thanh toán và hoàn tiền',
    'Quản lý tài khoản',
  ];

  @override
  Widget build(BuildContext context) {
    // Sử dụng DefaultTabController để quản lý 2 tab
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: _buildCustomAppBar(context),
        body: Column(
          children: [
            _buildSearchBar(),
            _buildCustomTabBar(),
            // Nội dung của 2 tab
            Expanded(
              child: TabBarView(
                children: [
                  FAQTab(faqTopics: faqTopics), // Tab FAQ
                  const ContactTab(), // Tab Liên hệ
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // 1. App Bar với tiêu đề và nút quay lại
  PreferredSizeWidget _buildCustomAppBar(BuildContext context) {
    return AppBar(
      // Loại bỏ khoảng đệm mặc định của AppBar để giảm thiểu không gian thừa
      toolbarHeight: 80,
      backgroundColor: Colors.white,
      elevation: 0,
      title: const Text(
        'Trung tâm trợ giúp',
        style: TextStyle(
          color: Colors.black,
          fontSize: 24,
          fontWeight: FontWeight.w700,
        ),
      ),
      centerTitle: true,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
        onPressed: () {
          // Thao tác quay lại màn hình trước
        },
      ),
      systemOverlayStyle: SystemUiOverlayStyle.light, // Ẩn status bar icon (nếu không ẩn hoàn toàn)
    );
  }

  // 2. Thanh tìm kiếm
  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
      child: Container(
        height: 42,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(50),
          border: Border.all(
            color: Colors.black.withOpacity(0.40),
            width: 1,
          ),
        ),
        child: const TextField(
          decoration: InputDecoration(
            hintText: 'Tìm kiếm',
            hintStyle: TextStyle(
              color: Color.fromRGBO(0, 0, 0, 0.5), // Black at 50% opacity
              fontSize: 15,
              fontWeight: FontWeight.w500,
            ),
            prefixIcon: Icon(Icons.search, color: Colors.grey),
            border: InputBorder.none,
            contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 15.0),
          ),
        ),
      ),
    );
  }

  // 3. Tab Bar với thiết kế tùy chỉnh
  Widget _buildCustomTabBar() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10.0),
      child: TabBar(
        indicatorSize: TabBarIndicatorSize.tab,
        labelColor: kPrimaryYellow, // Màu của tab được chọn
        unselectedLabelColor: Colors.black, // Màu của tab chưa chọn
        indicatorColor: kPrimaryYellow, // Màu thanh chỉ báo
        indicatorWeight: 4, // Độ dày thanh chỉ báo
        dividerColor: Colors.transparent, // Ẩn divider mặc định

        tabs: const [
          Tab(
            child: Text(
              'FAQ',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                height: 1.10,
              ),
            ),
          ),
          Tab(
            child: Text(
              'Liên hệ',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                height: 1.10,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// =========================================================================
// TAB FAQ - Nội dung các câu hỏi thường gặp
// =========================================================================
class FAQTab extends StatelessWidget {
  final List<String> faqTopics;
  const FAQTab({super.key, required this.faqTopics});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
      itemCount: faqTopics.length,
      itemBuilder: (context, index) {
        return Column(
          children: [
            _buildFaqItem(faqTopics[index]),
            const Divider(height: 1, color: Colors.black12),
          ],
        );
      },
    );
  }

  Widget _buildFaqItem(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 18.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              title,
              style: const TextStyle(
                color: Colors.black,
                fontSize: 18,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
        ],
      ),
    );
  }
}

// =========================================================================
// TAB LIÊN HỆ - Nội dung form liên hệ
// =========================================================================
class ContactTab extends StatefulWidget {
  const ContactTab({super.key});

  @override
  State<ContactTab> createState() => _ContactTabState();
}

class _ContactTabState extends State<ContactTab> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _subjectController = TextEditingController();
  final TextEditingController _messageController = TextEditingController();

  void _submitForm() {
    // Logic xử lý gửi form (ví dụ: in ra console)
    debugPrint('Đã gửi liên hệ:');
    debugPrint('Tên: ${_nameController.text}');
    debugPrint('Email: ${_emailController.text}');
    debugPrint('Chủ đề: ${_subjectController.text}');
    debugPrint('Nội dung: ${_messageController.text}');

    // Hiển thị thông báo (sử dụng SnackBar thay vì alert/dialog)
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Yêu cầu liên hệ của bạn đã được gửi thành công!'),
        backgroundColor: Colors.green,
      ),
    );
    // Xóa form sau khi gửi
    _nameController.clear();
    _emailController.clear();
    _subjectController.clear();
    _messageController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildTextField(
            controller: _nameController,
            labelText: 'Họ và tên',
            hintText: 'Nhập tên của bạn',
          ),
          const SizedBox(height: 16),
          _buildTextField(
            controller: _emailController,
            labelText: 'Email',
            hintText: 'Nhập email của bạn',
            keyboardType: TextInputType.emailAddress,
          ),
          const SizedBox(height: 16),
          _buildTextField(
            controller: _subjectController,
            labelText: 'Chủ đề',
            hintText: 'Chủ đề liên hệ',
          ),
          const SizedBox(height: 16),
          _buildTextField(
            controller: _messageController,
            labelText: 'Nội dung chi tiết',
            hintText: 'Mô tả chi tiết vấn đề bạn đang gặp phải',
            maxLines: 6,
          ),
          const SizedBox(height: 32),
          ElevatedButton(
            onPressed: _submitForm,
            style: ElevatedButton.styleFrom(
              backgroundColor: kPrimaryYellow,
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              elevation: 3,
            ),
            child: const Text(
              'Gửi yêu cầu',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Hàm xây dựng trường nhập liệu tùy chỉnh
  Widget _buildTextField({
    required TextEditingController controller,
    required String labelText,
    required String hintText,
    TextInputType keyboardType = TextInputType.text,
    int maxLines = 1,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          labelText,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          keyboardType: keyboardType,
          maxLines: maxLines,
          decoration: InputDecoration(
            hintText: hintText,
            contentPadding: const EdgeInsets.all(12),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: kBorderGrey, width: 1),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: kBorderGrey, width: 1),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: kPrimaryYellow, width: 2),
            ),
          ),
        ),
      ],
    );
  }
}