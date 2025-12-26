import 'dart:ui'; // ✅ QUAN TRỌNG: Import để làm mờ
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
    const double headerHeight = 380;

    return SizedBox(
      height: headerHeight,
      width: double.infinity,
      child: Stack(
        children: [
          // 1. Ảnh nền
          Positioned.fill(
            child: ClipRRect(
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(32),
                bottomRight: Radius.circular(32),
              ),
              child: Image.network(
                widget.recipe.images.isNotEmpty ? widget.recipe.images.first : '',
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Image.asset("image/placeholder.png"), // Ảnh mặc định nếu lỗi
              ),
            ),
          ),

          // 2. Gradient
          Positioned(
            top: 0, left: 0, right: 0, height: 160,
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withOpacity(0.6),
                    Colors.black.withOpacity(0.2),
                    Colors.transparent,
                  ],
                ),
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
                  onTap: () => Navigator.pop(context),
                ),
                Row(
                  children: [
                    _iconButton(
                      icon: isFavorite ? Icons.favorite : Icons.favorite_border,
                      backgroundColor: isFavorite ? Colors.red.withOpacity(0.9) : null,
                      iconColor: isFavorite ? Colors.white : null,
                      onTap: () => setState(() => isFavorite = !isFavorite),
                    ),
                    const SizedBox(width: 12),
                    _editButton(onTap: () => print("Chỉnh sửa".tr())),
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

          // 4. Lớp phủ tắt menu
          if (showMenu)
            Positioned.fill(
              child: GestureDetector(
                onTap: () => setState(() => showMenu = false),
                child: Container(color: Colors.transparent),
              ),
            ),

          // 5. Menu Dropdown
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
                      _menuItem("Thêm vào bộ sưu tập".tr(), onTap: () {}),
                      const Divider(height: 1),
                      _menuItem("Chia sẻ".tr(), onTap: () {}),
                      const Divider(height: 1),
                      _menuItem("Xem thống kê".tr(), onTap: () {}),
                      const Divider(height: 1),
                      // 👇 Gọi hàm xóa ở đây
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

  // ============================================
  // ✅ HÀM HIỂN THỊ DIALOG XÓA (CÓ BLUR)
  // ============================================
  void _showDeleteDialog() {
    setState(() => showMenu = false); // Tắt menu trước

    showDialog(
      context: context,
      barrierColor: Colors.black.withOpacity(0.2), // Màu nền tối nhẹ
      builder: (ctx) {
        // 👇 Widget BackdropFilter tạo hiệu ứng mờ
        return BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 4, sigmaY: 4), // Chỉnh độ mờ tại đây
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
                  print("Đã xóa!".tr()); // Logic xóa thực tế
                },
                child: Text("Xóa".tr(), style: const TextStyle(color: Colors.red, fontSize: 16, fontWeight: FontWeight.bold)),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _editButton({required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 46, padding: const EdgeInsets.symmetric(horizontal: 16),
        alignment: Alignment.center,
        decoration: BoxDecoration(color: const Color(0xFFFFC107), borderRadius: BorderRadius.circular(12)),
        child: Text("Chỉnh sửa".tr(), style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 15)),
      ),
    );
  }

  Widget _iconButton({required IconData icon, Color? backgroundColor, Color? iconColor, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 46, height: 46,
        decoration: BoxDecoration(
          color: backgroundColor ?? Colors.white.withOpacity(0.25),
          shape: BoxShape.circle,
          border: Border.all(color: Colors.white.withOpacity(0.7), width: 1.4),
        ),
        child: Icon(icon, color: iconColor ?? Colors.white, size: 22),
      ),
    );
  }

  // Sửa lại _menuItem để nhận onTap
  Widget _menuItem(String text, {Color? color, required VoidCallback onTap}) {
    return InkWell(
      onTap: () {
        if (text != "Xóa món này".tr()) setState(() => showMenu = false); // Nếu không phải nút xóa thì tự tắt menu
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