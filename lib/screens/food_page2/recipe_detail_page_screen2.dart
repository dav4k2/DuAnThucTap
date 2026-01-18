import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fontend/screens/food_page/widgets/author_section.dart';
import 'package:fontend/screens/food_page/widgets/description_section.dart';
import 'package:fontend/screens/food_page/widgets/header_section.dart';
import 'package:fontend/screens/food_page/widgets/ingredients_section.dart';
import 'package:fontend/screens/food_page/widgets/rating_section.dart';
import 'package:fontend/screens/food_page/widgets/recipe_info_section.dart';
import 'package:fontend/screens/food_page/widgets/steps_section.dart';
import 'package:fontend/screens/food_page2/widgets/author_section2.dart';
import 'package:fontend/screens/food_page2/widgets/description_section2.dart';
import 'package:fontend/screens/food_page2/widgets/header_section2.dart';
import 'package:fontend/screens/food_page2/widgets/ingredients_section2.dart';
import 'package:fontend/screens/food_page2/widgets/rating_section2.dart';
import 'package:fontend/screens/food_page2/widgets/recipe_info_section2.dart';
import 'package:fontend/screens/food_page2/widgets/steps_section2.dart';
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
                HeaderSection2(recipe: recipe),
                RecipeInfoSection2(width: width, recipe: recipe),
                DescriptionSection2(width: width, recipe: recipe),
                IngredientsSection2(width: width, recipe: recipe),
                StepsSection2(width: width, recipe: recipe),
                RatingSection2(width: width, recipe: recipe),
                AuthorSection2(width: width, authorId: recipe.authorId ?? ''),
                const SizedBox(height: 40),
              ],
            ),
          );
        },
      ),
    );
  }
}