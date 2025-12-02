import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fontend/screens/prepare/prepare_page/widgets/bottom_section.dart';
import 'package:fontend/screens/prepare/prepare_page/widgets/header_widget.dart';
import 'package:fontend/screens/prepare/prepare_page/widgets/ingredients_list.dart';
import 'package:fontend/screens/prepare/prepare_page/widgets/title_widget.dart';

class PreparePage extends ConsumerWidget {
  const PreparePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        width: size.width,
        height: size.height,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(50),
        ),
        child: Stack(
          children: const [
            HeaderWidget(),
            TitleWidget(),
            IngredientsList(),
            BottomSection(),
          ],
        ),
      ),
    );
  }
}
