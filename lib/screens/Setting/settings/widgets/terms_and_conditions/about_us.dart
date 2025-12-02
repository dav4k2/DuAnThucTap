import 'package:flutter/material.dart';

class AboutUs extends StatelessWidget {
  const AboutUs({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final horizontalPadding = size.width * 0.05;
    final verticalPadding = size.height * 0.03;
    final titleFontSize = size.width * 0.065;
    final subtitleFontSize = size.width * 0.05;
    final bodyFontSize = size.width * 0.04;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Giới Thiệu',
          style: TextStyle(
            color: Colors.black,
            fontSize: titleFontSize,
            fontWeight: FontWeight.w700,
            fontFamily: 'SF Pro Rounded',
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(
          horizontal: horizontalPadding,
          vertical: verticalPadding,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Về chúng tôi',
              style: TextStyle(
                color: Color(0xFFFFB901),
                fontSize: subtitleFontSize,
                fontFamily: 'SF Pro',
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: size.height * 0.015),
            Text(
              'Chúng tôi là anh em wibu đụt cận trĩ spin hand ra ý tưởng app let him cook lỏ card này',
              style: TextStyle(
                color: Colors.black.withOpacity(0.6),
                fontSize: bodyFontSize,
                fontFamily: 'SF Pro',
                fontWeight: FontWeight.w400,
                height: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
