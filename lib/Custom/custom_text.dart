import 'package:advance_employee_management/provider/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CustomText extends StatelessWidget {
  final String text;
  final double size;
  // final Color color;
  final FontWeight fontWeight;

  const CustomText(
      {Key? key,
      required this.text,
      required this.size,
      // required this.color,
      required this.fontWeight})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    ThemeProvider themeProvider = Provider.of<ThemeProvider>(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Text(
        text,
        style: TextStyle(
          color: themeProvider.isLightMode ? Colors.black : Colors.white,
          fontSize: size,
          fontWeight: fontWeight,
        ),
      ),
    );
  }
}
