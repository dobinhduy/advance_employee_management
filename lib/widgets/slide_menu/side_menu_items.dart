import 'package:advance_employee_management/widgets/custom_text.dart';
import 'package:flutter/material.dart';

class SileMenuItemDesktop extends StatelessWidget {
  final bool active;
  final String text;
  final IconData icon;
  final VoidCallback onTap;

  const SileMenuItemDesktop(
      {Key? key,
      required this.active,
      required this.text,
      required this.icon,
      required this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      tileColor: active ? Colors.green.withOpacity(0.3) : null,
      title: CustomText(
          text: text,
          size: active ? 19 : 16,
          color: active ? Colors.red : Colors.black,
          fontWeight: FontWeight.bold),
      leading: Icon(
        icon,
        color: Colors.white,
      ),
    );
  }
}
