import 'package:easy_localization/easy_localization.dart'; // <--- IMPORT MỚI
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:fontend/Main_layout/main_layout.dart';

// Import các màn hình của bạn
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
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized(); // <--- KHỞI TẠO NGÔN NGỮ

  // 1. Khởi tạo Firebase
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // 2. Khởi tạo biến môi trường
  await dotenv.load(fileName: ".env");

  runApp(
    // BỌC APP TRONG EASY LOCALIZATION
    EasyLocalization(
      supportedLocales: const [Locale('vi'), Locale('en')],
      path: 'assets/translations',
      fallbackLocale: const Locale('vi'),
      startLocale: const Locale('vi'),
      child: const ProviderScope(child: MyApp()),
    ),
  );
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = ref.watch(themeProvider);
    // Không cần watch languageProvider nữa, EasyLocalization tự lo

    return ScreenUtilInit(
      designSize: const Size(402, 874),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return MaterialApp(
          title: 'My Flutter App',
          debugShowCheckedModeBanner: false,
          useInheritedMediaQuery: true,

          // --- CẤU HÌNH NGÔN NGỮ TỰ ĐỘNG ---
          localizationsDelegates: context.localizationDelegates,
          supportedLocales: context.supportedLocales,
          locale: context.locale,
          // ---------------------------------

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
          builder: (context, widget) {
            final mediaQuery = MediaQuery.of(context);
            return MediaQuery(
              data: mediaQuery.copyWith(textScaler: const TextScaler.linear(1.0)),
              child: widget!,
            );
          },
          home: AuthGate(),
          routes: {
            '/welcome': (context) => const WelcomeScreen(),
            '/signin': (context) => const SignInScreen(),
            '/explore': (context) => const ExploreScreen(),
            '/reset': (context) => const ResetPasswordScreen(),
            '/enterpass': (context) => const EnterResetPasswordScreen(),
            '/terms': (context) => const TermsPage(),
            '/mainlayout': (context) => const MainLayout(),
            '/survey' : (context) => const SurveyStartScreen(),
          },
        );
      },
    );
  }
}