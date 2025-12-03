import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../../theme/theme_provider.dart';


class AboutUs extends ConsumerWidget {
  const AboutUs({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = ref.watch(themeProvider); // Dark mode

    final size = MediaQuery.of(context).size;
    final horizontalPadding = size.width * 0.05;
    final verticalPadding = size.height * 0.03;
    final titleFontSize = size.width * 0.065;
    final subtitleFontSize = size.width * 0.05;
    final bodyFontSize = size.width * 0.04;

    final titleColor = isDark ? Colors.white : Colors.black;
    final subtitleColor = const Color(0xFFFFB901);
    final bodyColor = isDark ? Colors.white70 : Colors.black.withOpacity(0.6);
    final iconColor = isDark ? Colors.white : Colors.black;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: iconColor),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Giới Thiệu',
          style: TextStyle(
            color: titleColor,
            fontSize: titleFontSize,
            fontWeight: FontWeight.w700,
            fontFamily: 'SF Pro Rounded',
          ),
        ),
        centerTitle: true,
        iconTheme: IconThemeData(color: iconColor),
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
                color: subtitleColor,
                fontSize: subtitleFontSize,
                fontFamily: 'SF Pro',
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: size.height * 0.015),
            Text(
              'Chúng tôi là anh em wibu đụt cận trĩ spin hand ra ý tưởng app let him cook lỏ card này',
              style: TextStyle(
                color: bodyColor,
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
