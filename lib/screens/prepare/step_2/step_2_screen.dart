import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fontend/screens/prepare/step_2/widgets/step2_bottom.dart';
import 'package:fontend/screens/prepare/step_2/widgets/step2_description.dart';
import 'package:fontend/screens/prepare/step_2/widgets/step2_header.dart';
import 'package:fontend/screens/prepare/step_2/widgets/step2_image.dart';
import 'package:fontend/screens/prepare/step_2/widgets/step2_title.dart';

import 'logic/step2_provider.dart';

class StepScreen2 extends ConsumerWidget {
  const StepScreen2({super.key});

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
              StepHeader2(),

              StepTitle2(step: step),

              StepDescription2(),

              StepImage2(width: width),

              StepBottomCard2(
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