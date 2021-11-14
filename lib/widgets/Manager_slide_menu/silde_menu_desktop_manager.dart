import 'package:advance_employee_management/locator.dart';
import 'package:advance_employee_management/provider/app_provider.dart';
import 'package:advance_employee_management/provider/table_provider.dart';
import 'package:advance_employee_management/rounting/route_names.dart';
import 'package:advance_employee_management/service/navigation_service.dart';
import 'package:advance_employee_management/widgets/navbar/navbar_logo_employee.dart';
import 'package:advance_employee_management/widgets/navbar/navbar_logo_manager.dart';
import 'package:advance_employee_management/widgets/slide_menu/side_menu_items.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SideMenuManagerDesktop extends StatelessWidget {
  const SideMenuManagerDesktop({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final AppProvider appProvider = Provider.of<AppProvider>(context);
    return Container(
      decoration: const BoxDecoration(
          color: Colors.white,
          gradient: LinearGradient(
            colors: [Colors.indigo, Colors.blue],
          ),
          boxShadow: [
            BoxShadow(
                color: Colors.lightBlue, offset: Offset(3, 5), blurRadius: 10)
          ]),
      width: 250,
      child: Column(
        children: [
          const NavBarLogoManager(),
          const SizedBox(
            height: 30,
          ),
          SileMenuItemDesktop(
              active: appProvider.currentPage == DisplayedPage.DASHBOARD,
              text: "Dashboard",
              icon: Icons.dashboard_customize,
              onTap: () {
                appProvider.changeCurrentPage(DisplayedPage.DASHBOARD);
                locator<NavigationService>().navigateTo(MainHomeP);
              }),
          SileMenuItemDesktop(
              active: appProvider.currentPage == DisplayedPage.EMPLOYEES,
              text: "Celendar",
              icon: Icons.calendar_view_week_rounded,
              onTap: () {
                ChangeNotifierProvider.value(value: TableProvider.init());
                appProvider.changeCurrentPage(DisplayedPage.EMPLOYEES);
                locator<NavigationService>().navigateTo(ManagerLayout);
              }),
        ],
      ),
    );
  }
}
