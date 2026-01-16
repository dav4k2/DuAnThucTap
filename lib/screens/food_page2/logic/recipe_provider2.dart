import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../Crete_recipe/logic/publish_recipe.dart';
import '../../Crete_recipe/logic/publish_service.dart';
import '../../survey/logic/survey_provider.dart';

final recipeDetailProvider = StateProvider<String>((ref) {
  return "pho-tai"; // id công thức
});

final featuredRecipesProvider = StreamProvider<List<PublishRecipe>>((ref) {
  final service = PublishService();
  final favoriteTags = ref.watch(surveyProvider).favoriteCategories;

  return service.getRecipesByTags(favoriteTags).handleError((error) {});
});