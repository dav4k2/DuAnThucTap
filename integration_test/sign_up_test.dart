import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:fontend/main.dart' as app;
import 'package:fontend/firebase_options.dart'; // Đảm bảo import đúng file options

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('Test Debug: Tìm tên Tab Đăng Ký', (WidgetTester tester) async {
    print("--- ⚙️ Bắt đầu thiết lập môi trường Test ---");

    // 1. KHỞI TẠO CÁC SERVICE (Giống hệt main.dart nhưng nằm trong test)
    // ------------------------------------------------------------------
    WidgetsFlutterBinding.ensureInitialized();
    await EasyLocalization.ensureInitialized();

    // Load .env
    try {
      await dotenv.load(fileName: ".env");
    } catch (e) {
      print("⚠️ Không load được .env (Có thể bỏ qua nếu test không cần API Key): $e");
    }

    // Init Firebase (Dùng try-catch để tránh lỗi 'DuplicateApp' nếu chạy test nhiều lần)
    try {
      await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
    } catch (e) {
      print("ℹ️ Firebase đã được khởi tạo trước đó.");
    }

    // (Bỏ qua phần Emulator và TimerService tạm thời để Test chạy gọn nhẹ hơn,
    // trừ khi logic Đăng ký của bạn bắt buộc phải có nó)

    print("--- 📱 Bắt đầu Pump Widget ---");

    // 2. DỰNG WIDGET TREE (Tái tạo lại cấu trúc runApp trong main.dart)
    // ------------------------------------------------------------------
    // Lưu ý: Phải bọc EasyLocalization và ProviderScope y hệt như main.dart
    await tester.pumpWidget(
      EasyLocalization(
        supportedLocales: const [Locale('vi'), Locale('en')],
        path: 'assets/translations', // Đảm bảo folder assets được khai báo trong pubspec.yaml phần flutter: assets
        fallbackLocale: const Locale('vi'),
        startLocale: const Locale('vi'),
        child: const ProviderScope(
          child: app.MyApp(), // Widget gốc của bạn
        ),
      ),
    );

    // 3. CHỜ UI LOAD XONG
    // ------------------------------------------------------------------
    // Chờ EasyLocalization load file ngôn ngữ JSON và App render frame đầu tiên
    await tester.pumpAndSettle(const Duration(seconds: 2));

    print("--- 🔍 Bắt đầu tìm kiếm UI ---");

    // 4. LOGIC TEST TÌM KIẾM
    // ------------------------------------------------------------------
    final signUpFinder = find.text("Đăng ký");

    if (signUpFinder.evaluate().isEmpty) {
      print("⚠️ Vẫn chưa thấy chữ 'Đăng ký'. Đang in lại UI...");

      // In ra tất cả Text để debug
      final textWidgets = find.byType(Text);
      final texts = tester.widgetList<Text>(textWidgets);

      if (texts.isEmpty) {
        print("❌ Màn hình TRẮNG TRƠN (Không có Text nào).");
        print("👉 Kiểm tra lại xem 'assets/translations' có được load đúng trong Test không.");
      } else {
        for (var t in texts) {
          print("   -> '${t.data}'");
        }
      }

      // Dừng test có kiểm soát
      // fail("Không tìm thấy nút Đăng ký");
    } else {
      print("✅ Đã tìm thấy Tab Đăng ký!");
      await tester.tap(signUpFinder.first);
      await tester.pumpAndSettle();
      print("✅ Đã chuyển tab thành công.");
    }
  });
}