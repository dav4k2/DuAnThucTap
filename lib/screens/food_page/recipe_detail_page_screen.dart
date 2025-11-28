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
import 'logic/recipe_provider.dart';

class RecipeDetailPage extends ConsumerWidget {
  const RecipeDetailPage({super.key});

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
                  HeaderSection(),
                  RecipeInfoSection(width: width),
                  DescriptionSection(width: width),
                  IngredientsSection(width: width),
                  StepsSection(width: width),
                  RatingSection(width: width),
                  AuthorSection(width: width),
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
