// lib/widgets/recipe_list.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../recipe_detail_screen.dart';
import 'recipe_card.dart';
import '../logic/chef_provider.dart';

class RecipeList extends StatelessWidget {
  final List<Recipe> recipes;
  final double topOffset;
  const RecipeList({super.key, required this.recipes, this.topOffset = 594});

  @override
  Widget build(BuildContext context) {
    if (recipes.isEmpty) return const SizedBox();

    return Positioned(
      left: 43.w,
      top: topOffset.h,
      child: SizedBox(
        width: 322.w,
        height: 280.h, // đủ để cuộn 2-3 món
        child: ListView.builder(
          padding: EdgeInsets.zero,
          itemCount: recipes.length,
          itemBuilder: (context, index) {
            final recipe = recipes[index];
            return Padding(
              padding: EdgeInsets.only(bottom: 24.h),
              child: RecipeCard(
                recipe: recipe,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => RecipeDetailScreen(recipe: recipe),
                    ),
                  );
                },
              ),
            );
          },
        ),
      ),
    );
  }
}