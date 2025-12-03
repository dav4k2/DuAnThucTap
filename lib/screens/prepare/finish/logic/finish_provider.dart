import 'package:flutter_riverpod/flutter_riverpod.dart';

final finishRecipeProvider = StateProvider<bool>((ref) {
  return false; // ví dụ: false = chưa đánh giá
});
