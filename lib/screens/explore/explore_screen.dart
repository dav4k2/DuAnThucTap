import 'package:flutter/material.dart';
import 'widgets/explore_user_item.dart';
import 'widgets/explore_keyword_chip.dart';
import 'widgets/explore_recipe_card.dart';
import 'widgets/explore_section_header.dart';

class ExploreScreen extends StatelessWidget {
  const ExploreScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      // AppBar tuỳ chỉnh gồm tiêu đề + thanh tìm kiếm
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(150),
        child: Container(
          color: const Color(0xFFFFC107),
          padding: const EdgeInsets.only(top: 40, left: 16, right: 16, bottom: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Hàng tiêu đề
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.black),
                    onPressed: () => Navigator.pop(context),
                  ),
                  const Expanded(
                    child: Center(
                      child: Text(
                        'Khám phá',
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 48),
                ],
              ),

              const SizedBox(height: 8),

              // Ô tìm kiếm
              TextField(
                decoration: InputDecoration(
                  hintText: 'Nhập tên món ăn hoặc nguyên liệu...',
                  prefixIcon: const Icon(Icons.search),
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 16),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 8),

            // Người dùng phổ biến
            const ExploreSectionHeader(title: 'Người dùng phổ biến'),
            const SizedBox(height: 8),
            SizedBox(
              height: 90,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: const [
                  ExploreUserItem(imagePath: 'assets/img/bean.jpeg', name: 'Mr.Dean'),
                  ExploreUserItem(imagePath: 'assets/img/vit.jpeg', name: 'Donald D.'),
                  ExploreUserItem(imagePath: 'assets/img/a7.jpeg', name: 'Cristiano M.'),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Từ khóa nổi bật
            const ExploreSectionHeader(title: 'Từ khóa nổi bật'),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: const [
                ExploreKeywordChip('Healthy'),
                ExploreKeywordChip('Đồ cay'),
                ExploreKeywordChip('Ngọt'),
                ExploreKeywordChip('Đồ ăn nhanh'),
                ExploreKeywordChip('Mỳ sốt'),
                ExploreKeywordChip('Ăn sáng'),
                ExploreKeywordChip('Bánh'),
                ExploreKeywordChip('Súp'),
                ExploreKeywordChip('Đồ chay'),
              ],
            ),
            const SizedBox(height: 20),

            // Công thức nổi bật
            const ExploreSectionHeader(title: 'Công thức nổi bật'),
            const SizedBox(height: 8),
            SizedBox(
              height: 180,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: const [
                  ExploreRecipeCard(
                    imagePath: 'assets/img/garan.jpeg',
                    title: 'Gà rán sốt Hàn Quốc',
                    rating: '4.8 (1k+ Đánh giá)',
                  ),
                  ExploreRecipeCard(
                    imagePath: 'assets/img/my_y.jpg',
                    title: 'Mỳ Ý sốt Bolognese',
                    rating: '4.8 (1k+ Đánh giá)',
                  ),
                ],
              ),
            ),
          ],
        ),
      ),

      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.amber,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.add_box), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: ''),
        ],
      ),
    );
  }
}
