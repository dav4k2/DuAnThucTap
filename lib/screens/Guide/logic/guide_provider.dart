// lib/features/user_guide/logic/guide_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';

// StateNotifier để quản lý chỉ số trang hiện tại (index)
class GuideNotifier extends StateNotifier<int> {
  GuideNotifier() : super(0);

  // Cập nhật trang hiện tại
  void setIndex(int index) {
    state = index;
  }

  // Reset về trang đầu (dùng khi đóng dialog mở lại)
  void reset() {
    state = 0;
  }
}

// Provider
final guideProvider = StateNotifierProvider.autoDispose<GuideNotifier, int>((ref) {
  return GuideNotifier();
});