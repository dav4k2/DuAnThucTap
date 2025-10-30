// Widget hiển thị mục "Công thức nổi bật" trong trang khám phá
import 'package:flutter/material.dart';

class HighlightRecipes extends StatelessWidget {
  final double width; // Chiều rộng màn hình, truyền từ bên ngoài

  const HighlightRecipes({super.key, required this.width});

  @override
  Widget build(BuildContext context) {
    // Danh sách các công thức nổi bật (tên món + đường dẫn ảnh)
    final recipes = [
      {
        'name': 'Gà rán sốt Hàn Quốc',
        'image': 'image/my_y.png',
      },
      {
        'name': 'Mỳ Ý sốt Bolognese',
        'image': 'image/garan.png',
      },
    ];

    return Container(
      width: width, // Căn theo chiều rộng màn hình
      color: Colors.white, // Màu nền trắng
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12), // Lề trong

      // Gói toàn bộ phần nội dung (tiêu đề + danh sách món)
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start, // Căn trái
        children: [
          // Hàng tiêu đề gồm: "Công thức nổi bật" và "Xem thêm"
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween, // Giãn 2 đầu
            children: const [
              Text(
                'Công thức nổi bật',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                ),
              ),
              Text(
                'Xem thêm',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.black54,
                ),
              ),
            ],
          ),

          const SizedBox(height: 12), // Khoảng cách dưới tiêu đề

          // Danh sách ngang các công thức
          SingleChildScrollView(
            scrollDirection: Axis.horizontal, // Cho phép cuộn ngang
            child: Row(
              // Duyệt qua danh sách `recipes` để tạo từng thẻ món ăn
              children: recipes
                  .map(
                    (r) => _recipeCard(r), // Gọi hàm riêng để dựng card món ăn
              )
                  .toList(),
            ),
          ),
        ],
      ),
    );
  }

  // Hàm dựng từng thẻ món ăn (card hiển thị ảnh + tên món)
  Widget _recipeCard(Map<String, String> r) {
    return Container(
      margin: const EdgeInsets.only(right: 12), // Khoảng cách giữa các card
      width: 225,
      height: 133,
      clipBehavior: Clip.hardEdge, // Cắt phần ảnh bị tràn ra ngoài viền bo góc
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15), // Bo tròn góc card
      ),
      child: Stack(
        fit: StackFit.expand, // Mở rộng toàn bộ vùng chứa
        children: [
          // Ảnh nền của món ăn
          Image.asset(
            r['image']!, // Dấu ! để xác nhận không null
            fit: BoxFit.cover, // Ảnh phủ đầy vùng hiển thị
          ),

          // Lớp mờ + tên món ở phía dưới ảnh
          Align(
            alignment: Alignment.bottomCenter, // Căn phần text xuống dưới
            child: Container(
              height: 30, // Chiều cao vùng chứa tên món
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.45), // Nền đen mờ
              ),
              child: Center(
                // Hiển thị tên món ăn
                child: Text(
                  r['name']!, // Lấy tên món
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                  ),
                  overflow: TextOverflow.ellipsis, // Nếu quá dài sẽ hiển thị "..."
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
