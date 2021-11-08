import 'package:advance_employee_management/widgets/custom_text.dart';
import 'package:flutter/material.dart';

class PageHeader extends StatelessWidget {
  final String text;
  const PageHeader({Key? key, required this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const SizedBox(
          height: 15,
        ),
        Padding(
          padding: const EdgeInsets.all(14),
          child: CustomText(
              text: text,
              size: 40,
              color: Colors.deepOrangeAccent,
              fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}
