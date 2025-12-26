import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fontend/screens/food_page/widgets/author_section.dart';
import 'package:fontend/screens/food_page/widgets/comments_section.dart';
import 'package:fontend/screens/food_page/widgets/description_section.dart';
import 'package:fontend/screens/food_page/widgets/header_section.dart';
import 'package:fontend/screens/food_page/widgets/ingredients_section.dart';
import 'package:fontend/screens/food_page/widgets/rating_section.dart';
import 'package:fontend/screens/food_page/widgets/recipe_info_section.dart';
import 'package:fontend/screens/food_page/widgets/steps_section.dart';
import '../Crete_recipe/logic/publish_recipe.dart';
import 'logic/recipe_provider.dart';

class RecipeDetailPage extends ConsumerWidget {
  final PublishRecipe recipe;
  const RecipeDetailPage({super.key, required this.recipe});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final size = MediaQuery.of(context).size;
    final recipeId = ref.watch(recipeDetailProvider);

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final width = constraints.maxWidth;

            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  HeaderSection(recipe: recipe),
                  RecipeInfoSection(width: width, recipe: recipe),
                  DescriptionSection(width: width, recipe: recipe),
                  IngredientsSection(width: width, recipe: recipe),
                  StepsSection(width: width, recipe: recipe),
                  RatingSection(width: width),
                  AuthorSection(width: width, authorId: recipe.authorId ?? ''),
                  CommentsSection(width: width),
                  const SizedBox(height: 40),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
