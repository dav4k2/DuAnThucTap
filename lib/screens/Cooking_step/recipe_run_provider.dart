import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fontend/screens/Cooking_step/recipe_step_model.dart';

final recipeStepsProvider = StateProvider<List<RecipeStep>>((ref) => []);

final currentStepIndexProvider = StateProvider<int>((ref) => 0);