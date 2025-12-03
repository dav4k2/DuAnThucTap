import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fontend/screens/prepare/step_3_3/widgets/background3.dart';
import 'package:fontend/screens/prepare/step_3_3/widgets/bottom_panel3.dart';
import 'package:fontend/screens/prepare/step_3_3/widgets/description3.dart';
import 'package:fontend/screens/prepare/step_3_3/widgets/header3.dart';
import 'package:fontend/screens/prepare/step_3_3/widgets/image3.dart';

import '../step_0/widgets/step_title.dart';
import 'logic/step3_3_provider.dart';

class StepTimerScreen3 extends ConsumerWidget {
  const StepTimerScreen3({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final step = ref.watch(stepIndexProvider);
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: ClipRRect(
        borderRadius: const BorderRadius.vertical(top: Radius.circular(50)),
        child: StepBackground3(
          child: Stack(
            children: [
              StepHeader3(),
              StepTitle(step: step),
              const StepDescription3(),
              StepImage3(size: size),
              StepBottomPanel3(
                size: size,
              ),
            ],
          ),
        ),
      ),
    );
  }
}