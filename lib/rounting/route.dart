import 'package:advance_employee_management/Employee__Pages/change_password.dart';
import 'package:advance_employee_management/Employee__Pages/employee_infor.dart';
import 'package:advance_employee_management/Employee__Pages/notify_page.dart';
import 'package:advance_employee_management/Employee__Pages/project_page_employee.dart';
import 'package:advance_employee_management/Manager_Pages/employee_page_manager.dart';
import 'package:advance_employee_management/Manager_Pages/project_page.dart';
import 'package:advance_employee_management/admin_pages/add_user_page.dart';
import 'package:advance_employee_management/admin_pages/department_page.dart';
import 'package:advance_employee_management/admin_pages/employee_page.dart';
import 'package:advance_employee_management/admin_pages/home_page.dart';
import 'package:advance_employee_management/authentication/recover_pass_page.dart';
import 'package:advance_employee_management/authentication/sign_in_page.dart';
import 'package:advance_employee_management/rounting/route_names.dart';
import 'package:advance_employee_management/widgets/layout/admin_layout.dart';
import 'package:advance_employee_management/widgets/layout/employee_layout.dart';
import 'package:advance_employee_management/widgets/layout/manager_layout.dart';
import 'package:flutter/material.dart';

PageRoute generateRoute(RouteSettings settings) {
  print("generateRoute: ${settings.name}");
  switch (settings.name) {
    case LonginRoute:
      return _getPageRoute(const SignInPage());
    case MainHomeP:
      return _getPageRoute(const HomePage());
    case RecoverPassRoute:
      return _getPageRoute(const RecoverPassword());
    case AdLayOutRoute:
      return _getPageRoute(AdminLayoutRoute());
    case EmployeeLayout:
      return _getPageRoute(const EmployeePage());
    case AddUserLayout:
      return _getPageRoute(const AddUserPage());
    case EmployeeRouteLayout:
      return _getPageRoute(EmployeeLayoutRoute());
    case changePasswordRoute:
      return _getPageRoute(const ChangePasswordPage());
    case EmployeeInformationRoute:
      return _getPageRoute(const EmployeeInformation());
    case ManagerInformationRoute:
      return _getPageRoute(const EmployeeInformation());
    case ManagerRouteLayout:
      return _getPageRoute(ManagerLayoutRoute());
    case ProjectPageRoute:
      return _getPageRoute(const ProjectPage());
    case ProjectPageEmployee:
      return _getPageRoute(const ProjectEmployeePage());
    case DepartmentLayout:
      return _getPageRoute(const DepartmentPage());
    case notificationEmployeeRoute:
      return _getPageRoute(const NotificationPage());
    case EmployeeOfManagerPageRoute:
      return _getPageRoute(const EmployeeOfManagerPage());

    default:
      return _getPageRoute(const SignInPage());
  }
}

PageRoute _getPageRoute(Widget child) {
  return MaterialPageRoute(builder: (context) => child);
}
