import 'package:advance_employee_management/authentication/sign_in_page.dart';
import 'package:advance_employee_management/locator.dart';
import 'package:advance_employee_management/provider/app_provider.dart';
import 'package:advance_employee_management/provider/table_provider.dart';
import 'package:advance_employee_management/provider/theme_provider.dart';
import 'package:advance_employee_management/rounting/route_names.dart';
import 'package:advance_employee_management/service/auth_services.dart';
import 'package:advance_employee_management/service/employee_service.dart';
import 'package:advance_employee_management/service/navigation_service.dart';
import 'package:advance_employee_management/service/notification_service.dart';
import 'package:advance_employee_management/widgets/change_button/change_theme_button.dart';
import 'package:advance_employee_management/widgets/navbar/navbar_logo_employee.dart';
import 'package:advance_employee_management/widgets/slide_menu_admin/side_menu_items.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SideMenuEmployeeDesktop extends StatefulWidget {
  const SideMenuEmployeeDesktop({Key? key}) : super(key: key);

  @override
  State<SideMenuEmployeeDesktop> createState() =>
      _SideMenuEmployeeDesktopState();
}

class _SideMenuEmployeeDesktopState extends State<SideMenuEmployeeDesktop> {
  NotificationService notificationService = NotificationService();

  EmployeeServices employeeServices = EmployeeServices();
  String useremail = AuthClass().user()!;

  String userID = "";
  bool timeout = false;
  bool isClick = false;
  int value1 = 0;
  @override
  void initState() {
    super.initState();
    getUserID();
    getNumberNotify();
  }

  getNumberNotify() async {
    value1 = await notificationService.getNumNotification(userID);
    if (mounted) {
      setState(() {});
    }
  }

  getUserID() async {
    userID = await employeeServices.getEmployeeIDbyEmail(useremail);
    if (mounted) {
      setState(() {});
    }
  }

  void deplay() {
    Future.delayed(const Duration(seconds: 1), () {
      if (mounted) {
        setState(() {
          timeout = true;
        });
      }
    });
  }

  void click() {
    if (mounted) {
      setState(() {
        isClick = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    getUserID();
    getNumberNotify();
    deplay();
    final AppProvider appProvider = Provider.of<AppProvider>(context);
    ThemeProvider themeProvider = Provider.of<ThemeProvider>(context);
    return timeout == true
        ? Container(
            decoration: BoxDecoration(
              color: themeProvider.isLightMode
                  ? const Color(0XFFEFEBE9)
                  : Colors.black,
            ),
            width: 220,
            child: Column(
              children: [
                const NavBarLogoEmployee(),
                const SizedBox(
                  height: 30,
                ),
                SileMenuItemDesktop(
                    active: appProvider.currentPage ==
                        DisplayedPage.EMPLOYEEINFORMATION,
                    text: "Profile",
                    icon: Icons.people_alt,
                    onTap: () {
                      appProvider
                          .changeCurrentPage(DisplayedPage.EMPLOYEEINFORMATION);
                      locator<NavigationService>()
                          .navigateTo(EmployeeInformationRoute);
                    }),
                SileMenuItemDesktop(
                    active: appProvider.currentPage ==
                        DisplayedPage.PROJECTEMPLOYEEPAGE,
                    text: "Project",
                    icon: Icons.book_outlined,
                    onTap: () {
                      ChangeNotifierProvider.value(value: TableProvider.init());
                      appProvider
                          .changeCurrentPage(DisplayedPage.PROJECTEMPLOYEEPAGE);
                      locator<NavigationService>()
                          .navigateTo(ProjectPageEmployee);
                    }),
                isClick == false
                    ? SileMenuItemDesktop(
                        active: appProvider.currentPage ==
                            DisplayedPage.NOTIFICATION,
                        text: "Notification (" + value1.toString() + ")",
                        icon: Icons.notification_add,
                        onTap: () {
                          setState(() {
                            click();
                          });
                          appProvider
                              .changeCurrentPage(DisplayedPage.NOTIFICATION);
                          locator<NavigationService>()
                              .navigateTo(notificationEmployeeRoute);
                        })
                    : SileMenuItemDesktop(
                        active: appProvider.currentPage ==
                            DisplayedPage.NOTIFICATION,
                        text: "Notification",
                        icon: Icons.notification_add,
                        onTap: () {
                          appProvider
                              .changeCurrentPage(DisplayedPage.NOTIFICATION);
                          locator<NavigationService>()
                              .navigateTo(notificationEmployeeRoute);
                        }),
                SileMenuItemDesktop(
                    active: false,
                    text: "Change Password",
                    icon: Icons.change_circle,
                    onTap: () {
                      locator<NavigationService>()
                          .globalNavigateTo(changePasswordRoute, context);
                    }),
                const ChangeThemeButton(),
                const SizedBox(
                  height: 200,
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
                        dialog(DialogType.QUESTION, "Are you sure ?", "",
                            context, appProvider);
                      }),
                ),
              ],
            ),
          )
        : Container();
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
