// ignore_for_file: constant_identifier_names

import 'package:advance_employee_management/service/department_service.dart';
import 'package:advance_employee_management/service/employee_service.dart';
import 'package:flutter/material.dart';

enum DisplayedPage {
  HOME,
  EMPLOYEES,
  MANAGERS,
  EMPLOYEEINFORMATION,
  MANAGERINFORMATION,
  MANAGERPROJECT,
  CELANDER,
  DASHBOARD,
  NOTIFICATION,
  SETTING,
  ADD,
  LOGOUT,
  PROJECTEMPLOYEEPAGE,
  DEPARTMENT
}

class AppProvider with ChangeNotifier {
  late DisplayedPage currentPage;
  EmployeeServices employeeServices = EmployeeServices();
  DepartmentService departmentService = DepartmentService();

  AppProvider.init() {
    changeCurrentPage(DisplayedPage.HOME);
  }

  changeCurrentPage(DisplayedPage newPage) {
    currentPage = newPage;
    notifyListeners();
  }
}
