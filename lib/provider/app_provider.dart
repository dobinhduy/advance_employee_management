import 'package:flutter/material.dart';

enum DisplayedPage { HOME, USERS, MANAGERS }

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
