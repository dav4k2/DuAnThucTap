import 'package:flutter/material.dart';

class HeaderSection extends StatefulWidget {
  const HeaderSection({super.key});

  @override
  State<HeaderSection> createState() => _HeaderSectionState();
}

class _HeaderSectionState extends State<HeaderSection> {
  bool isFavorite = false;
  bool showMenu = false;

  @override
  Widget build(BuildContext context) {
    const double headerHeight = 380; // chuẩn theo UI mẫu

    return SizedBox(
      height: headerHeight,
      width: double.infinity,
      child: Stack(
        children: [
          // ================== ẢNH TRÀN FULL ==================
          Positioned.fill(
            child: ClipRRect(
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(32),
                bottomRight: Radius.circular(32),
              ),
              child: Image.asset(
                "image/pho_tai_nam.png",
                fit: BoxFit.cover,
                alignment: Alignment.topCenter,
              ),
            ),
          ),

          // -------------------- GRADIENT NHẸ --------------------
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: 160,
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withOpacity(0.55),
                    Colors.black.withOpacity(0.20),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),

          // ----------------- ICON BACK / HEART / MENU -----------------
          Positioned(
            top: 12,
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
                      backgroundColor:
                      isFavorite ? Colors.red.withOpacity(0.9) : null,
                      onTap: () => setState(() => isFavorite = !isFavorite),
                    ),
                    const SizedBox(width: 12),
                    _iconButton(
                      icon: Icons.menu_rounded,
                      backgroundColor: showMenu ? Colors.white : null,
                      iconColor:
                      showMenu ? Colors.black87 : Colors.white,
                      onTap: () => setState(() => showMenu = !showMenu),
                    ),
                  ],
                )
              ],
            ),
          ),

          // -------------------- MENU DROPDOWN --------------------
          if (showMenu)
            Positioned(
              top: 70,
              right: 16,
              child: Material(
                elevation: 18,
                borderRadius: BorderRadius.circular(18),
                child: Container(
                  width: 210,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      _menuItem("Thêm vào bộ sưu tập"),
                      const Divider(height: 1),
                      _menuItem("Chia sẻ"),
                      const Divider(height: 1),
                      _menuItem("Theo dõi"),
                      const Divider(height: 1),
                      _menuItem("Báo cáo / Chặn", color: Colors.red),
                    ],
                  ),
                ),
              ),
            ),

          // Tap ra ngoài để tắt menu
          if (showMenu)
            Positioned.fill(
              child: GestureDetector(
                onTap: () => setState(() => showMenu = false),
                child: Container(color: Colors.transparent),
              ),
            ),
        ],
      ),
    );
  }

  // =======================================
  // CUSTOM BUTTON
  // =======================================
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
          color: backgroundColor ?? Colors.white.withOpacity(0.25),
          shape: BoxShape.circle,
          border: Border.all(color: Colors.white.withOpacity(0.7), width: 1.4),
        ),
        child: Icon(icon, color: iconColor ?? Colors.white, size: 23),
      ),
    );
  }

  // =======================================
  // MENU ITEM
  // =======================================
  Widget _menuItem(String text, {Color? color}) {
    return InkWell(
      onTap: () => setState(() => showMenu = false),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            Text(
              text,
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: color ?? Colors.black87,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
