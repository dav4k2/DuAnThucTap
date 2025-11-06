import 'package:flutter/material.dart';

class RecommendedList extends StatelessWidget {
  const RecommendedList({super.key});

  @override
  Widget build(BuildContext context) {
    // Danh sách món ăn đề xuất
    final List<Map<String, String>> recommended = [
      {
        'image': 'image/Rectangle301.png',
        'title': 'Gà rán Công Phượng',
        'author': 'Đăng bởi Kong Fuong',
        'time': '45 Phút',
        'difficulty': 'Dễ',
      },
      {
        'image': 'image/Rectangle30.png',
        'title': 'Mỳ Ý bò bằm',
        'author': 'Đăng bởi Sơn',
        'time': '20 Phút',
        'difficulty': 'Trung bình',
      },
      {
        'image': 'image/Rectangle302.png',
        'title': 'Phở Tái',
        'author': 'Đăng bởi Minh Anh',
        'time': '30 Phút',
        'difficulty': 'Dễ',
      },

      {
        'image': 'image/Rectangle32.png',
        'title': 'Phở Tái',
        'author': 'Đăng bởi thái công',
        'time': '30 Phút',
        'difficulty': 'Dễ',
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.all(16),
          child: Text(
            'Đề xuất',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
          ),
        ),
        ...recommended.map(
              (item) => Container(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            height: 90,
            decoration: BoxDecoration(
              color: Colors.white, // ✅ Nền trắng thay vì xám
              borderRadius: BorderRadius.circular(15),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 6,
                  offset: Offset(0, 3),
                ),
              ],
            ),
            child: Row(
              children: [
                // Ảnh món ăn
                ClipRRect(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(15),
                    bottomLeft: Radius.circular(15),
                  ),
                  child: Image.asset(
                    item['image']!,
                    width: 100,
                    height: 90,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(width: 12),

                // Nội dung thông tin
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          item['title']!,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                            color: Colors.black,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          item['author']!,
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 12,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${item['time']} | ${item['difficulty']}',
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
