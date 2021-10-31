// ignore_for_file: constant_identifier_names

import 'package:advance_employee_management/models/user.dart';
import 'package:advance_employee_management/service/user_service.dart';
import 'package:flutter/material.dart';

enum DisplayedPage { HOME, USERS, MANAGERS, DASHBOARD, NOTIFICATION, SETTING }

class AppProvider with ChangeNotifier {
  late DisplayedPage currentPage;
  UserServices userServices = UserServices();

  AppProvider.init() {
    getUser();
    changeCurrentPage(DisplayedPage.HOME);
  }

  changeCurrentPage(DisplayedPage newPage) {
    currentPage = newPage;
    notifyListeners();
  }

  void getUser() async {
    await userServices.getAllUser().then((users) {
      for (UserModel user in users) {
        print("User Name: " + user.name);
        print("User id: " + user.id);
        print("User email: " + user.email);
      }
    });
  }
}
