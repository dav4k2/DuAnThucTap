import 'package:google_generative_ai/google_generative_ai.dart';

void main() async {
  final apiKey = 'AIzaSyCKfe1_udVnevaU1c0Ta5BH_CN7j8a5xSI';

  final modelsToTest = [
    'gemini-1.5-flash',
    'gemini-1.5-flash-8b',
    'gemini-1.5-pro',
  ];

  print("🚀 Bắt đầu kiểm tra Key mới...");
  print("------------------------------------");

  for (final modelName in modelsToTest) {
    final model = GenerativeModel(
      model: modelName,
      apiKey: apiKey,
    );

    try {
      final res = await model.generateContent([
        Content.text("Hello")
      ]);

      print("✅ $modelName → Hoạt động OK");
    } catch (e) {
      print("❌ $modelName → Lỗi: ${e.toString()}");
    }
  }

  print("------------------------------------");
  print("Kết thúc kiểm tra.");
}
