import 'package:advance_employee_management/authentication/sign_in_page.dart';
import 'package:advance_employee_management/locator.dart';
import 'package:advance_employee_management/provider/app_provider.dart';
import 'package:advance_employee_management/provider/table_provider.dart';
import 'package:advance_employee_management/rounting/route_names.dart';
import 'package:advance_employee_management/service/navigation_service.dart';
import 'package:advance_employee_management/widgets/navbar/navbar_logo_admin.dart';
import 'package:advance_employee_management/widgets/slide_menu/side_menu_items.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SildeMenuAdminDesktop extends StatelessWidget {
  const SildeMenuAdminDesktop({Key? key}) : super(key: key);

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
          const SizedBox(
            height: 30,
          ),
          const NavBarLogoAdmin(),
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
              text: "Employee",
              icon: Icons.people_alt_outlined,
              onTap: () {
                ChangeNotifierProvider.value(value: TableProvider.init());
                appProvider.changeCurrentPage(DisplayedPage.EMPLOYEES);
                locator<NavigationService>().navigateTo(EmployeeLayout);
              }),
          SileMenuItemDesktop(
              active: appProvider.currentPage == DisplayedPage.DEPARTMENT,
              text: "Department",
              icon: Icons.home_filled,
              onTap: () {
                appProvider.changeCurrentPage(DisplayedPage.DEPARTMENT);
                locator<NavigationService>().navigateTo(DepartmentLayout);
              }),
          SileMenuItemDesktop(
              active: appProvider.currentPage == DisplayedPage.ADD,
              text: "Add",
              icon: Icons.add_box_outlined,
              onTap: () {
                appProvider.changeCurrentPage(DisplayedPage.ADD);

                locator<NavigationService>().navigateTo(AddUserLayout);
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
                  dialog(DialogType.QUESTION, "Are you sure?", "", context,
                      appProvider);
                }),
          ),
        ],
      ),
    );
  }

  AwesomeDialog dialog(DialogType type, String title, String description,
      BuildContext context, AppProvider provider) {
    return AwesomeDialog(
      context: context,
      width: 600,
      dialogType: type,
      animType: AnimType.LEFTSLIDE,
      title: title,
      desc: description,
      btnCancelOnPress: () {},
      btnOkOnPress: () {
        provider.changeCurrentPage(DisplayedPage.LOGOUT);
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (builder) => const SignInPage()),
            (route) => false);
      },
    )..show();
  }
}
