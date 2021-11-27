import 'package:advance_employee_management/locator.dart';
import 'package:advance_employee_management/models/manager.dart';
import 'package:advance_employee_management/pages/authentication/sign_in_page.dart';
import 'package:advance_employee_management/provider/app_provider.dart';
import 'package:advance_employee_management/provider/table_provider.dart';
import 'package:advance_employee_management/rounting/route_names.dart';
import 'package:advance_employee_management/service/auth_services.dart';
import 'package:advance_employee_management/service/manager_service.dart';
import 'package:advance_employee_management/service/navigation_service.dart';
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
            colors: [Colors.deepPurple, Colors.deepPurpleAccent],
          ),
          boxShadow: [
            BoxShadow(
                color: Colors.lightBlue, offset: Offset(3, 5), blurRadius: 10)
          ]),
      width: 220,
      child: Column(
        children: [
          const NavBarLogoManager(),
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
                  appProvider.currentPage == DisplayedPage.MANAGERINFORMATION,
              text: "Profile",
              icon: Icons.person,
              onTap: () {
                appProvider.changeCurrentPage(DisplayedPage.MANAGERINFORMATION);
                locator<NavigationService>()
                    .navigateTo(ManagerInformationRoute);
              }),
          SileMenuItemDesktop(
              active: appProvider.currentPage == DisplayedPage.EMPLOYEES,
              text: "Employee Table",
              icon: Icons.people_alt,
              onTap: () {
                ChangeNotifierProvider.value(value: TableProvider.init());
                appProvider.changeCurrentPage(DisplayedPage.EMPLOYEES);
                locator<NavigationService>()
                    .navigateTo(EmployeeOfManagerPageRoute);
              }),
          SileMenuItemDesktop(
              active: appProvider.currentPage == DisplayedPage.MANAGERPROJECT,
              text: "Project",
              icon: Icons.task_sharp,
              onTap: () {
                ChangeNotifierProvider.value(value: TableProvider.init());
                appProvider.changeCurrentPage(DisplayedPage.MANAGERPROJECT);
                locator<NavigationService>().navigateTo(ProjectPageRoute);
              }),
          const SizedBox(
            height: 270,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: SileMenuItemDesktop(
                active: appProvider.currentPage == DisplayedPage.LOGOUT,
                text: "Log out",
                icon: Icons.logout,
                onTap: () {
                  appProvider.changeCurrentPage(DisplayedPage.LOGOUT);
                  Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                          builder: (builder) => const SignInPage()),
                      (route) => false);
                }),
          ),
        ],
      ),
    );
  }
}
