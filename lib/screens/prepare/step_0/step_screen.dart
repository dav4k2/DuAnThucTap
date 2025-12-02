import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fontend/screens/prepare/step_0/widgets/step_bottom.dart';
import 'package:fontend/screens/prepare/step_0/widgets/step_description.dart';
import 'package:fontend/screens/prepare/step_0/widgets/step_header.dart';
import 'package:fontend/screens/prepare/step_0/widgets/step_image.dart';
import 'package:fontend/screens/prepare/step_0/widgets/step_title.dart';

import 'logic/step_provider.dart';

class StepScreen extends ConsumerWidget {
  const StepScreen({super.key});

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
              StepHeader(width: width),

              StepTitle(step: step),

              StepDescription(),

              StepImage(width: width),

              StepBottomCard(
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