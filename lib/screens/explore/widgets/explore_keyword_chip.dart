import 'package:flutter/material.dart';

class ExploreKeywordChip extends StatelessWidget {
  final String text;
  const ExploreKeywordChip(this.text, {super.key});

  @override
  Widget build(BuildContext context) {
    return Chip(
      label: Text(text),
      backgroundColor: Colors.grey[200],
    );
  }
}
