import 'package:advance_employee_management/Custom/custom_text.dart';
import 'package:advance_employee_management/provider/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PageHeader extends StatelessWidget {
  final String text;
  const PageHeader({Key? key, required this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ThemeProvider themeProvider = Provider.of<ThemeProvider>(context);
    return Row(
      children: [
        const SizedBox(
          height: 15,
        ),
        Container(
          width: MediaQuery.of(context).size.width - 220,
          color: themeProvider.isLightMode ? Colors.white : Colors.black,
          child: CustomText(
              text: text,
              size: 35,
              // color: Colors.deepOrangeAccent,
              fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}
