import 'dart:ui';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart'; // 1. Import Riverpod
import '../../Crete_recipe/logic/publish_recipe.dart';
import '../../user_profile/MyUser_profile/logic/my_profile_provider.dart';
// 2. Import file chứa provider và Recipe model

class HeaderSection extends ConsumerStatefulWidget {
  final PublishRecipe recipe;
  final VoidCallback? onRefresh;
  const HeaderSection({super.key, required this.recipe, this.onRefresh,});

  @override
  ConsumerState<HeaderSection> createState() => _HeaderSectionState();
}

class _HeaderSectionState extends ConsumerState<HeaderSection> {
  // bool isFavorite = false; -> Bỏ biến cục bộ này đi
  bool showMenu = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    // 4. Lấy trạng thái từ Provider: Kiểm tra món này đã được tim chưa?
    final savedListNotifier = ref.read(savedRecipesProvider.notifier);
    final savedList = ref.watch(savedRecipesProvider);

    // Kiểm tra dựa trên title (hoặc ID nếu có)
    bool isFavorite = savedList.any((r) => r.title == widget.recipe.title);

    const double headerHeight = 400;

    // ... (Giữ nguyên phần khai báo màu sắc)
    final overlayBgColor = isDark ? Colors.black.withOpacity(0.4) : Colors.black.withOpacity(0.25);
    final menuBackgroundColor = isDark ? Colors.grey[850]! : Colors.white;
    final menuTextColor = isDark ? Colors.white : Colors.black87;
    final menuDeleteColor = Colors.red;
    final bottomCurveColor = isDark ? Colors.grey[900]! : Colors.white;

    return SizedBox(
      height: headerHeight,
      width: double.infinity,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          // 1. Ảnh nền (Giữ nguyên)
          Positioned.fill(
            child: Image.network(
              widget.recipe.images.isNotEmpty ? widget.recipe.images.first : '',
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) =>
                  Image.asset("image/placeholder.png", fit: BoxFit.cover),
            ),
          ),

          // 2. Lớp bo góc (Giữ nguyên)
          Positioned(
            left: 0, right: 0, bottom: -1, height: 40,
            child: Container(
              decoration: BoxDecoration(
                color: bottomCurveColor,
                borderRadius: const BorderRadius.only(topLeft: Radius.circular(35), topRight: Radius.circular(35)),
              ),
            ),
          ),

