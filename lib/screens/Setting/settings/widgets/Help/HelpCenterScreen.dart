// lib/main.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fontend/screens/Setting/settings/widgets/Help/widgets/contact_tab.dart';
import 'package:fontend/screens/Setting/settings/widgets/Help/widgets/faq_tab.dart';

import '../../settings_screen.dart';

const Color kPrimaryYellow = Color(0xFFFFB901);
const Color kBorderGrey = Color(0xFF666666);

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
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: _buildCustomAppBar(context),
        body: Column(
          children: [
            _buildSearchBar(),
            _buildCustomTabBar(),
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

  PreferredSizeWidget _buildCustomAppBar(BuildContext context) {
    return AppBar(
      toolbarHeight: 80,
      backgroundColor: Colors.white,
      elevation: 0,
      title: const Text(
        'Trung tâm trợ giúp',
        style: TextStyle(color: Colors.black, fontSize: 24, fontWeight: FontWeight.w700),
      ),
      centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
    );
  }


  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
      child: Container(
        height: 42,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(50),
          border: Border.all(color: Colors.black.withOpacity(0.40), width: 1),
        ),
        child: const TextField(
          decoration: InputDecoration(
            hintText: 'Tìm kiếm',
            hintStyle: TextStyle(color: Color.fromRGBO(0, 0, 0, 0.5), fontSize: 15, fontWeight: FontWeight.w500),
            prefixIcon: Icon(Icons.search, color: Colors.grey),
            border: InputBorder.none,
            contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 15.0),
          ),
        ),
      ),
    );
  }

  Widget _buildCustomTabBar() {
    return const Padding(
      padding: EdgeInsets.only(bottom: 10.0),
      child: TabBar(
        indicatorSize: TabBarIndicatorSize.tab,
        labelColor: kPrimaryYellow,
        unselectedLabelColor: Colors.black,
        indicatorColor: kPrimaryYellow,
        indicatorWeight: 4,
        dividerColor: Colors.transparent,
        tabs: [
          Tab(child: Text('FAQ', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700, height: 1.10))),
          Tab(child: Text('Liên hệ', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700, height: 1.10))),
        ],
      ),
    );
  }
}