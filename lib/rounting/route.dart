import 'package:advance_employee_management/Employee__Pages/employee_infor.dart';
import 'package:advance_employee_management/Employee__Pages/project_page_employee.dart';
import 'package:advance_employee_management/Manager_Pages/manager_infor.dart';
import 'package:advance_employee_management/Manager_Pages/project_page.dart';
import 'package:advance_employee_management/pages/Admin_Add_UserPage/add_user_page.dart';
import 'package:advance_employee_management/pages/Admin_Employee/employee_page.dart';
import 'package:advance_employee_management/pages/Admin_Manager_page/manager_page.dart';

import 'package:advance_employee_management/pages/HomePage/home_page.dart';

import 'package:advance_employee_management/pages/authentication/phone_auth.dart';
import 'package:advance_employee_management/pages/authentication/sign_in_page.dart';
import 'package:advance_employee_management/pages/authentication/sign_up_page.dart';
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
    case SignupRoute:
      return _getPageRoute(const SignUpPage());
    case PhoneAuthLog:
      return _getPageRoute(const PhoneAuth());
    case MainHomeP:
      return _getPageRoute(const HomePage());

    case AdLayOutRoute:
      return _getPageRoute(AdminLayoutRoute());
    case EmployeeLayout:
      return _getPageRoute(const EmployeePage());
    case ManagerLayout:
      return _getPageRoute(const ManagerPage());
    case AddUserLayout:
      return _getPageRoute(const AddUserPage());
    case EmployeeRouteLayout:
      return _getPageRoute(EmployeeLayoutRoute());
    case ManagerRouteLayout:
      return _getPageRoute(ManagerLayoutRoute());
    case EmployeeInformationRoute:
      return _getPageRoute(const EmployeeInformation());
    case ManagerInformationRoute:
      return _getPageRoute(const ManagerInformation());
    case ProjectPageRoute:
      return _getPageRoute(const ProjectPage());
    case ProjectPageEmployee:
      return _getPageRoute(const ProjectEmployeePage());
    default:
      return _getPageRoute(const SignInPage());
  }
  ;
}

PageRoute _getPageRoute(Widget child) {
  return MaterialPageRoute(builder: (context) => child);
}
