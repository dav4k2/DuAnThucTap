import 'package:flutter/material.dart';
import 'screens/welcome/welcome_screen.dart';
import 'screens/welcome/widgets/splash_page.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'My Flutter App',
      debugShowCheckedModeBanner: false,

      // Trang khởi đầu
      initialRoute: '/splash',

      // Khai báo các route ở đây
      routes: {
        '/splash': (context) => const SplashPage(),
        '/welcome': (context) => const WelcomeScreen(),
      },

      // Theme chung cho toàn app
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
    );
  }
}
