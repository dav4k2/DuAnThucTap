import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'logic/interest_provider.dart';
import 'widgets/progress_header.dart';
import 'widgets/title_section.dart';
import 'widgets/category_grid.dart';
import 'widgets/bottom_button.dart';

class InterestScreen extends ConsumerWidget {
  const InterestScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selected = ref.watch(selectedCategoriesProvider);
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Stack(
          children: [
            // Nội dung chính
            Container(
              width: size.width,
              height: size.height,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    const SizedBox(height: 10),
                    const ProgressHeader(),
                    const TitleSection(),
                    const CategoryGrid(),
                    BottomButton(
                      onPressed: () {
                        debugPrint('Đã chọn: $selected');
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
