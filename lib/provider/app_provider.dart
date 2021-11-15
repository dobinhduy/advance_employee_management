// ignore_for_file: constant_identifier_names

import 'package:advance_employee_management/models/employee.dart';
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
  ADD
}

class AppProvider with ChangeNotifier {
  late DisplayedPage currentPage;
  EmployeeServices employeeServices = EmployeeServices();

  AppProvider.init() {
    changeCurrentPage(DisplayedPage.HOME);
  }

  changeCurrentPage(DisplayedPage newPage) {
    currentPage = newPage;
    notifyListeners();
  }
}
