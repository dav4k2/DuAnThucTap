import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

// Import services và layout
import 'package:fontend/Main_layout/main_layout.dart';
import 'package:fontend/screens/Cooking_step/cooking_timer_service.dart';
import 'package:fontend/screens/Home_page/mainpage_user/mainpage_user_screen.dart';

// Import các màn hình
import 'package:fontend/screens/Remove/enter_new_password/reset_password_screen.dart';
import 'package:fontend/screens/Searching/search/explore_screen.dart';
import 'package:fontend/screens/Setting/settings/widgets/terms_and_conditions/terms.dart';
import 'package:fontend/screens/Signin/reset_pass_email/reset_password_screen.dart';
import 'package:fontend/screens/Signin/sign_in&sign_up/auth/auth_gate.dart';
import 'package:fontend/screens/Signin/sign_in&sign_up/sign_in_screen.dart';
import 'package:fontend/screens/Start/welcome/welcome_screen.dart';
import 'package:fontend/screens/survey/survey_0.dart';
import 'package:fontend/theme/theme_provider.dart';
import 'firebase_options.dart';

Future<void> main() async {
  //Đảm bảo Flutter binding đã sẵn sàng
  WidgetsFlutterBinding.ensureInitialized();

  //Khởi tạo Ngôn ngữ (Easy Localization)
  await EasyLocalization.ensureInitialized();

  //Khởi tạo Firebase
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  //Khởi tạo Biến môi trường (.env)
  await dotenv.load(fileName: ".env");

  await SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);

  //Khởi tạo Cooking Timer Service (Tính năng đếm ngược chạy ngầm)
  final timerService = CookingTimerService();
  await timerService.initialize();

  // if (kDebugMode) {
  //   String host = Platform.isAndroid ? '10.0.2.2' : 'localhost';
  //   await FirebaseAuth.instance.useAuthEmulator(host, 9099);
  //   FirebaseFirestore.instance.useFirestoreEmulator(host, 8080);
  //   FirebaseDatabase.instance.useDatabaseEmulator(host, 9000);
  //   print('--- Đã kết nối với Firebase Emulator Suite ---');
  // }

  runApp(
    EasyLocalization(
      supportedLocales: const [Locale('vi'), Locale('en')],
      path: 'assets/translations',
      fallbackLocale: const Locale('vi'),
      startLocale: const Locale('vi'),
      child: const ProviderScope(
        child: MyApp(),
      ),
    ),
  );
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Theo dõi trạng thái Dark Mode từ Riverpod
    final isDark = ref.watch(themeProvider);

    return ScreenUtilInit(
      designSize: const Size(402, 874),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return MaterialApp(
          title: 'Cooking App',
          debugShowCheckedModeBanner: false,
          useInheritedMediaQuery: true,

          // --- CẤU HÌNH NGÔN NGỮ ---
          localizationsDelegates: context.localizationDelegates,
          supportedLocales: context.supportedLocales,
          locale: context.locale,

          // --- CẤU HÌNH THEME ---
          themeMode: isDark ? ThemeMode.dark : ThemeMode.light,
          theme: ThemeData(
            brightness: Brightness.light,
            scaffoldBackgroundColor: Colors.white,
            textTheme: const TextTheme(
              bodyMedium: TextStyle(color: Colors.black, fontFamily: 'SF Pro'),
            ),
            useMaterial3: true,
          ),
          darkTheme: ThemeData(
            brightness: Brightness.dark,
            scaffoldBackgroundColor: const Color(0xFF121212),
            textTheme: const TextTheme(
              bodyMedium: TextStyle(color: Colors.white, fontFamily: 'SF Pro'),
            ),
            useMaterial3: true,
          ),

          // --- CẤU HÌNH TEXT SCALER (FIX CHỮ KHÔNG BỊ TO NHỎ THEO HỆ THỐNG) ---
          builder: (context, widget) {
            final mediaQuery = MediaQuery.of(context);
            return MediaQuery(
              data: mediaQuery.copyWith(
                textScaler: const TextScaler.linear(1.0),
              ),
              child: widget!,
            );
          },

          home: const AuthGate(),

          // --- HỆ THỐNG ROUTES ---
          routes: {
            '/home': (context) => HomeUserScreen(),
            '/welcome': (context) => const WelcomeScreen(),
            '/signin': (context) => const SignInScreen(),
            '/explore': (context) => const ExploreScreen(),
            '/reset': (context) => const ResetPasswordScreen(),
            '/enterpass': (context) => const EnterResetPasswordScreen(),
            '/terms': (context) => const TermsPage(),
            '/mainlayout': (context) => const MainLayout(),
            '/survey': (context) => const SurveyStartScreen(),
            '/authgate': (context) => const AuthGate(),
          },
        );
      },
    );
  }
}