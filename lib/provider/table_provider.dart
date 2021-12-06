import 'package:advance_employee_management/admin_pages/employee_information_page.dart';
import 'package:advance_employee_management/locator.dart';
import 'package:advance_employee_management/models/department.dart';
import 'package:advance_employee_management/models/employee.dart';
import 'package:advance_employee_management/models/project.dart';
// ignore: unused_import
import 'package:advance_employee_management/provider/app_provider.dart';
import 'package:advance_employee_management/service/auth_services.dart';
import 'package:advance_employee_management/service/department_service.dart';
import 'package:advance_employee_management/service/employee_service.dart';
import 'package:advance_employee_management/service/navigation_service.dart';
import 'package:advance_employee_management/service/project_service.dart';
import 'package:flutter/material.dart';

// ignore: import_of_legacy_library_into_null_safe
import 'package:responsive_table/DatatableHeader.dart';

class TableProvider with ChangeNotifier {
  List<Map<String, dynamic>> employeeSource = <Map<String, dynamic>>[];

  List<Map<String, dynamic>> projectSource = <Map<String, dynamic>>[];
  List<Map<String, dynamic>> departmentSource = <Map<String, dynamic>>[];

  List<Map<String, dynamic>> selecteds = <Map<String, dynamic>>[];

  ProjectService projectService = ProjectService();
  List<ProjectModel> projects = <ProjectModel>[];

  EmployeeServices employeeServices = EmployeeServices();
  List<EmployeeModel> employees = <EmployeeModel>[];

  DepartmentService departmentService = DepartmentService();
  List<DepartmentModel> departments = <DepartmentModel>[];

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
          List list = List.from(value);
          return Padding(
            padding: const EdgeInsets.only(left: 50),
            child: Row(
              children: [
                IconButton(
                  tooltip: "View",
                  onPressed: () async {
                    String supID;
                    EmployeeModel employeeModel =
                        await EmployeeServices().getEmployeebyID(list.first);
                    supID = await EmployeeServices()
                        .getSupervisorID(employeeModel.id);
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
                                  position: employeeModel.position,
                                  department: employeeModel.department,
                                  supID: supID,
                                )));
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
        text: "Department",
        value: "department",
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
  final List<DatatableHeader> departmentHeaders = [
    DatatableHeader(
        text: "Department ID",
        value: "id",
        show: true,
        sortable: true,
        textAlign: TextAlign.center),
    DatatableHeader(
        text: "Department Name",
        value: "name",
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
        text: "Phone",
        value: "phone",
        show: true,
        sortable: true,
        textAlign: TextAlign.center),
    DatatableHeader(
        text: "Create Day",
        value: "createday",
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

  Future loadDataFromFirebase() async {
    projects = await projectService.getAllProject();
    employees = await employeeServices.getAllEmployee();
    departments = await departmentService.getAllDepartment();
    notifyListeners();
  }

  List<Map<String, dynamic>> _getDepartment() {
    List<Map<String, dynamic>> temps = <Map<String, dynamic>>[];

    for (DepartmentModel department in departments) {
      temps.add({
        "id": department.id,
        "name": department.name,
        "phone": department.phone,
        "email": department.email,
        "createday": department.createday,
        "projectid": department.projectid,
        "action": [department.id, null]
      });
    }

    return temps;
  }

  List<Map<String, dynamic>> _getProjectData() {
    List<Map<String, dynamic>> temps = <Map<String, dynamic>>[];

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
        "department": project.department,
        "description": project.desciption,
        "action": [project.id, null],
      });
    }
    return temps;
  }

  List<Map<String, dynamic>> _getEmployeeData() {
    List<Map<String, dynamic>> temps = <Map<String, dynamic>>[];

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
        "role": employee.role,
        "department": employee.department,
        "action": [employee.id, null]
      });
    }

    return temps;
  }

  _initData() async {
    isLoading = false;
    notifyListeners();
    await loadDataFromFirebase();

    projectSource.addAll(_getProjectData());
    employeeSource.addAll(_getEmployeeData());
    departmentSource.addAll(_getDepartment());

    notifyListeners();
  }

  List<ProjectModel> getProjecTEmployee() {
    String employeeEmail = AuthClass().user()!;
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

  onSelectAllEmployee(bool value) {
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

  onSelectAllProject(bool value) {
    if (value) {
      selecteds = projectSource.map((entry) => entry).toList().cast();
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

  onSelectAllDepartment(bool value) {
    if (value) {
      selecteds = departmentSource.map((entry) => entry).toList().cast();
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

  onSelectAllManager(bool value) {
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

  delectEmployee(List<Map<String, dynamic>> list) {
    for (Map<String, dynamic> item in list) {
      employeeSource.remove(item);
    }
    isSelect == false;
    notifyListeners();
  }

  delectDepartment(List<Map<String, dynamic>> list) {
    for (Map<String, dynamic> item in list) {
      departmentSource.remove(item);
    }
    isSelect == false;
    notifyListeners();
  }

  delectProject(List<Map<String, dynamic>> list) {
    for (Map<String, dynamic> item in list) {
      projectSource.remove(item);
    }
    isSelect == false;
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
