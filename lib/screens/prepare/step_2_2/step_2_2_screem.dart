import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fontend/screens/prepare/step_1/widgets/background.dart';
import 'package:fontend/screens/prepare/step_1/widgets/bottom_panel.dart';
import 'package:fontend/screens/prepare/step_1/widgets/description.dart';
import 'package:fontend/screens/prepare/step_1/widgets/header.dart';
import 'package:fontend/screens/prepare/step_1/widgets/image.dart';

import '../step_0/widgets/step_title.dart';
import 'logic/step2_2_provider.dart';

class StepTimerScreen2 extends ConsumerWidget {
  const StepTimerScreen2({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final step = ref.watch(stepIndexProvider);
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: ClipRRect(
        borderRadius: const BorderRadius.vertical(top: Radius.circular(50)),
        child: StepBackground1(
          child: Stack(
            children: [
              StepHeader1(),
              StepTitle(step: step),
              const StepDescription1(),
              StepImage1(size: size),
              StepBottomPanel1(
                size: size,
              ),
            ],
          ),
        ),
      ),
    );
  }
}