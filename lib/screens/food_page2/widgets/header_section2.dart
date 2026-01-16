import 'dart:ui';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Import các logic cần thiết của bạn
import '../../Crete_recipe/logic/publish_recipe.dart';
import '../../user_profile/MyUser_profile/logic/my_profile_provider.dart';

class HeaderSection2 extends ConsumerStatefulWidget {
  final PublishRecipe recipe;
  const HeaderSection2({super.key, required this.recipe});

  @override
  ConsumerState<HeaderSection2> createState() => _HeaderSectionState();
}

class _HeaderSectionState extends ConsumerState<HeaderSection2> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    // Lấy trạng thái từ Provider để kiểm tra món ăn đã được lưu chưa
    final savedList = ref.watch(savedRecipesProvider);
    bool isFavorite = savedList.any((r) => r.title == widget.recipe.title);

    const double headerHeight = 400;

    // Cấu hình màu sắc theo Theme
    final overlayBgColor = isDark
        ? Colors.black.withOpacity(0.4)
        : Colors.black.withOpacity(0.25);
    final bottomCurveColor = isDark ? Colors.grey[900]! : Colors.white;

    return SizedBox(
      height: headerHeight,
      width: double.infinity,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          // 1. Ảnh nền món ăn
          Positioned.fill(
            child: Image.network(
              widget.recipe.images.isNotEmpty ? widget.recipe.images.first : '',
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) =>
                  Image.asset("image/placeholder.png", fit: BoxFit.cover),
            ),
          ),

          // 2. Lớp bo góc phía dưới ảnh
          Positioned(
            left: 0,
            right: 0,
            bottom: -1,
            height: 40,
            child: Container(
              decoration: BoxDecoration(
                color: bottomCurveColor,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(35),
                  topRight: Radius.circular(35),
                ),
              ),
            ),
          ),

          // 3. Thanh điều hướng: Nút Back và Nút Tim
          Positioned(
            top: 50,
            left: 16,
            right: 16,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Nút quay lại
                _iconButton(
                  icon: Icons.arrow_back_ios_new_rounded,
                  backgroundColor: overlayBgColor,
                  iconColor: Colors.white,
                  onTap: () => Navigator.pop(context),
                ),

                // Nút yêu thích (Tim)
                _iconButton(
                  icon: isFavorite ? Icons.favorite : Icons.favorite_border,
                  backgroundColor: isFavorite ? Colors.red : overlayBgColor,
                  iconColor: Colors.white,
                  onTap: () => _handleToggleFavorite(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Hàm xử lý logic lưu/hủy lưu món ăn
  Future<void> _handleToggleFavorite() async {
    String authorName = "Đầu bếp ẩn danh";
    final authorId = widget.recipe.authorId;
    final currentUser = FirebaseAuth.instance.currentUser;

    // Logic xác định tên tác giả
    if (authorId != null) {
      if (currentUser != null && authorId == currentUser.uid) {
        authorName = currentUser.displayName ?? "Tôi";
      } else {
        try {
          final doc = await FirebaseFirestore.instance
              .collection('users')
              .doc(authorId)
              .get();

          if (doc.exists) {
            authorName = doc.data()?['displayName'] ?? "Người dùng";
          }
        } catch (e) {
          debugPrint("Lỗi lấy tên tác giả: $e");
        }
      }
    }

    // Tạo object Recipe để lưu vào Provider
    final recipeToSave = Recipe(
      id: widget.recipe.id,
      title: widget.recipe.title,
      time: widget.recipe.cookingTime ?? "30 phút",
      difficulty: widget.recipe.difficulty ?? "Dễ",
      author: authorName,
      rating: widget.recipe.averageRating,
      reviews: widget.recipe.totalRatings,
      meal: MealTab.tatCa,
      imageAsset: widget.recipe.images.isNotEmpty
          ? widget.recipe.images.first
          : "image/placeholder.png",
    );

    // Cập nhật trạng thái thông qua Riverpod
    if (mounted) {
      ref.read(savedRecipesProvider.notifier).toggleSave(recipeToSave);
    }
  }

  /// Widget dùng chung cho các nút bấm hình tròn trên ảnh
  Widget _iconButton({
    required IconData icon,
    Color? backgroundColor,
    Color? iconColor,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 46,
        height: 46,
        decoration: BoxDecoration(
          color: backgroundColor,
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: iconColor, size: 22),
      ),
    );
  }
}