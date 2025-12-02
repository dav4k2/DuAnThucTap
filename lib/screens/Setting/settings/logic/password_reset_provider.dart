// password_reset_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Định nghĩa trạng thái mà màn hình cần theo dõi
class PasswordResetState {
  final bool isLoading;
  final String? errorMessage;

  PasswordResetState({this.isLoading = false, this.errorMessage});

  PasswordResetState copyWith({bool? isLoading, String? errorMessage}) {
    return PasswordResetState(
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
    );
  }
}

// Controller (Notifier) để xử lý logic
class PasswordResetController extends StateNotifier<PasswordResetState> {
  PasswordResetController() : super(PasswordResetState());

  // Hàm xử lý đặt lại mật khẩu
  Future<void> resetPassword({
    required String currentPassword,
    required String newPassword,
    required String confirmPassword,
  }) async {
    state = state.copyWith(isLoading: true, errorMessage: null);

    // 1. Kiểm tra Mật khẩu nhập lại KHÔNG trùng
    if (newPassword != confirmPassword) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'Mật khẩu mới và mật khẩu nhập lại không khớp.',
      );
      return;
    }


    //giả lập API call
    await Future.delayed(const Duration(milliseconds: 1500));

    const String correctCurrentPassword = "user12345";

    if (currentPassword != correctCurrentPassword) {
      // Giả lập lỗi Mật khẩu không đúng
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'Mật khẩu hiện tại không chính xác.',
      );
      return;
    }

    // Thành công
    state = state.copyWith(
      isLoading: false,
      errorMessage: 'Đổi mật khẩu thành công!',
    );
    // Có thể thêm điều hướng ở đây: Navigator.pop(context);
  }

  // Hàm này để xóa lỗi khi người dùng bắt đầu nhập lại
  void clearError() {
    if (state.errorMessage != null) {
      state = state.copyWith(errorMessage: null);
    }
  }
}

// Khai báo provider
final passwordResetProvider = StateNotifierProvider<PasswordResetController, PasswordResetState>(
      (ref) => PasswordResetController(),
);