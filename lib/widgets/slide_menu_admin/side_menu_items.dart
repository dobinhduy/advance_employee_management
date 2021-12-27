import 'package:advance_employee_management/Custom/custom_text.dart';
import 'package:advance_employee_management/provider/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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
    ThemeProvider themeProvider = Provider.of<ThemeProvider>(context);
    return Column(
      children: [
        ListView(shrinkWrap: true, children: <Widget>[
          Container(
            decoration: BoxDecoration(
              color: themeProvider.isLightMode
                  ? active
                      ? Colors.white
                      : Colors.brown[50]
                  : !active
                      ? Colors.black
                      : Colors.brown,
              shape: BoxShape.rectangle,
              borderRadius: const BorderRadius.only(
                topRight: Radius.circular(25.0),
                bottomRight: Radius.circular(25),
              ),
            ),
            child: ListTile(
              hoverColor: Colors.blue,
              onTap: onTap,
              tileColor: active ? Colors.white : Colors.white,
              title: CustomText(
                  text: text,
                  size: active ? 17 : 16,
                  fontWeight: FontWeight.normal),
              leading: Icon(
                icon,
                color: themeProvider.isLightMode
                    ? Colors.black
                    : const Color(0XFFEFEBE9),
              ),
            ),
          )
        ]),
      ],
    );
  }
}
