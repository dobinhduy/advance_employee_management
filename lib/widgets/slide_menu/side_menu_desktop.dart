import 'package:advance_employee_management/locator.dart';
import 'package:advance_employee_management/pages/add_to_do.dart';
import 'package:advance_employee_management/pages/sign_up_page.dart';
import 'package:advance_employee_management/provider/app_provider.dart';
import 'package:advance_employee_management/rounting/route_names.dart';
import 'package:advance_employee_management/service/navigation_service.dart';
import 'package:advance_employee_management/widgets/navbar/navbar_logo.dart';
import 'package:advance_employee_management/widgets/slide_menu/side_menu_items.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SildeMenuTabletDesktop extends StatelessWidget {
  const SildeMenuTabletDesktop({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final AppProvider appProvider = Provider.of<AppProvider>(context);
    return Container(
      decoration: const BoxDecoration(
          color: Colors.white,
          gradient: LinearGradient(
            colors: [Colors.grey, Colors.black54],
          ),
          boxShadow: [
            BoxShadow(color: Colors.red, offset: Offset(3, 5), blurRadius: 17)
          ]),
      width: 250,
      child: Container(
        child: Column(
          children: [
            const NavBarLogo(),
            SileMenuItemDesktop(
                active: appProvider.currentPage == DisplayedPage.HOME,
                text: "Dashboard",
                icon: Icons.dashboard,
                onTap: () {
                  appProvider.changeCurrentPage(DisplayedPage.HOME);
                  locator<NavigationService>().navigateTo(MainHomeP);
                }),
            SileMenuItemDesktop(
                active: appProvider.currentPage == DisplayedPage.USERS,
                text: "User",
                icon: Icons.people,
                onTap: () {
                  appProvider.changeCurrentPage(DisplayedPage.USERS);
                  locator<NavigationService>().navigateTo(SignupRoute);
                }),
          ],
        ),
      ),
    );
  }
}
