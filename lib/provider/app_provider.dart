// ignore_for_file: constant_identifier_names

import 'package:advance_employee_management/models/employee.dart';
import 'package:advance_employee_management/service/employee_service.dart';
import 'package:flutter/material.dart';

enum DisplayedPage {
  HOME,
  EMPLOYEES,
  MANAGERS,
  DASHBOARD,
  NOTIFICATION,
  SETTING
}

class AppProvider with ChangeNotifier {
  late DisplayedPage currentPage;
  EmployeeServices employeeServices = EmployeeServices();

  AppProvider.init() {
    getEmployee();
    changeCurrentPage(DisplayedPage.HOME);
  }

  changeCurrentPage(DisplayedPage newPage) {
    currentPage = newPage;
    notifyListeners();
  }

  void getEmployee() async {
    await employeeServices.getAllEmployee().then((employees) {
      for (EmployeeModel employee in employees) {
        print("User Name: " + employee.name);
        print("User id: " + employee.id);
        print("User email: " + employee.email);
      }
    });
  }
}
