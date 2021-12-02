import 'package:advance_employee_management/locator.dart';
import 'package:advance_employee_management/pages/authentication/sign_in_page.dart';
import 'package:advance_employee_management/provider/app_provider.dart';
import 'package:advance_employee_management/provider/table_provider.dart';
import 'package:advance_employee_management/rounting/route_names.dart';
import 'package:advance_employee_management/service/navigation_service.dart';
import 'package:advance_employee_management/widgets/navbar/navbar_logo_employee.dart';
import 'package:advance_employee_management/widgets/slide_menu/side_menu_items.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
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
              icon: Icons.book_outlined,
              onTap: () {
                ChangeNotifierProvider.value(value: TableProvider.init());
                appProvider
                    .changeCurrentPage(DisplayedPage.PROJECTEMPLOYEEPAGE);
                locator<NavigationService>().navigateTo(ProjectPageEmployee);
              }),
          SileMenuItemDesktop(
              active: appProvider.currentPage == DisplayedPage.NOTIFICATION,
              text: "Notification",
              icon: Icons.notification_add,
              onTap: () {
                ChangeNotifierProvider.value(value: TableProvider.init());
                appProvider.changeCurrentPage(DisplayedPage.NOTIFICATION);
                locator<NavigationService>()
                    .navigateTo(notificationEmployeeRoute);
              }),
          const SizedBox(
            height: 280,
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
                  dialog(DialogType.QUESTION, "Are you sure", "", context,
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
