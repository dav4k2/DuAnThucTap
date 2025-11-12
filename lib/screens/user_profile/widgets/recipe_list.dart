// lib/widgets/recipe_list.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../logic/chef_provider.dart';
import 'recipe_card.dart';

class RecipeList extends ConsumerWidget {
  final List<Recipe> recipes;

  const RecipeList({super.key, required this.recipes});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (recipes.isEmpty) {
      return const SliverToBoxAdapter(child: SizedBox.shrink());
    }

    final totalRecipes = ref.read(chefProvider).allRecipes.length;

    return SliverList(
      delegate: SliverChildBuilderDelegate(
            (context, index) {
          if (index == 0) {
            return _buildHeader(totalRecipes);
          }
          final recipe = recipes[index - 1];
          return Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 8.h),
            child: RecipeCard(
              recipe: recipe,
              onTap: () {
                // Mở chiivew chi tiết công thức
              },
            ),
          );
        },
        childCount: recipes.length + 1,
      ),
    );
  }

  Widget _buildHeader(int totalRecipes) {
    return Padding(
      padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 8.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text.rich(
            TextSpan(
              children: [
                TextSpan(
                  text: 'Công thức',
                  style: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.w600),
                ),
                TextSpan(
                  text: ' ($totalRecipes)',
                  style: TextStyle(fontSize: 15.sp, color: Colors.black.withOpacity(0.6)),
                ),
              ],
            ),
          ),

        ],
      ),
    );
  }
}