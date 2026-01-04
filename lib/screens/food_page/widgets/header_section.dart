import 'dart:ui';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../Crete_recipe/logic/publish_recipe.dart';

class HeaderSection extends StatefulWidget {
  final PublishRecipe recipe;
  const HeaderSection({super.key, required this.recipe});

  @override
  State<HeaderSection> createState() => _HeaderSectionState();
}

class _HeaderSectionState extends State<HeaderSection> {
  bool isFavorite = false;
  bool showMenu = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    const double headerHeight = 400;

    // Màu sắc theo theme (chỉ thay đổi phần dark mode, giữ nguyên logic)
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
          // 1. Ảnh nền
          Positioned.fill(
            child: Image.network(
              widget.recipe.images.isNotEmpty ? widget.recipe.images.first : '',
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) =>
                  Image.asset("image/placeholder.png", fit: BoxFit.cover),
            ),
          ),

          // 2. Lớp màu trắng tạo độ bo góc ở đáy ảnh → chuyển theo theme
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

          // 3. Thanh điều hướng
          Positioned(
            top: 50,
            left: 16,
            right: 16,
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
                    _iconButton(
                      icon: isFavorite ? Icons.favorite : Icons.favorite_border,
                      backgroundColor: isFavorite ? Colors.red : overlayBgColor,
                      iconColor: Colors.white,
                      onTap: () => setState(() => isFavorite = !isFavorite),
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

          // 4. Overlay tắt menu khi bấm ngoài
          if (showMenu)
            Positioned.fill(
              child: GestureDetector(
                onTap: () => setState(() => showMenu = false),
                child: Container(color: Colors.transparent),
              ),
            ),

          // 5. Menu dropdown
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