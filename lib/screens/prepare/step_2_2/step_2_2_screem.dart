import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fontend/screens/prepare/step_2_2/widgets/background2.dart';
import 'package:fontend/screens/prepare/step_2_2/widgets/bottom_panel2.dart';
import 'package:fontend/screens/prepare/step_2_2/widgets/description2.dart';
import 'package:fontend/screens/prepare/step_2_2/widgets/header2.dart';
import 'package:fontend/screens/prepare/step_2_2/widgets/image2.dart';

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
        child: StepBackground2(
          child: Stack(
            children: [
              StepHeader2(),
              StepTitle(step: step),
              const StepDescription2(),
              StepImage2(size: size),
              StepBottomPanel2(
                size: size,
              ),
            ],
          ),
        ),
      ),
    );
  }
}