import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fontend/screens/enter_new_password/reset_password_screen.dart';
import 'package:fontend/screens/terms/terms.dart';
import 'screens/welcome/welcome_screen.dart';
import 'screens/welcome/widgets/splash_page.dart';
import 'screens/sign_in/sign_in_screen.dart';
import 'screens/explore/explore_screen.dart';
import 'screens/reset_password/reset_password_screen.dart';
import 'screens/success_reset_password/success_reset_password_screen.dart';
import 'screens/new_password/new_password_screen.dart';
import 'screens/auth/auth_screen.dart';

void main() {
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(402, 874),
      minTextAdapt: true,
      builder: (context, child) {
        return MaterialApp(
          title: 'My Flutter App',
          debugShowCheckedModeBanner: false,

          /// font và layout hiển thị giống nhau iOS/Android
          builder: (context, widget) {
            final mediaQuery = MediaQuery.of(context);
            return MediaQuery(
              data: mediaQuery.copyWith(
                textScaler: const TextScaler.linear(1.0),
              ),
              child: widget!,
            );
          },

          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
            useMaterial3: true,
          ),

          initialRoute: '/splash',
          routes: {
            '/splash': (context) => const SplashPage(),
            '/welcome': (context) => const WelcomeScreen(),
            '/signin': (context) => const SignInScreen(),
            '/explore': (context) => const ExploreScreen(),
            '/reset': (context) => const ResetPasswordScreen(),
            '/terms' : (context) => const TermsPage(),
            '/success' : (context) => const ResetSuccessScreen(),
            '/newpass' : (context) => const NewPasswordScreen(),
            '/auth' : (context) => const AuthScreen(),
            '/enterpass' : (context) => const EnterResetPasswordScreen()
          },


          home: child,
        );
      },
      child: const SplashPage(),
    );
  }
}

/*
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:fontend/screens/success_reset_password/success_reset_password_screen.dart';
import 'package:fontend/screens/new_password/new_password_screen.dart';
import 'package:fontend/screens/auth/auth_screen.dart';

void main() {
  runApp(
    const ProviderScope( //Thêm dòng này để Riverpod hoạt động
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: AuthScreen(),
    );
  }
}
*/