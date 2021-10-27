import 'package:advance_employee_management/widgets/slide_menu/side_menu_desktop.dart';
import 'package:advance_employee_management/widgets/slide_menu/side_menu_mobile.dart';
import 'package:flutter/material.dart';
import 'package:responsive_builder/responsive_builder.dart';

class SideMenu extends StatelessWidget {
  const SideMenu({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ScreenTypeLayout(
      breakpoints:
          const ScreenBreakpoints(desktop: 1460, tablet: 600, watch: 300),
      mobile: const SideMenuMoblie(),
      desktop: const SildeMenuTabletDesktop(),
    );
  }
}
