
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:fontend/screens/Remove/enter_new_password/reset_password_screen.dart';
import 'package:fontend/screens/Searching/search/explore_screen.dart';
import 'package:fontend/screens/Setting/settings/widgets/terms_and_conditions/terms.dart';
import 'package:fontend/screens/Signin/reset_pass_email/reset_password_screen.dart';
import 'package:fontend/screens/Signin/sign_in&sign_up/auth/auth_gate.dart';
import 'package:fontend/screens/Signin/sign_in&sign_up/sign_in_screen.dart';
import 'package:fontend/screens/Start/welcome/welcome_screen.dart';
import 'package:fontend/screens/Start/welcome/widgets/splash_page.dart';
import 'package:fontend/screens/survey/survey_0.dart';
import 'package:fontend/screens/survey/survey_flow_screen.dart';
import 'package:fontend/theme/app_localizations.dart';
import 'package:fontend/theme/language_provider.dart';
import 'package:fontend/theme/theme_provider.dart';
import 'firebase_options.dart';

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
          locale: Locale(lang),
          localizationsDelegates: const [
            AppLocalizations.delegate, // PHẢI CÓ TRƯỚC
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: const [Locale('vi'), Locale('en')],
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
            scaffoldBackgroundColor: const Color(0xFF121212), // NỀN TỐI
            textTheme: const TextTheme(
              bodyMedium: TextStyle(color: Colors.white, fontFamily: 'SF Pro'), // CHỮ TRẮNG
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
          home:  AuthGate(),
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


/*
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fontend/screens/food_page/recipe_detail_page_screen.dart';
import 'package:fontend/screens/prepare/finish/finish_screen.dart';
import 'package:fontend/screens/prepare/prepare_page/prepare_screen.dart';
import 'package:fontend/screens/prepare/step_0/step_screen.dart';
import 'package:fontend/screens/prepare/step_1/step_time_screen.dart';
import 'package:fontend/screens/prepare/step_2/step_2_screen.dart';
import 'package:fontend/screens/prepare/step_2_2/step_2_2_screem.dart';
import 'package:fontend/screens/prepare/step_3/step3_screen.dart';
import 'package:fontend/screens/prepare/step_3_3/step_3_3_screen.dart';
import 'screens/notification/notification_screen.dart';

void main() => runApp(const ProviderScope(child: MyApp()));

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Dự Án Thực Tập',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFFFFC221),
          brightness: Brightness.light,
        ),
      ),
      home: const PreparePage(),
    );
  }
}
*/