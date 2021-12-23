import 'package:advance_employee_management/provider/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ChangeThemeButton extends StatelessWidget {
  const ChangeThemeButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return Row(
      children: [
        const SizedBox(
          width: 10,
        ),
        Switch.adaptive(
            value: themeProvider.isLightMode,
            onChanged: (value) {
              final provider =
                  Provider.of<ThemeProvider>(context, listen: false);
              provider.toggleTheme(value);
            }),
        const Text(
          "Light Theme",
          style: TextStyle(fontSize: 18),
        )
      ],
    );
  }
}
