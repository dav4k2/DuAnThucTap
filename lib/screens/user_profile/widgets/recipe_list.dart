// lib/screens/user_profile/widgets/recipe_list.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../logic/chef_provider.dart';
import 'recipe_card.dart';


class RecipeList extends StatelessWidget {
  final List<Recipe> recipes;
  final double topOffset;
  const RecipeList({super.key, required this.recipes, this.topOffset = 0});

  @override
  Widget build(BuildContext context) {
    if (recipes.isEmpty) return const SizedBox();

    return Padding(
      padding: EdgeInsets.fromLTRB(1.w, 0.h, 1.w, 1.h),
      child: Column(
        children: recipes.asMap().entries.map((e) {
          final recipe = e.value;
          return Padding(
            padding: EdgeInsets.only(bottom: 24.h),
            child: RecipeCard(
              recipe: recipe,
              onTap: () {
                // Mở chi tiết
              },
            ),
          );
        }).toList(),
      ),
    );
  }
}