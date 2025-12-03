import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fontend/screens/prepare/step_3/widgets/step3_bottom.dart';
import 'package:fontend/screens/prepare/step_3/widgets/step3_description.dart';
import 'package:fontend/screens/prepare/step_3/widgets/step3_header.dart';
import 'package:fontend/screens/prepare/step_3/widgets/step3_image.dart';
import 'package:fontend/screens/prepare/step_3/widgets/step3_title.dart';
import 'logic/step3_provider.dart';

class StepScreen3 extends ConsumerWidget {
  const StepScreen3({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final step = ref.watch(stepProvider); // lấy step từ Riverpod
    final size = MediaQuery.of(context).size; // responsive
    final width = size.width;
    final height = size.height;

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: ClipRRect(
        borderRadius: BorderRadius.circular(50),
        child: Container(
          width: width,
          height: height,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(50),
          ),
          child: Stack(
            children: [
              StepHeader3(width: width),

              StepTitle3(step: step),

              StepDescription3(),

              StepImage3(width: width),

              StepBottomCard3(
                width: width,
                height: height,
              ),
            ],
          ),
        ),
      ),
    );
  }
}