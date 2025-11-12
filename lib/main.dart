import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:fontend/screens/enter_new_password/reset_password_screen.dart';
import 'package:fontend/screens/terms/terms.dart';
import 'package:fontend/theme/language_provider.dart';
import 'package:fontend/theme/theme_provider.dart';
import 'firebase_options.dart';
import 'screens/welcome/welcome_screen.dart';
import 'screens/welcome/widgets/splash_page.dart';
import 'screens/sign_in/sign_in_screen.dart';
import 'screens/explore/explore_screen.dart';
import 'screens/reset_password/reset_password_screen.dart';
import 'screens/success_reset_password/success_reset_password_screen.dart';
import 'screens/new_password/new_password_screen.dart';
import 'screens/auth/auth_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = ref.watch(themeProvider);
    final lang = ref.watch(languageProvider);

    return ScreenUtilInit(
      designSize: const Size(402, 874),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return MaterialApp(
          title: 'My Flutter App',
          debugShowCheckedModeBanner: false,
          useInheritedMediaQuery: true,
          locale: Locale(lang), // ĐỔI NGÔN NGỮ
          localizationsDelegates: const [
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: const [Locale('vi'), Locale('en')],
          theme: ThemeData.light().copyWith(
            scaffoldBackgroundColor: Colors.white,
            textTheme: const TextTheme(bodyMedium: TextStyle(fontFamily: 'SF Pro')),
          ),
          darkTheme: ThemeData.dark().copyWith(
            scaffoldBackgroundColor: Colors.grey[900],
            textTheme: const TextTheme(bodyMedium: TextStyle(fontFamily: 'SF Pro')),
          ),
          themeMode: isDark ? ThemeMode.dark : ThemeMode.light, // ĐỔI CHẾ ĐỘ TỐI
          builder: (context, widget) {
            final mediaQuery = MediaQuery.of(context);
            return MediaQuery(
              data: mediaQuery.copyWith(textScaler: const TextScaler.linear(1.0)),
              child: widget!,
            );
          },
          home: const SplashPage(),
          routes: {
            '/welcome': (context) => const WelcomeScreen(),
            '/signin': (context) => const SignInScreen(),
            '/explore': (context) => const ExploreScreen(),
            '/reset': (context) => const ResetPasswordScreen(),
            '/enterpass': (context) => const EnterResetPasswordScreen(),
            '/terms': (context) => const TermsPage(),
          },
        );
      },
    );
  }
}