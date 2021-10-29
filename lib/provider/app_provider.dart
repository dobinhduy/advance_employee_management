// ignore_for_file: constant_identifier_names

import 'package:flutter/material.dart';

enum DisplayedPage { HOME, USERS, MANAGERS, DASHBOARD, NOTIFICATION, SETTING }

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
