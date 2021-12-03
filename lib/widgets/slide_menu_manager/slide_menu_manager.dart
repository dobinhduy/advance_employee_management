import 'package:advance_employee_management/widgets/slide_menu_admin/side_menu_mobile.dart';
import 'package:advance_employee_management/widgets/slide_menu_manager/slide_menu_desktop_manager.dart';
import 'package:flutter/material.dart';
import 'package:responsive_builder/responsive_builder.dart';

class SideMenuManager extends StatelessWidget {
  const SideMenuManager({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ScreenTypeLayout(
      breakpoints:
          const ScreenBreakpoints(desktop: 1400, tablet: 600, watch: 300),
      mobile: const SideMenuMoblie(),
      desktop: const SideMenuManagerDesktop(),
    );
  }
}
