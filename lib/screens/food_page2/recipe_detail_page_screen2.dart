import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fontend/screens/food_page/widgets/author_section.dart';
import 'package:fontend/screens/food_page/widgets/description_section.dart';
import 'package:fontend/screens/food_page/widgets/header_section.dart';
import 'package:fontend/screens/food_page/widgets/ingredients_section.dart';
import 'package:fontend/screens/food_page/widgets/rating_section.dart';
import 'package:fontend/screens/food_page/widgets/recipe_info_section.dart';
import 'package:fontend/screens/food_page/widgets/steps_section.dart';
import '../Crete_recipe/logic/publish_recipe.dart';
import 'logic/recipe_provider2.dart';

class RecipeDetailPageScreen2 extends ConsumerWidget {
  final PublishRecipe recipe;

  const RecipeDetailPageScreen2({super.key, required this.recipe});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    // Nền toàn trang theo theme
    final scaffoldBackgroundColor = isDark ? Colors.grey[900]! : Colors.white;

    return Scaffold(
      backgroundColor: scaffoldBackgroundColor,
      body: LayoutBuilder(
        builder: (context, constraints) {
          final width = constraints.maxWidth;

          return SingleChildScrollView(
            padding: EdgeInsets.zero, // Đảm bảo không có padding mặc định
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                HeaderSection(recipe: recipe),
                RecipeInfoSection(width: width, recipe: recipe),
                DescriptionSection(width: width, recipe: recipe),
                IngredientsSection(width: width, recipe: recipe),
                StepsSection(width: width, recipe: recipe),
                RatingSection(width: width, recipe: recipe),
                AuthorSection(width: width, authorId: recipe.authorId ?? ''),
                const SizedBox(height: 40),
              ],
            ),
          );
        },
      ),
    );
  }
}