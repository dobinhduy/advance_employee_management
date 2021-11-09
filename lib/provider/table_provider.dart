import 'package:advance_employee_management/models/employee.dart';
import 'package:advance_employee_management/models/manager.dart';
// ignore: unused_import
import 'package:advance_employee_management/provider/app_provider.dart';
import 'package:advance_employee_management/service/employee_service.dart';
import 'package:advance_employee_management/service/manager_service.dart';
import 'package:flutter/material.dart';

// ignore: import_of_legacy_library_into_null_safe
import 'package:responsive_table/DatatableHeader.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class TableProvider with ChangeNotifier {
  final List<DatatableHeader> employeeHeaders = [
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
        sortable: true,
        textAlign: TextAlign.center),
    DatatableHeader(
        text: "Gender",
        value: "gender",
        show: true,
        sortable: true,
        textAlign: TextAlign.center),
    DatatableHeader(
        text: "Birthday",
        value: "birthday",
        show: true,
        sortable: true,
        textAlign: TextAlign.center),
    DatatableHeader(
        text: "Email",
        value: "email",
        flex: 2,
        show: true,
        sortable: true,
        textAlign: TextAlign.center),
    DatatableHeader(
        text: "Address",
        value: "address",
        show: true,
        sortable: true,
        textAlign: TextAlign.center),
    DatatableHeader(
        text: "Phone",
        value: "phone",
        show: true,
        sortable: true,
        textAlign: TextAlign.center),
  ];
  final List<DatatableHeader> managerHeaders = [
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
        flex: 1,
        sortable: true,
        textAlign: TextAlign.center),
    DatatableHeader(
        text: "Gender",
        value: "gender",
        show: true,
        sortable: true,
        textAlign: TextAlign.center),
    DatatableHeader(
        text: "Birthday",
        value: "birthday",
        show: true,
        sortable: true,
        textAlign: TextAlign.center),
    DatatableHeader(
        text: "Email",
        value: "email",
        flex: 2,
        show: true,
        sortable: true,
        textAlign: TextAlign.center),
    DatatableHeader(
        text: "Address",
        value: "address",
        show: true,
        sortable: true,
        textAlign: TextAlign.center),
    DatatableHeader(
        text: "Phone",
        value: "phone",
        show: true,
        sortable: true,
        textAlign: TextAlign.center),
  ];
  final List<int> perPages = [5, 10, 15, 100];
  final int total = 100;

  int currentPerPage = 10;
  int currentPage = 1;
  bool isSearch = false;
  String sortColumn = "";
  bool sortAscending = true;
  bool isLoading = true;
  final bool showSelect = true;
  final String selectableKey = "id";

  List<Map<String, dynamic>> employeeSource = <Map<String, dynamic>>[];
  List<Map<String, dynamic>> managerSource = <Map<String, dynamic>>[];

  List<Map<String, dynamic>> selecteds = <Map<String, dynamic>>[];

  EmployeeServices employeeServices = EmployeeServices();
  ManagerServices managerServices = ManagerServices();
  List<EmployeeModel> employees = <EmployeeModel>[];
  List<ManagerModel> managers = <ManagerModel>[];
  Future loadDataFromFirebase() async {
    employees = await employeeServices.getAllEmployee();
    managers = await managerServices.getAllManger();
  }

  List<Map<String, dynamic>> _getManagerData() {
    List<Map<String, dynamic>> temps = <Map<String, dynamic>>[];
    var i = managers.length;
    // ignore: avoid_print
    print(i);
    for (ManagerModel manager in managers) {
      temps.add({
        "id": manager.id,
        "name": manager.name,
        "gender": manager.gender,
        "birthday": manager.birthday,
        "email": manager.email,
        "address": manager.address,
        "phone": manager.phone,
      });
      i++;
    }

    return temps;
  }

  List<Map<String, dynamic>> _getEmployeeData() {
    List<Map<String, dynamic>> temps = <Map<String, dynamic>>[];
    var i = employees.length;
    // ignore: avoid_print
    print(i);
    for (EmployeeModel employee in employees) {
      temps.add({
        "id": employee.id,
        "name": employee.name,
        "gender": employee.gender,
        "birthday": employee.birthday,
        "email": employee.email,
        "address": employee.address,
        "phone": employee.phone,
      });
      i++;
    }

    return temps;
  }

  _initData() async {
    isLoading = true;

    notifyListeners();
    await loadDataFromFirebase();
    if (isLoading == true) {
      Future.delayed(const Duration(seconds: 2)).then((value) {
        employeeSource.addAll(_getEmployeeData());
        managerSource.addAll(_getManagerData());
        isLoading = false;
        notifyListeners();
      });
    }
  }

  onSort(dynamic value) {
    sortColumn = value;
    sortAscending = !sortAscending;
    if (sortAscending) {
      employeeSource.sort((a, b) => b[sortColumn].compareTo(a[sortColumn]));
    } else {
      employeeSource.sort((a, b) => a[sortColumn].compareTo(b[sortColumn]));
    }
    notifyListeners();
  }

  onSelectAll(bool value) {
    if (value) {
      selecteds = employeeSource.map((entry) => entry).toList().cast();
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
    // ignore: avoid_print
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
