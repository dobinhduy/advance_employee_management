// ignore_for_file: constant_identifier_names

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

  AppProvider.init() {
    changeCurrentPage(DisplayedPage.HOME);
  }

  changeCurrentPage(DisplayedPage newPage) {
    currentPage = newPage;
    notifyListeners();
  }
}
