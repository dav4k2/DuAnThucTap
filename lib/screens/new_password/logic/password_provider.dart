import 'package:flutter_riverpod/flutter_riverpod.dart';

final passwordProvider = StateProvider<String>((ref) => '');
final confirmPasswordProvider = StateProvider<String>((ref) => '');

final passwordValidProvider = Provider<bool>((ref) {
  final pass = ref.watch(passwordProvider);
  final confirm = ref.watch(confirmPasswordProvider);
  return pass.isNotEmpty && pass == confirm;
});
