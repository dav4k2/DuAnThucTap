import 'package:flutter_riverpod/flutter_riverpod.dart';

final recipeDetailProvider = StateProvider<String>((ref) {
  return "pho-tai"; // id công thức
});