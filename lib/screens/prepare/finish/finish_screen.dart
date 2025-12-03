import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'logic/finish_provider.dart';
import 'widgets/fr_status_bar.dart';
import 'widgets/fr_title.dart';
import 'widgets/fr_subtitle.dart';
import 'widgets/fr_image_preview.dart';
import 'widgets/fr_primary_button.dart';
import 'widgets/fr_secondary_button.dart';

class FinishRecipeScreen extends ConsumerWidget {
  const FinishRecipeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    final rated = ref.watch(finishRecipeProvider);

    return Scaffold(
      body: Center(
        child: Container(
          width: width,
          height: height,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(50),
          ),
          child: Stack(
            children: [
              const FRStatusBar(),
              const FRTitle(),
              const FRSubtitle(),

              // 🔥 ĐÃ SỬA: Không dùng URL, dùng ảnh local trong thư mục image/
              const FRImagePreview(assetPath: "image/ongdaubep.png"),

              FRPrimaryButton(
                onTap: () => ref.read(finishRecipeProvider.notifier).state = true,
              ),
              FRSecondaryButton(
                onTap: () => debugPrint("Để sau"),
              ),
              //const FRBottomBar(),
            ],
          ),
        ),
      ),
    );
  }
}
