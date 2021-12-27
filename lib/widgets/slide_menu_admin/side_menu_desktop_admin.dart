import 'package:advance_employee_management/authentication/sign_in_page.dart';
import 'package:advance_employee_management/locator.dart';
import 'package:advance_employee_management/provider/app_provider.dart';
import 'package:advance_employee_management/provider/table_provider.dart';
import 'package:advance_employee_management/provider/theme_provider.dart';
import 'package:advance_employee_management/rounting/route_names.dart';
import 'package:advance_employee_management/service/navigation_service.dart';
import 'package:advance_employee_management/widgets/change_button/change_theme_button.dart';
import 'package:advance_employee_management/widgets/navbar/navbar_logo_admin.dart';
import 'package:advance_employee_management/widgets/slide_menu_admin/side_menu_items.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SildeMenuAdminDesktop extends StatelessWidget {
  const SildeMenuAdminDesktop({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ThemeProvider themeProvider = Provider.of<ThemeProvider>(context);
    final AppProvider appProvider = Provider.of<AppProvider>(context);
    return Container(
      decoration: BoxDecoration(
        color:
            themeProvider.isLightMode ? const Color(0XFFEFEBE9) : Colors.black,
      ),
      width: 220,
      child: Column(
        children: [
          const SizedBox(
            height: 30,
          ),
          const NavBarLogoAdmin(),
          SileMenuItemDesktop(
              active: appProvider.currentPage == DisplayedPage.EMPLOYEES,
              text: "Employee Table",
              icon: Icons.people_alt_outlined,
              onTap: () {
                ChangeNotifierProvider.value(value: TableProvider.init());
                appProvider.changeCurrentPage(DisplayedPage.EMPLOYEES);
                locator<NavigationService>().navigateTo(EmployeeLayout);
              }),
          SileMenuItemDesktop(
              active: appProvider.currentPage == DisplayedPage.DEPARTMENT,
              text: "Department Table",
              icon: Icons.home_filled,
              onTap: () {
                appProvider.changeCurrentPage(DisplayedPage.DEPARTMENT);
                locator<NavigationService>().navigateTo(DepartmentLayout);
              }),
          const ChangeThemeButton(),
          const SizedBox(
            height: 280,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: SileMenuItemDesktop(
                active: appProvider.currentPage == DisplayedPage.LOGOUT,
                text: "Log out",
                icon: Icons.logout,
                onTap: () {
                  dialog(DialogType.QUESTION, "Are you sure ?", "", context,
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
        provider.changeCurrentPage(DisplayedPage.HOME);
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (builder) => const SignInPage()),
            (route) => false);
      },
    )..show();
  }
}
