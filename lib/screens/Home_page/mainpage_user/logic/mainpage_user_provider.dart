import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fontend/screens/food_page/recipe_detail_page_screen.dart'; // Màn hình của MÌNH
import 'package:fontend/screens/food_page2/recipe_detail_page_screen2.dart'; // Màn hình của NGƯỜI KHÁC
import '../../../Crete_recipe/logic/publish_recipe.dart';

final selectedIndexProvider = StateProvider<int>((ref) => 0);


void navigateBasedOnAuthor(BuildContext context, PublishRecipe recipe) {
  final currentUser = FirebaseAuth.instance.currentUser;

  bool isOwner = currentUser != null && recipe.authorId == currentUser.uid;

  if (isOwner) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => RecipeDetailPage(recipe: recipe)),
    );
  } else {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => RecipeDetailPageScreen2(recipe: recipe)),
    );
  }
}