          // 3. Thanh điều hướng
          Positioned(
            top: 50, left: 16, right: 16,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _iconButton(
                  icon: Icons.arrow_back_ios_new_rounded,
                  backgroundColor: overlayBgColor,
                  iconColor: Colors.white,
                  onTap: () => Navigator.pop(context),
                ),
                Row(
                  children: [
                    // --- NÚT TIM (ĐÃ SỬA) ---
                    _iconButton(
                      icon: isFavorite ? Icons.favorite : Icons.favorite_border,
                      backgroundColor: isFavorite ? Colors.red : overlayBgColor,
                      iconColor: Colors.white,
                      onTap: () async { // 1. Thêm từ khóa async
                        String authorName = "Đầu bếp ẩn danh"; // Tên mặc định
                        final authorId = widget.recipe.authorId;
                        final currentUser = FirebaseAuth.instance.currentUser;

                        // 2. Logic xác định tên tác giả
                        if (authorId != null) {
                          if (currentUser != null && authorId == currentUser.uid) {
                            // Nếu tác giả là chính mình
                            authorName = currentUser.displayName ?? "Tôi";
                          } else {
                            // Nếu là người khác -> Lấy từ Firestore
                            try {
                              final doc = await FirebaseFirestore.instance
                                  .collection('users') // Đảm bảo collection user của bạn tên là 'users'
                                  .doc(authorId)
                                  .get();

                              if (doc.exists) {
                                // Lấy trường tên hiển thị (thường là displayName, name hoặc fullName)
                                authorName = doc.data()?['displayName'] ?? "Người dùng";
                              }
                            } catch (e) {
                              print("Lỗi lấy tên tác giả: $e");
                            }
                          }
                        }

                        // 3. Tạo object Recipe với tên tác giả vừa lấy được
                        final recipeToSave = Recipe(
                          id: widget.recipe.id,
                          title: widget.recipe.title,
                          time: widget.recipe.cookingTime ?? "30 phút",
                          difficulty: widget.recipe.difficulty ?? "Dễ",

                          author: authorName, // <-- ĐÃ CẬP NHẬT TÊN TÁC GIẢ Ở ĐÂY

                          rating: widget.recipe.averageRating,
                          reviews: widget.recipe.totalRatings,
                          meal: MealTab.tatCa,
                          imageAsset: widget.recipe.images.isNotEmpty
                              ? widget.recipe.images.first
                              : "image/placeholder.png",
                        );

                        // 4. Lưu vào Provider
                        if (mounted) { // Kiểm tra mounted vì hàm là async
                          ref.read(savedRecipesProvider.notifier).toggleSave(recipeToSave);
                        }
                      },
                    ),
                    const SizedBox(width: 12),
                    _iconButton(
                      icon: Icons.menu_rounded,
                      backgroundColor: showMenu ? (isDark ? Colors.white : Colors.white) : overlayBgColor,
                      iconColor: showMenu ? (isDark ? Colors.black87 : Colors.black87) : Colors.white,
                      onTap: () => setState(() => showMenu = !showMenu),
                    ),
                  ],
                )
              ],
            ),
          ),

          // ... (Giữ nguyên phần Menu Dropdown và Overlay)
          if (showMenu)
            Positioned.fill(
              child: GestureDetector(
                onTap: () => setState(() => showMenu = false),
                child: Container(color: Colors.transparent),
              ),
            ),

          if (showMenu)
            Positioned(
              top: 100,
              right: 16,
              child: Material(
                elevation: 10,
                borderRadius: BorderRadius.circular(16),
                color: menuBackgroundColor,
                child: Container(
                  width: 200,
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  decoration: BoxDecoration(
                    color: menuBackgroundColor,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      _menuItem("chỉnh sửa món ăn".tr(), color: menuTextColor, onTap: () {}),
                      _menuItem("Xóa món này".tr(), color: menuDeleteColor, onTap: _showDeleteDialog),
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  void _showDeleteDialog() {
    setState(() => showMenu = false);
    showDialog(
      context: context,
      barrierColor: Colors.black.withOpacity(0.2),
      builder: (ctx) {
        final isDark = Theme.of(ctx).brightness == Brightness.dark;
        final dialogTitleColor = isDark ? Colors.white : Colors.black;
        final dialogContentColor = isDark ? Colors.white70 : Colors.black54;
        final dialogCancelColor = isDark ? Colors.grey[400]! : Colors.grey;
        final dialogBgColor = isDark ? Colors.grey[850]! : Colors.white;

        return BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 4, sigmaY: 4),
          child: AlertDialog(
            backgroundColor: dialogBgColor,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            title: Text(
              "Xóa công thức này?".tr(),
              textAlign: TextAlign.center,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: dialogTitleColor),
            ),
            content: Text(
              "Hành động này không thể hoàn tác".tr(),
              textAlign: TextAlign.center,
              style: TextStyle(color: dialogContentColor),
            ),
            actionsAlignment: MainAxisAlignment.spaceEvenly,
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(ctx),
                child: Text(
                  "Hủy".tr(),
                  style: TextStyle(color: dialogCancelColor, fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(ctx);
                  // TODO: Thực hiện xóa ở đây
                },
                child: Text(
                  "Xóa".tr(),
                  style: const TextStyle(color: Colors.red, fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

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

  Widget _menuItem(String text, {Color? color, required VoidCallback onTap}) {
    return InkWell(
      onTap: () {
        if (text != "Xóa món này".tr()) setState(() => showMenu = false);
        onTap();
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            Expanded(
              child: Text(
                text,
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500, color: color),
              ),
            ),
          ],
        ),
      ),
    );
  }
}