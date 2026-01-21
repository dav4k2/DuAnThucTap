import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fontend/screens/Crete_recipe/logic/publish_recipe.dart';
import '../../../Crete_recipe/logic/publish_service.dart';
import '../../../food_page/recipe_detail_page_screen.dart';
import '../logic/my_profile_provider.dart';
import 'my_recipe_card.dart';

// Sử dụng ConsumerStatefulWidget để vừa có State (vòng đời) vừa dùng được Riverpod (ref)
class MyRecipeList extends ConsumerStatefulWidget {
  final String userId; // ID của người dùng để lấy danh sách bài đăng của họ

  const MyRecipeList({
    super.key,
    required this.userId,
  });

  @override
  ConsumerState<MyRecipeList> createState() => _MyRecipeListState();
}

class _MyRecipeListState extends ConsumerState<MyRecipeList> {
  // Biến stream để hứng luồng dữ liệu danh sách công thức
  late Stream<List<PublishRecipe>> _recipeStream;

  @override
  void initState() {
    super.initState();
    // Gọi service lấy danh sách công thức dựa trên userId ngay khi màn hình khởi tạo
    _recipeStream = PublishService().getRecipesByUser(widget.userId);
  }

  @override
  Widget build(BuildContext context) {
    // Lắng nghe sự thay đổi của Tab (Tất cả, Bữa sáng, Bữa trưa...) từ Riverpod
    // Khi myMealTabProvider thay đổi, hàm build sẽ chạy lại để lọc danh sách mới.
    final currentTab = ref.watch(myMealTabProvider);

    return StreamBuilder<List<PublishRecipe>>(
      stream: _recipeStream, // Lắng nghe luồng dữ liệu đã khởi tạo ở trên
      builder: (context, snapshot) {
        // 1. Trạng thái đang tải dữ liệu
        if (snapshot.connectionState == ConnectionState.waiting) {
          // SliverToBoxAdapter dùng để bọc widget thường (như Padding) vào trong CustomScrollView
          return const SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 20),
              child: Center(child: CircularProgressIndicator()),
            ),
          );
        }

        // 2. Trạng thái có lỗi
        if (snapshot.hasError) {
          return SliverToBoxAdapter(
              child: Center(child: Text("Lỗi: ${snapshot.error}")));
        }

        // Lấy dữ liệu ra, nếu null thì gán bằng mảng rỗng
        final allRecipes = snapshot.data ?? [];

        // --- LOGIC LỌC DỮ LIỆU (Client-side filtering) ---
        final filteredRecipes = allRecipes.where((recipe) {
          // Nếu tab là "Tất cả" thì lấy hết
          if (currentTab == MealTab.tatCa) return true;

          // Gộp tiêu đề và mô tả, chuyển về chữ thường để so sánh tìm kiếm
          final text = '${recipe.title} ${recipe.description}'.toLowerCase();

          // Logic tìm kiếm thủ công dựa trên từ khóa (keywords)
          if (currentTab == MealTab.buaSang) {
            // .tr() là hàm dịch đa ngôn ngữ
            return text.contains('sáng'.tr()) ||
                text.contains('bánh mì') ||
                text.contains('phở') ||
                text.contains('xôi') ||
                text.contains('trứng');
          }
          if (currentTab == MealTab.buaTrua) {
            return text.contains('trưa') ||
                text.contains('cơm') ||
                text.contains('bún') ||
                text.contains('thịt');
          }
          if (currentTab == MealTab.anVat) {
            return text.contains('ăn vặt') ||
                text.contains('bánh') ||
                text.contains('chè') ||
                text.contains('trà');
          }
          return true; // Mặc định giữ lại nếu không khớp các case trên (hoặc xử lý khác tùy logic)
        }).toList();

        // --- HIỂN THỊ GIAO DIỆN ---

        // Trường hợp 1: Danh sách rỗng sau khi lọc
        if (filteredRecipes.isEmpty) {
          String msg = currentTab == MealTab.tatCa
              ? "Chưa có công thức nào".tr()
              : "Không có món phù hợp".tr();

          return SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.only(top: 50.h),
              child: Column(
                children: [
                  Icon(Icons.no_meals, size: 40.sp, color: Colors.grey[300]),
                  SizedBox(height: 10.h),
                  Text(msg, style: TextStyle(color: Colors.grey, fontSize: 14.sp)),
                ],
              ),
            ),
          );
        }

        // Trường hợp 2: Có dữ liệu -> Hiển thị danh sách
        return SliverList(
          delegate: SliverChildBuilderDelegate(
                (context, index) {
              // Item đầu tiên (index 0) dùng để hiển thị Header số lượng món
              if (index == 0) return _buildHeader(filteredRecipes.length);

              // Các item tiếp theo là món ăn (phải trừ đi 1 vì index 0 là header)
              final recipe = filteredRecipes[index - 1];

              return Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                child: GestureDetector(
                  onTap: () {
                    // Chuyển sang màn hình chi tiết món ăn
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => RecipeDetailPage(recipe: recipe),
                      ),
                    );
                  },
                  // Widget hiển thị thẻ món ăn (UI)
                  child: MyRecipeCard(recipe: recipe),
                ),
              );
            },
            // Tổng số phần tử = số món ăn + 1 (header)
            childCount: filteredRecipes.length + 1,
          ),
        );
      },
    );
  }

  // Hàm phụ: Xây dựng giao diện Header hiển thị tổng số món
  Widget _buildHeader(int count) {
    return Padding(
      padding: EdgeInsets.fromLTRB(16.w, 10.h, 16.w, 5.h),
      child: Text(
        'Danh sách ($count)'.tr(),
        style: TextStyle(
            fontSize: 14.sp,
            fontWeight: FontWeight.w600,
            color: Colors.grey[700]),
      ),
    );
  }
}