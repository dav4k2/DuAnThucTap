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
    const double headerHeight = 400; // Chiều cao tổng thể của header

    return SizedBox(
      height: headerHeight,
      width: double.infinity,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          // 1. Ảnh nền - Tràn lên sát mép trên cùng
          Positioned.fill(
            child: Image.network(
              widget.recipe.images.isNotEmpty ? widget.recipe.images.first : '',
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) =>
                  Image.asset("image/placeholder.png", fit: BoxFit.cover),
            ),
          ),

          // 2. Lớp màu trắng tạo độ bo góc ở đáy ảnh
          Positioned(
            left: 0,
            right: 0,
            bottom: -1,
            height: 40,
            child: Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(35),
                  topRight: Radius.circular(35),
                ),
              ),
            ),
          ),

          // 3. Thanh điều hướng (Nút Back, Heart, Menu)
          Positioned(
            top: 50, // Khoảng cách từ mép trên để tránh camera nốt ruồi
            left: 16,
            right: 16,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _iconButton(
                  icon: Icons.arrow_back_ios_new_rounded,
                  onTap: () => Navigator.pop(context),
                ),
                Row(
                  children: [
                    _iconButton(
                      icon: isFavorite ? Icons.favorite : Icons.favorite_border,
                      backgroundColor: isFavorite ? Colors.red : null,
                      iconColor: Colors.white,
                      onTap: () => setState(() => isFavorite = !isFavorite),
                    ),
                    const SizedBox(width: 12),
                    _iconButton(
                      icon: Icons.menu_rounded,
                      backgroundColor: showMenu ? Colors.white : null,
                      iconColor: showMenu ? Colors.black87 : Colors.white,
                      onTap: () => setState(() => showMenu = !showMenu),
                    ),
                  ],
                )
              ],
            ),
          ),

          // 4. Logic Menu (Giữ nguyên logic cũ của bạn)
          if (showMenu)
            Positioned.fill(
              child: GestureDetector(
                onTap: () => setState(() => showMenu = false),
                child: Container(color: Colors.transparent),
              ),
            ),

          if (showMenu)
            Positioned(
              top: 100, right: 16,
              child: Material(
                elevation: 10,
                borderRadius: BorderRadius.circular(16),
                color: Colors.white,
                child: Container(
                  width: 200,
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      _menuItem("chỉnh sửa món ăn".tr(), onTap: () {}),
                      _menuItem("Xóa món này".tr(), color: Colors.red, onTap: _showDeleteDialog),
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  // --- Các hàm logic hiển thị Dialog và Button (Giữ nguyên bản gốc) ---
  void _showDeleteDialog() {
    setState(() => showMenu = false);
    showDialog(
      context: context,
      barrierColor: Colors.black.withOpacity(0.2),
      builder: (ctx) {
        return BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 4, sigmaY: 4),
          child: AlertDialog(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            title: Text("Xóa công thức này?".tr(), textAlign: TextAlign.center, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
            content: Text("Hành động này không thể hoàn tác".tr(), textAlign: TextAlign.center, style: const TextStyle(color: Colors.black54)),
            actionsAlignment: MainAxisAlignment.spaceEvenly,
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(ctx),
                child: Text("Hủy".tr(), style: const TextStyle(color: Colors.grey, fontSize: 16, fontWeight: FontWeight.bold)),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(ctx);
                },
                child: Text("Xóa".tr(), style: const TextStyle(color: Colors.red, fontSize: 16, fontWeight: FontWeight.bold)),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _iconButton({required IconData icon, Color? backgroundColor, Color? iconColor, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 46, height: 46,
        decoration: BoxDecoration(
          color: backgroundColor ?? Colors.black.withOpacity(0.25),
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: iconColor ?? Colors.white, size: 22),
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
            Expanded(child: Text(text, style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500, color: color ?? Colors.black87))),
          ],
        ),
      ),
    );
  }
}