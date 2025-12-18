import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fontend/screens/Crete_recipe/logic/publish_recipe.dart';
import '../../../../Service/recipe_model.dart';
import '../../../../Service/recipe_service.dart';
import '../../../Crete_recipe/logic/publish_service.dart';
import '../logic/my_profile_provider.dart';
import 'my_recipe_card.dart';

class MyRecipeList extends ConsumerStatefulWidget {
  final String userId;

  const MyRecipeList({
    super.key,
    required this.userId,
  });

  @override
  ConsumerState<MyRecipeList> createState() => _MyRecipeListState();
}

class _MyRecipeListState extends ConsumerState<MyRecipeList> {
  // Giữ Stream để không bị load lại (xoay vòng tròn) khi chuyển Tab
  late Stream<List<PublishRecipe>> _recipeStream;

  @override
  void initState() {
    super.initState();
    _recipeStream = PublishService().getRecipesByUser(widget.userId);
  }

  @override
  Widget build(BuildContext context) {
    // Lắng nghe Tab để lọc
    final currentTab = ref.watch(myMealTabProvider);

    return StreamBuilder<List<PublishRecipe>>(
      stream: _recipeStream,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 20),
              child: Center(child: CircularProgressIndicator()),
            ),
          );
        }

        if (snapshot.hasError) {
          return SliverToBoxAdapter(child: Center(child: Text("Lỗi: ${snapshot.error}")));
        }

        final allRecipes = snapshot.data ?? [];

        // --- LOGIC LỌC ---
        final filteredRecipes = allRecipes.where((recipe) {
          if (currentTab == MealTab.tatCa) return true;

          final text = '${recipe.title} ${recipe.description}'.toLowerCase();

          if (currentTab == MealTab.buaSang) {
            return text.contains('sáng') || text.contains('bánh mì') || text.contains('phở') || text.contains('xôi') || text.contains('trứng');
          }
          if (currentTab == MealTab.buaTrua) {
            return text.contains('trưa') || text.contains('cơm') || text.contains('bún') || text.contains('thịt');
          }
          if (currentTab == MealTab.anVat) {
            return text.contains('ăn vặt') || text.contains('bánh') || text.contains('chè') || text.contains('trà');
          }
          return true;
        }).toList();

        // --- HIỂN THỊ ---
        if (filteredRecipes.isEmpty) {
          String msg = currentTab == MealTab.tatCa
              ? "Chưa có công thức nào"
              : "Không có món phù hợp";

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

        return SliverList(
          delegate: SliverChildBuilderDelegate(
                (context, index) {
              if (index == 0) return _buildHeader(filteredRecipes.length);
              final recipe = filteredRecipes[index - 1];
              return Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                child: MyRecipeCard(recipe: recipe),
              );
            },
            childCount: filteredRecipes.length + 1,
          ),
        );
      },
    );
  }

  Widget _buildHeader(int count) {
    return Padding(
      padding: EdgeInsets.fromLTRB(16.w, 10.h, 16.w, 5.h),
      child: Text(
        'Danh sách ($count)',
        style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w600, color: Colors.grey[700]),
      ),
    );
  }
}