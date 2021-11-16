import 'package:advance_employee_management/models/employee.dart';
import 'package:advance_employee_management/models/manager.dart';
import 'package:advance_employee_management/models/project.dart';
// ignore: unused_import
import 'package:advance_employee_management/provider/app_provider.dart';
import 'package:advance_employee_management/service/auth_services.dart';
import 'package:advance_employee_management/service/employee_service.dart';
import 'package:advance_employee_management/service/manager_service.dart';
import 'package:advance_employee_management/service/project_service.dart';
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
          return Padding(
            padding: const EdgeInsets.only(left: 20),
            child: Row(
              children: [
                IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.delete_forever),
                  color: Colors.red,
                ),
                IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.edit),
                  color: Colors.blue,
                ),
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
          return Padding(
            padding: const EdgeInsets.only(left: 20),
            child: Row(
              children: [
                IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.delete_forever),
                  color: Colors.red,
                ),
                IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.edit),
                  color: Colors.blue,
                ),
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
  final List<DatatableHeader> projectHeaders = [
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
            padding: const EdgeInsets.only(left: 20),
            child: Row(
              children: [
                IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.delete_forever),
                  color: Colors.red,
                ),
                IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.edit),
                  color: Colors.blue,
                ),
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
  String sortColumn = "";
  bool sortAscending = true;
  bool isLoading = true;
  final bool showSelect = true;
  final String selectableKey = "id";
  String employeeEmail = AuthClass().user()!;

  List<Map<String, dynamic>> employeeSource = <Map<String, dynamic>>[];
  List<Map<String, dynamic>> managerSource = <Map<String, dynamic>>[];
  List<Map<String, dynamic>> projectSource = <Map<String, dynamic>>[];

  List<Map<String, dynamic>> selecteds = <Map<String, dynamic>>[];

  ManagerServices managerServices = ManagerServices();
  List<ManagerModel> managers = <ManagerModel>[];

  ProjectService projectService = ProjectService();
  List<ProjectModel> projects = <ProjectModel>[];

  EmployeeServices employeeServices = EmployeeServices();
  List<EmployeeModel> employees = <EmployeeModel>[];

  Future loadDataFromFirebase() async {
    managers = await managerServices.getAllManger();
    projects = await projectService.getAllProject();
    employees = await employeeServices.getAllEmployee();
    notifyListeners();
  }

  List<Map<String, dynamic>> _getManagerData() {
    List<Map<String, dynamic>> temps = <Map<String, dynamic>>[];

    for (ManagerModel manager in managers) {
      temps.add({
        "id": manager.id,
        "name": manager.name,
        "gender": manager.gender,
        "birthday": manager.birthday,
        "email": manager.email,
        "address": manager.address,
        "phone": manager.phone,
        "photoURL": manager.photourl,
        "position": manager.position,
        "action": [null, null]
      });
    }

    return temps;
  }

  List<Map<String, dynamic>> _getProjectData() {
    List<Map<String, dynamic>> temps = <Map<String, dynamic>>[];
    var i = 0;
    for (ProjectModel project in projects) {
      temps.add({
        "id": project.id,
        "name": project.name,
        "start": project.start,
        "end": project.end,
        "status": project.status,
        "complete": [project.complete, 100],
        "members": project.members,
        "manager": project.manager,
        "description": project.desciption,
        "action": [null, null],
      });
      i++;
    }
    return temps;
  }
  // "\$${project.complete}}"

  List<Map<String, dynamic>> _getEmployeeData() {
    List<Map<String, dynamic>> temps = <Map<String, dynamic>>[];
    var i = employees.length;

    for (EmployeeModel employee in employees) {
      temps.add({
        "id": employee.id,
        "name": employee.name,
        "gender": employee.gender,
        "birthday": employee.birthday,
        "email": employee.email,
        "address": employee.address,
        "phone": employee.phone,
        "photourl": employee.photourl,
        "position": employee.position,
        "action": [null, null]
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
