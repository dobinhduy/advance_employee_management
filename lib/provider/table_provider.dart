import 'dart:math';

import 'package:advance_employee_management/models/user.dart';
import 'package:advance_employee_management/service/user_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:responsive_table/DatatableHeader.dart';

class TableProvider with ChangeNotifier {
  final List<DatatableHeader> headers = [
    DatatableHeader(
        text: "Employee ID",
        value: "id",
        show: true,
        sortable: true,
        textAlign: TextAlign.center),
    DatatableHeader(
        text: "Name",
        value: "name",
        show: true,
        flex: 2,
        sortable: true,
        textAlign: TextAlign.left),
    DatatableHeader(
        text: "Email",
        value: "email",
        show: true,
        sortable: true,
        textAlign: TextAlign.left),
  ];
  final List<int> perPages = [5, 10, 15, 100];
  final int total = 100;
  int currentPerPage = 10;
  int currentPage = 1;
  bool isSearch = false;
  // ignore: deprecated_member_use
  final List<Map<String, dynamic>> source = <Map<String, dynamic>>[];
  List<Map<String, dynamic>> selecteds = <Map<String, dynamic>>[];
  final String selectableKey = "id";

  String sortColumn = "";
  bool sortAscending = true;
  bool isLoading = true;
  final bool showSelect = true;
  UserServices userServices = UserServices();
  List<UserModel> users = <UserModel>[];
  Future loadDataFromFirebase() async {
    users = await userServices.getAllUser();
  }

  List<Map<String, dynamic>> _getUserData() {
    List<Map<String, dynamic>> temps = <Map<String, dynamic>>[];
    var i = users.length;
    print(i);
    for (UserModel user in users) {
      temps.add({
        "id": user.id,
        "name": user.name,
        "email": user.email,
      });
      i++;
    }

    return temps;
  }

  addUsers() {
    userServices.addUser();

    TableProvider.init();
    notifyListeners();
  }

  @override
  void dispose() {
    super.dispose();
  }

  _initData() async {
    isLoading = true;

    notifyListeners();
    await loadDataFromFirebase();
    if (isLoading == true) {
      Future.delayed(const Duration(seconds: 2)).then((value) {
        source.addAll(_getUserData());
        isLoading = false;
        notifyListeners();
      });
    }
  }

  onSort(dynamic value) {
    sortColumn = value;
    sortAscending = !sortAscending;
    if (sortAscending) {
      source.sort((a, b) => b[sortColumn].compareTo(a[sortColumn]));
    } else {
      source.sort((a, b) => a[sortColumn].compareTo(b[sortColumn]));
    }
    notifyListeners();
  }

  onSelectAll(bool value) {
    if (value) {
      selecteds = source.map((entry) => entry).toList().cast();
    } else {
      selecteds.clear();
    }
    notifyListeners();
  }

  onChange(int value) {
    currentPerPage = value;
    notifyListeners();
  }

  previous() {
    currentPage = currentPage >= 2 ? currentPage - 1 : 1;
    notifyListeners();
  }

  next() {
    currentPage++;
    notifyListeners();
  }

  onSelect(bool value, Map<String, dynamic> item) {
    print("$value  $item ");
    if (value) {
      selecteds.add(item);
    } else {
      selecteds.removeAt(selecteds.indexOf(item));
    }
    notifyListeners();
  }

  TableProvider.init() {
    _initData();
  }
}
