import 'package:advance_employee_management/authentication/sign_in_page.dart';
import 'package:advance_employee_management/locator.dart';
import 'package:advance_employee_management/provider/app_provider.dart';
import 'package:advance_employee_management/provider/table_provider.dart';
import 'package:advance_employee_management/rounting/route_names.dart';
import 'package:advance_employee_management/service/auth_services.dart';
import 'package:advance_employee_management/service/employee_service.dart';
import 'package:advance_employee_management/service/navigation_service.dart';
import 'package:advance_employee_management/service/notification_service.dart';
import 'package:advance_employee_management/widgets/navbar/navber_logo_manager.dart';
import 'package:advance_employee_management/widgets/slide_menu_admin/side_menu_items.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SideMenuManagerDesktop extends StatefulWidget {
  const SideMenuManagerDesktop({Key? key}) : super(key: key);

  @override
  State<SideMenuManagerDesktop> createState() => _SideMenuManagerDesktopState();
}

class _SideMenuManagerDesktopState extends State<SideMenuManagerDesktop> {
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
    return timeout == true
        ? Container(
            decoration: const BoxDecoration(
                color: Colors.white,
                gradient: LinearGradient(
                  colors: [Colors.deepPurple, Colors.deepPurpleAccent],
                ),
                boxShadow: [
                  BoxShadow(
                      color: Colors.lightBlue,
                      offset: Offset(3, 5),
                      blurRadius: 10)
                ]),
            width: 220,
            child: Column(
              children: [
                const NavBarLogoManager(),
                const SizedBox(
                  height: 30,
                ),
                SileMenuItemDesktop(
                    active: appProvider.currentPage ==
                        DisplayedPage.MANAGERINFORMATION,
                    text: "Profile",
                    icon: Icons.person,
                    onTap: () {
                      appProvider
                          .changeCurrentPage(DisplayedPage.MANAGERINFORMATION);
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
                    active:
                        appProvider.currentPage == DisplayedPage.MANAGERPROJECT,
                    text: "Project Table",
                    icon: Icons.task_sharp,
                    onTap: () {
                      ChangeNotifierProvider.value(value: TableProvider.init());
                      appProvider
                          .changeCurrentPage(DisplayedPage.MANAGERPROJECT);
                      locator<NavigationService>().navigateTo(ProjectPageRoute);
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
                          if (mounted) {
                            setState(() {
                              click();
                            });
                          }
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
                const SizedBox(
                  height: 200,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
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
