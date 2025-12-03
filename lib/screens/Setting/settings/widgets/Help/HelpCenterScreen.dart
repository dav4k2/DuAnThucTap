// lib/main.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fontend/screens/Setting/settings/widgets/Help/widgets/contact_tab.dart';
import 'package:fontend/screens/Setting/settings/widgets/Help/widgets/faq_tab.dart';

import '../../settings_screen.dart';

const Color kPrimaryYellow = Color(0xFFFFB901);

void main() {
  WidgetsFlutterBinding.ensureInitialized();
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
        fontFamily: 'SF Pro',
        useMaterial3: true,
        brightness: Brightness.light,
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        primarySwatch: Colors.yellow,
        fontFamily: 'SF Pro',
        useMaterial3: true,
      ),
      themeMode: ThemeMode.system,
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
  final List<String> faqTopics = [
    'Làm sao để đăng ký tài khoản Cookhub?',
    'Bị Gay có dùng được không ?',
    'Sự cố kỹ thuật',
    'Giới thiệu về Cookhub',
    'Giới thiệu về AI trên Cookhub',
    'Chính sách thanh toán và hoàn tiền',
    'Quản lý tài khoản',
  ];

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final backgroundColor = isDark ? Colors.black : Colors.white;
    final textColor = isDark ? Colors.white : Colors.black;

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: backgroundColor,
        appBar: _buildCustomAppBar(context, textColor),
        body: Column(
          children: [
            _buildSearchBar(isDark: isDark),
            _buildCustomTabBar(isDark: isDark),
            Expanded(
              child: TabBarView(
                children: [
                  FAQTab(faqTopics: faqTopics),
                  const ContactTab(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  PreferredSizeWidget _buildCustomAppBar(BuildContext context, Color textColor) {
    return AppBar(
      toolbarHeight: 80,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      elevation: 0,
      title: Text(
        'Trung tâm trợ giúp',
        style: TextStyle(color: textColor, fontSize: 24, fontWeight: FontWeight.w700),
      ),
      centerTitle: true,
      leading: IconButton(
        icon: Icon(Icons.arrow_back_ios, color: textColor),
        onPressed: () {
          Navigator.pop(context);
        },
      ),
    );
  }

  Widget _buildSearchBar({required bool isDark}) {
    final borderColor = isDark ? Colors.white.withOpacity(0.4) : Colors.black.withOpacity(0.4);
    final hintColor = isDark ? Colors.white70 : const Color.fromRGBO(0, 0, 0, 0.5);
    final iconColor = isDark ? Colors.white70 : Colors.grey;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
      child: Container(
        height: 42,
        decoration: BoxDecoration(
          color: isDark ? Colors.grey[900] : Colors.white,
          borderRadius: BorderRadius.circular(50),
          border: Border.all(color: borderColor, width: 1),
        ),
        child: TextField(
          style: TextStyle(color: hintColor),
          decoration: InputDecoration(
            hintText: 'Tìm kiếm',
            hintStyle: TextStyle(color: hintColor, fontSize: 15, fontWeight: FontWeight.w500),
            prefixIcon: Icon(Icons.search, color: iconColor),
            border: InputBorder.none,
            contentPadding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 15.0),
          ),
        ),
      ),
    );
  }

  Widget _buildCustomTabBar({required bool isDark}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10.0),
      child: TabBar(
        indicatorSize: TabBarIndicatorSize.tab,
        labelColor: kPrimaryYellow,
        unselectedLabelColor: isDark ? Colors.white70 : Colors.black,
        indicatorColor: kPrimaryYellow,
        indicatorWeight: 4,
        dividerColor: Colors.transparent,
        tabs: const [
          Tab(child: Text('FAQ', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700, height: 1.10))),
          Tab(child: Text('Liên hệ', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700, height: 1.10))),
        ],
      ),
    );
  }
}
