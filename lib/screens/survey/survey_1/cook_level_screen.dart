import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fontend/screens/survey/survey_1/widgets/cook_header.dart';
import 'package:fontend/screens/survey/survey_1/widgets/cook_next_button.dart';
import 'package:fontend/screens/survey/survey_1/widgets/cook_option_button.dart';
import 'package:fontend/screens/survey/survey_1/widgets/cook_title.dart';


class CookingLevelScreen extends ConsumerWidget {
  const CookingLevelScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    final options = [
      'Mới tập nấu',
      'Nghiệp dư',
      'Đầu bếp tại gia',
      'Đầu bếp chuyên nghiệp',
      'Không chắc chắn',
    ];

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: width * 0.06),
          child: Column(
            children: [
              const CookingHeader(),
              SizedBox(height: height * 0.02),
              const CookingTitle(),
              SizedBox(height: height * 0.04),
              ...options.map((label) => CookingOptionButton(label: label)),
              SizedBox(height: height * 0.08),
              CookingNextButton(
                onNext: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Đã chọn trình độ nấu ăn!')),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
