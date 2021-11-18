import 'dart:js';

import 'package:advance_employee_management/locator.dart';
import 'package:advance_employee_management/models/employee.dart';
import 'package:advance_employee_management/models/manager.dart';
import 'package:advance_employee_management/models/project.dart';
import 'package:advance_employee_management/pages/Admin_Employee/employee_information_page.dart';
// ignore: unused_import
import 'package:advance_employee_management/provider/app_provider.dart';
import 'package:advance_employee_management/service/auth_services.dart';
import 'package:advance_employee_management/service/employee_service.dart';
import 'package:advance_employee_management/service/manager_service.dart';
import 'package:advance_employee_management/service/navigation_service.dart';
import 'package:advance_employee_management/service/project_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

// ignore: import_of_legacy_library_into_null_safe
import 'package:responsive_table/DatatableHeader.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class TableProvider with ChangeNotifier {
  List<Map<String, dynamic>> employeeSource = <Map<String, dynamic>>[];
  List<Map<String, dynamic>> managerSource = <Map<String, dynamic>>[];
  List<Map<String, dynamic>> projectSource = <Map<String, dynamic>>[];
  List get _employeeSource => employeeSource;

  List<Map<String, dynamic>> selecteds = <Map<String, dynamic>>[];

  ManagerServices managerServices = ManagerServices();
  List<ManagerModel> managers = <ManagerModel>[];

  ProjectService projectService = ProjectService();
  List<ProjectModel> projects = <ProjectModel>[];

  EmployeeServices employeeServices = EmployeeServices();
  List<EmployeeModel> employees = <EmployeeModel>[];
  final List<DatatableHeader> employeeHeaders = [
    DatatableHeader(
        text: "Order",
        value: "order",
        show: true,
        sortable: true,
        textAlign: TextAlign.center),
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
        text: "Address",
        value: "address",
        flex: 2,
        show: true,
        sortable: true,
        textAlign: TextAlign.center),
    DatatableHeader(
        text: "Phone",
        value: "phone",
        show: true,
        sortable: true,
        textAlign: TextAlign.center),
    DatatableHeader(
        text: "Action",
        value: "action",
        show: true,
        sortable: true,
        textAlign: TextAlign.center,
        sourceBuilder: (value, row) {
          List list = List.from(value);
          return Padding(
            padding: const EdgeInsets.only(left: 50),
            child: Row(
              children: [
                IconButton(
                  tooltip: "View",
                  onPressed: () async {
                    EmployeeModel employeeModel =
                        await EmployeeServices().getEmployeebyID(list.first);
                    locator<NavigationService>()
                        .navigatorKey
                        .currentState
                        ?.push(MaterialPageRoute(
                            builder: (context) => UserInforPage(
                                name: employeeModel.name,
                                email: employeeModel.email,
                                id: employeeModel.id,
                                photoURL: employeeModel.photourl,
                                birthday: employeeModel.birthday,
                                address: employeeModel.address,
                                gender: employeeModel.gender,
                                phone: employeeModel.phone,
                                position: employeeModel.position)));
                  },
                  icon: const Icon(Icons.remove_red_eye_sharp),
                  color: Colors.grey,
                )
              ],
            ),
          );
        }),
  ];
  final List<DatatableHeader> managerHeaders = [
    DatatableHeader(
        text: "Order",
        value: "order",
        show: true,
        sortable: true,
        textAlign: TextAlign.center),
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
        text: "Address",
        value: "address",
        flex: 2,
        show: true,
        sortable: true,
        textAlign: TextAlign.center),
    DatatableHeader(
        text: "Phone",
        value: "phone",
        show: true,
        sortable: true,
        textAlign: TextAlign.center),
    DatatableHeader(
        text: "Action",
        value: "action",
        show: true,
        sortable: true,
        textAlign: TextAlign.center,
        sourceBuilder: (value, row) {
          List list = List.from(value);
          Map<String, dynamic> listmap = row;
          return Padding(
            padding: const EdgeInsets.only(left: 50),
            child: Row(
              children: [
                IconButton(
                  tooltip: "View",
                  onPressed: () async {
                    ManagerModel managerModel =
                        await ManagerServices().getManagerbyID(list.first);
                    locator<NavigationService>()
                        .navigatorKey
                        .currentState
                        ?.push(MaterialPageRoute(
                            builder: (context) => UserInforPage(
                                name: managerModel.name,
                                email: managerModel.email,
                                id: managerModel.id,
                                photoURL: managerModel.photourl,
                                birthday: managerModel.birthday,
                                address: managerModel.address,
                                gender: managerModel.gender,
                                phone: managerModel.phone,
                                position: managerModel.position)));
                  },
                  icon: const Icon(Icons.remove_red_eye_sharp),
                  color: Colors.grey,
                )
              ],
            ),
          );
        }),
  ];
  final List<DatatableHeader> projectHeaders = [
    DatatableHeader(
        text: "Order",
        value: "order",
        show: true,
        sortable: true,
        textAlign: TextAlign.center),
    DatatableHeader(
        text: "Project ID",
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
        text: "Start Day",
        value: "start",
        show: true,
        sortable: true,
        textAlign: TextAlign.center),
    DatatableHeader(
        text: "End day",
        value: "end",
        show: true,
        sortable: true,
        textAlign: TextAlign.center),
    DatatableHeader(
        text: "Status",
        value: "status",
        show: true,
        sortable: true,
        textAlign: TextAlign.center),
    DatatableHeader(
      text: "Complete(%)",
      value: "complete",
      show: true,
      sortable: true,
      textAlign: TextAlign.center,
      sourceBuilder: (value, row) {
        List list = List.from(value);
        return Column(
          children: [
            SizedBox(
              width: 85,
              child: LinearProgressIndicator(
                value: list.first / list.last,
              ),
            ),
            Text("${list.first} of ${list.last}")
          ],
        );
      },
    ),
    DatatableHeader(
        text: "Action",
        value: "action",
        show: true,
        sortable: true,
        textAlign: TextAlign.center,
        sourceBuilder: (value, row) {
          return Padding(
            padding: const EdgeInsets.only(left: 50),
            child: Row(
              children: [
                IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.remove_red_eye_sharp),
                  color: Colors.grey,
                )
              ],
            ),
          );
        }),
  ];

  final List<int> perPages = [5, 10, 15, 100];
  final int total = 100;
  int currentPerPage = 10;
  int currentPage = 1;
  bool isSearch = false;
  bool isSelect = false;
  String sortColumn = "";
  bool sortAscending = true;
  bool isLoading = true;
  final bool showSelect = true;
  final String selectableKey = "id";
  String employeeEmail = AuthClass().user()!;

  Future loadDataFromFirebase() async {
    managers = await managerServices.getAllManger();
    projects = await projectService.getAllProject();
    employees = await employeeServices.getAllEmployee();
    notifyListeners();
  }

  List<Map<String, dynamic>> _getManagerData() {
    List<Map<String, dynamic>> temps = <Map<String, dynamic>>[];
    int i = 1;
    for (ManagerModel manager in managers) {
      temps.add({
        "order": i,
        "id": manager.id,
        "name": manager.name,
        "gender": manager.gender,
        "birthday": manager.birthday,
        "email": manager.email,
        "address": manager.address,
        "phone": manager.phone,
        "photoURL": manager.photourl,
        "position": manager.position,
        "action": [manager.id, i]
      });
      i++;
    }

    return temps;
  }

  List<Map<String, dynamic>> _getProjectData() {
    List<Map<String, dynamic>> temps = <Map<String, dynamic>>[];
    var i = 1;
    for (ProjectModel project in projects) {
      temps.add({
        "order": i,
        "id": project.id,
        "name": project.name,
        "start": project.start,
        "end": project.end,
        "status": project.status,
        "complete": [project.complete, 100],
        "members": project.members,
        "manager": project.manager,
        "description": project.desciption,
        "action": [project.id, i],
      });
      i++;
    }
    return temps;
  }
  // "\$${project.complete}}"

  List<Map<String, dynamic>> _getEmployeeData() {
    List<Map<String, dynamic>> temps = <Map<String, dynamic>>[];
    var i = 1;

    for (EmployeeModel employee in employees) {
      temps.add({
        "order": i,
        "id": employee.id,
        "name": employee.name,
        "gender": employee.gender,
        "birthday": employee.birthday,
        "email": employee.email,
        "address": employee.address,
        "phone": employee.phone,
        "photourl": employee.photourl,
        "position": employee.position,
        "action": [employee.id, i]
      });
      i++;
    }

    return temps;
  }

  _initData() async {
    isLoading = false;
    notifyListeners();
    await loadDataFromFirebase();

    managerSource.addAll(_getManagerData());
    projectSource.addAll(_getProjectData());

    employeeSource.addAll(_getEmployeeData());

    notifyListeners();
  }

  List<ProjectModel> getProjecTEmployee() {
    List<ProjectModel> list = [];
    for (ProjectModel project in projects) {
      for (String member in project.members) {
        if (member == employeeEmail) {
          list.add(project);
        }
      }
    }
    return list;
  }

  removeItem(Map<String, dynamic> item) {
    employeeSource.remove(item);
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
      if (selecteds.isNotEmpty) {
        isSelect = true;
      } else {
        isSelect = false;
      }
    } else {
      selecteds.clear();
      if (selecteds.isNotEmpty) {
        isSelect = true;
      } else {
        isSelect = false;
      }
    }
    notifyListeners();
  }

  onSelect(bool value, Map<String, dynamic> item) {
    // ignore: avoid_print
    print("$value  $item ");
    if (value) {
      selecteds.add(item);
      if (selecteds.isNotEmpty) {
        isSelect = true;
      } else {
        isSelect = false;
      }
    } else {
      selecteds.removeAt(selecteds.indexOf(item));
      if (selecteds.isNotEmpty) {
        isSelect = true;
      } else {
        isSelect = false;
      }
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

  TableProvider.init() {
    _initData();
  }
}
