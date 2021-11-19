import 'package:advance_employee_management/locator.dart';
import 'package:advance_employee_management/provider/app_provider.dart';
import 'package:advance_employee_management/provider/table_provider.dart';
import 'package:advance_employee_management/rounting/route_names.dart';
import 'package:advance_employee_management/service/navigation_service.dart';
import 'package:advance_employee_management/widgets/navbar/navbar_logo_employee.dart';
import 'package:advance_employee_management/widgets/slide_menu/side_menu_items.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SideMenuEmployeeDesktop extends StatelessWidget {
  const SideMenuEmployeeDesktop({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final AppProvider appProvider = Provider.of<AppProvider>(context);
    return Container(
      decoration: const BoxDecoration(
          color: Colors.white,
          gradient: LinearGradient(
            colors: [Colors.deepPurple, Colors.deepPurpleAccent],
          ),
          boxShadow: [
            BoxShadow(
                color: Colors.lightBlue, offset: Offset(3, 5), blurRadius: 10)
          ]),
      width: 220,
      child: Column(
        children: [
          const NavBarLogoEmployee(),
          const SizedBox(
            height: 30,
          ),
          SileMenuItemDesktop(
              active: appProvider.currentPage == DisplayedPage.DASHBOARD,
              text: "Dashboard",
              icon: Icons.home,
              onTap: () {
                ChangeNotifierProvider.value(value: TableProvider.init());
                appProvider.changeCurrentPage(DisplayedPage.DASHBOARD);
                locator<NavigationService>().navigateTo(MainHomeP);
              }),
          SileMenuItemDesktop(
              active:
                  appProvider.currentPage == DisplayedPage.EMPLOYEEINFORMATION,
              text: "Profile",
              icon: Icons.people_alt,
              onTap: () {
                appProvider
                    .changeCurrentPage(DisplayedPage.EMPLOYEEINFORMATION);
                locator<NavigationService>()
                    .navigateTo(EmployeeInformationRoute);
              }),
          SileMenuItemDesktop(
              active:
                  appProvider.currentPage == DisplayedPage.PROJECTEMPLOYEEPAGE,
              text: "Project",
              icon: Icons.panorama_photosphere,
              onTap: () {
                ChangeNotifierProvider.value(value: TableProvider.init());
                appProvider
                    .changeCurrentPage(DisplayedPage.PROJECTEMPLOYEEPAGE);
                locator<NavigationService>().navigateTo(ProjectPageEmployee);
              }),
          SileMenuItemDesktop(
              active: appProvider.currentPage == DisplayedPage.NOTIFICATION,
              text: "Notification",
              icon: Icons.panorama_photosphere,
              onTap: () {
                ChangeNotifierProvider.value(value: TableProvider.init());
                appProvider.changeCurrentPage(DisplayedPage.NOTIFICATION);
                locator<NavigationService>().navigateTo(ProjectPageEmployee);
              }),
          SizedBox(
            height: 330,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 4,
            ),
            child: SileMenuItemDesktop(
                active: appProvider.currentPage == DisplayedPage.LOGOUT,
                text: "Log out",
                icon: Icons.logout,
                onTap: () {
                  appProvider.changeCurrentPage(DisplayedPage.LOGOUT);
                  locator<NavigationService>()
                      .globalNavigateTo(LonginRoute, context);
                }),
          ),
        ],
      ),
    );
  }
}
