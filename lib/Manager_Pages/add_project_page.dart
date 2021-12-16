import 'dart:math';

import 'package:advance_employee_management/models/employee.dart';
import 'package:advance_employee_management/provider/table_provider.dart';
import 'package:advance_employee_management/rounting/route_names.dart';
import 'package:advance_employee_management/service/auth_services.dart';
import 'package:advance_employee_management/service/department_service.dart';
import 'package:advance_employee_management/service/employee_service.dart';
import 'package:advance_employee_management/service/notification_service.dart';
import 'package:advance_employee_management/service/project_service.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

class AddProjectPage extends StatefulWidget {
  const AddProjectPage({Key? key}) : super(key: key);

  @override
  AddProjectPageState createState() => AddProjectPageState();
}

class AddProjectPageState extends State<AddProjectPage> {
  TextEditingController projectName = TextEditingController();
  TextEditingController id = TextEditingController();
  TextEditingController startday = TextEditingController();
  TextEditingController endday = TextEditingController();
  TextEditingController desController = TextEditingController();

  DateTime selectedStartDate = DateTime.now();
  DateTime selectedEndDate = DateTime.now();
  String startDayCon = "";
  String endayCon = "";
  String projectid = "";

  ProjectService projectService = ProjectService();
  EmployeeServices employeeServices = EmployeeServices();
  DepartmentService departmentService = DepartmentService();
  NotificationService notificationService = NotificationService();
  AuthClass authClass = AuthClass();
  List<EmployeeModel> listEmployeeOfManager = [];
  List<String> employeeName = [];
  List<String> employeeID = [];
  List<String> employeeIDName = [];
  final _multiKey = GlobalKey<DropdownSearchState<String>>();

  String departmentName = "";
  String managerIDcontroller = "";
  String managerName = "";

  getData() async {
    String email = AuthClass().user()!;
    managerIDcontroller = await employeeServices.getEmployeeIDbyEmail(email);
    managerName = await employeeServices.getEmployeeName(email);
    departmentName = await employeeServices.getDepartmentName(email);
    listEmployeeOfManager =
        await employeeServices.getAllEmployeeOfManager(managerIDcontroller);
    for (var element in listEmployeeOfManager) {
      employeeIDName.add(element.id + "-" + element.name);
    }

    setState(() {});
  }

  _selectEndDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedEndDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2025),
    );
    if (picked != null && picked != selectedEndDate) {
      selectedEndDate = picked;
    }

    setState(() {});
  }

  random() async {
    bool isExist;
    String id = "";
    const _chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
    const _nums = "1234567890";
    Random _rnd = Random();
    String getRandomString(int length) =>
        String.fromCharCodes(Iterable.generate(
            length, (_) => _chars.codeUnitAt(_rnd.nextInt(_chars.length))));
    String getRandomNum(int length) => String.fromCharCodes(Iterable.generate(
        length, (_) => _nums.codeUnitAt(_rnd.nextInt(_nums.length))));
    id = getRandomString(1) + getRandomNum(4);
    isExist = await projectService.checkUniqueID(id);
    if (!isExist) {
      setState(() {
        projectid = id;
      });
    } else {
      random();
    }
  }

  _selectStartDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedStartDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2025),
    );
    if (picked != null && picked != selectedStartDate) {
      selectedStartDate = picked;
    }
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    TableProvider projectProvider = Provider.of<TableProvider>(context);

    return Scaffold(
        appBar: AppBar(
          title: const Text('New Project'),
          backgroundColor: Colors.purpleAccent,
          actions: [
            TextButton(
                onPressed: () async {
                  if (checkFill()) {
                    if (employeeID.isNotEmpty) {
                      projectService.createProject(
                          projectid,
                          projectName.text,
                          managerIDcontroller,
                          "${selectedStartDate.toLocal()}".split(' ')[0],
                          "${selectedEndDate.toLocal()}".split(' ')[0],
                          desController.text,
                          employeeID,
                          departmentName,
                          "Open",
                          0);
                      setState(() {
                        projectProvider.projectSource.add({
                          "id": projectid,
                          "name": projectName.text,
                          "start":
                              "${selectedStartDate.toLocal()}".split(' ')[0],
                          "end": "${selectedEndDate.toLocal()}".split(' ')[0],
                          "status": "Open",
                          "complete": [0, 100],
                          "members": employeeID,
                          "department": departmentName,
                          "manager": managerIDcontroller,
                          "description": desController.text,
                          "action": [id.text, null],
                        });
                      });
                      departmentService.addProjectID(departmentName, id.text);
                      await EasyLoading.showSuccess('Add project Success!');
                      SchedulerBinding.instance?.addPostFrameCallback((_) {
                        Navigator.of(context)
                            .pushReplacementNamed(ProjectPageRoute);
                      });
                      for (var item in employeeID) {
                        notificationService.createNotification(
                            const Uuid().v4(),
                            managerIDcontroller,
                            item,
                            DateTime.now().millisecondsSinceEpoch,
                            false,
                            "You was add to project " + projectName.text);
                      }
                    } else {
                      AuthClass()
                          .showSnackBar(context, "Please select members");
                    }
                  } else {
                    dialog(DialogType.INFO, "Please fill all information", "");
                  }
                },
                child: Text('SAVE',
                    style: Theme.of(context)
                        .textTheme
                        .subtitle1
                        ?.copyWith(color: Colors.white))),
          ],
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 50, horizontal: 100),
            child: Column(
              children: [
                Row(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        titlebox("Project Title *"),
                        textItem("Project Name", projectName, false, true),
                        titlebox("Project ID *"),
                        Row(
                          children: [
                            randomBox(),
                            const SizedBox(
                              width: 20,
                            ),
                            ElevatedButton(
                                onPressed: () {
                                  random();
                                },
                                child: const Text("Generate"))
                          ],
                        )
                      ],
                    ),
                    const SizedBox(
                      width: 100,
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        titlebox("Start Day *"),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            textItem(
                                "${selectedStartDate.toLocal()}".split(' ')[0],
                                startday,
                                false,
                                false),
                            const SizedBox(
                              width: 20,
                            ),
                            IconButton(
                                onPressed: () => _selectStartDate(context),
                                icon: const Icon(Icons.calendar_today_outlined))
                          ],
                        ),
                        titlebox("End Day *"),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            textItem(
                                "${selectedEndDate.toLocal()}".split(' ')[0],
                                endday,
                                false,
                                false),
                            const SizedBox(
                              width: 20,
                            ),
                            IconButton(
                                onPressed: () => _selectEndDate(context),
                                icon: const Icon(Icons.calendar_today_outlined))
                          ],
                        ),
                      ],
                    )
                  ],
                ),
                const Divider(),
                DropdownSearch<String>.multiSelection(
                  key: _multiKey,
                  validator: (List<String>? v) {
                    return v == null || v.isEmpty ? "required field" : null;
                  },
                  dropdownBuilder: (context, selectedItems) {
                    Widget item(String i) => Container(
                          padding: const EdgeInsets.only(
                              left: 6, bottom: 3, top: 3, right: 0),
                          margin: const EdgeInsets.symmetric(horizontal: 2),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Theme.of(context).primaryColorLight),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                i,
                                textAlign: TextAlign.center,
                                style: Theme.of(context).textTheme.subtitle2,
                              ),
                              MaterialButton(
                                height: 20,
                                shape: const CircleBorder(),
                                focusColor: Colors.red[200],
                                hoverColor: Colors.red[200],
                                padding: const EdgeInsets.all(0),
                                minWidth: 34,
                                onPressed: () {
                                  _multiKey.currentState?.removeItem(i);
                                },
                                child: const Icon(
                                  Icons.close_outlined,
                                  size: 20,
                                ),
                              )
                            ],
                          ),
                        );
                    return Wrap(
                      children: selectedItems.map((e) => item(e)).toList(),
                    );
                  },
                  popupCustomMultiSelectionWidget: (context, list) {
                    return Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8),
                          child: OutlinedButton(
                            onPressed: () {
                              _multiKey.currentState?.closeDropDownSearch();
                            },
                            child: const Text('Cancel'),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8),
                          child: OutlinedButton(
                            onPressed: () {
                              _multiKey.currentState?.popupSelectAllItems();
                            },
                            child: const Text('Add all'),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8),
                          child: OutlinedButton(
                            onPressed: () {
                              _multiKey.currentState?.popupDeselectAllItems();
                            },
                            child: const Text('Clear All'),
                          ),
                        ),
                      ],
                    );
                  },
                  dropdownSearchDecoration: const InputDecoration(
                    hintText: "Select employee",
                    labelText: "Add Member*",
                    contentPadding: EdgeInsets.fromLTRB(12, 12, 0, 0),
                    border: OutlineInputBorder(),
                  ),
                  mode: Mode.BOTTOM_SHEET,
                  showSelectedItems: true,
                  items: employeeIDName,
                  showClearButton: true,
                  showSearchBox: true,
                  onChanged: addMenber,
                  searchFieldProps: TextFieldProps(
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      contentPadding: EdgeInsets.fromLTRB(12, 12, 8, 0),
                      labelText: "Search employee",
                    ),
                  ),
                  popupShape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(24),
                      topRight: Radius.circular(24),
                    ),
                  ),
                  popupSelectionWidget: (cnt, String item, bool isSelected) {
                    return isSelected
                        ? Icon(
                            Icons.check_circle,
                            color: Colors.green[500],
                          )
                        : Container();
                  },
                  // popupItemDisabled: (String s) => s.startsWith('I'),
                  clearButtonSplashRadius: 20,
                  selectedItems: const [],
                ),
                const Divider(),
                Row(
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        titlebox("Description*"),
                        const SizedBox(height: 10),
                        description(desController),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ));
  }

  addMenber(List<String> id) {
    if (employeeID.isEmpty) {
      employeeName = id;
      for (var item in employeeName) {
        employeeID.add(item.split("-")[0]);
      }
    } else {
      employeeName.clear();
      employeeName = id;
      employeeID.clear();
      for (var item in employeeName) {
        employeeID.add(item.split("-")[0]);
      }
    }

    setState(() {});
  }

  bool checkFill() {
    if (projectName.text.isEmpty ||
        projectid.isEmpty ||
        desController.text.isEmpty) {
      return false;
    }
    return true;
  }

  Future<bool> checkIsExistEmployee(TextEditingController employeeID) async {
    bool result =
        await employeeServices.checkExistEmployeebyID(employeeID.text);
    if (result) {
      String supervisorID =
          await employeeServices.getSupervisorID(employeeID.text);
      if (supervisorID == managerIDcontroller) {
        return true;
      }
    }
    return false;
  }

  Widget randomBox() {
    return SizedBox(
      width: 250,
      height: 40,
      child: TextFormField(
          enabled: false,
          style: const TextStyle(color: Colors.black),
          decoration: InputDecoration(
            hintText: projectid,
            labelStyle: const TextStyle(fontSize: 17, color: Colors.black),
            focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(width: 1, color: Colors.amber)),
            enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(width: 1, color: Colors.grey)),
          )),
    );
  }

  Widget textItem(String text, TextEditingController controller,
      bool obscureText, bool enable) {
    return SizedBox(
      width: 400,
      height: 40,
      child: TextFormField(
          enabled: enable,
          controller: controller,
          obscureText: obscureText,
          style: const TextStyle(color: Colors.black),
          decoration: InputDecoration(
            hintText: text,
            labelStyle: const TextStyle(fontSize: 13, color: Colors.black),
            focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(0),
                borderSide: const BorderSide(width: 1, color: Colors.blue)),
            enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(0),
                borderSide: const BorderSide(width: 1, color: Colors.black45)),
          )),
    );
  }

  Widget description(TextEditingController desciption) {
    return Container(
      height: 300,
      width: 900,
      decoration: BoxDecoration(
        color: Colors.white12,
        borderRadius: BorderRadius.circular(15),
      ),
      child: TextFormField(
        controller: desciption,
        maxLines: 7,
        style: const TextStyle(color: Colors.black, fontSize: 17),
        decoration: const InputDecoration(
          border:
              OutlineInputBorder(borderSide: BorderSide(color: Colors.teal)),
          hintText: "Description",
          hintStyle: TextStyle(
            color: Colors.grey,
            fontSize: 17,
          ),
          contentPadding: EdgeInsets.all(10),
        ),
      ),
    );
  }

  Widget titlebox(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Text(
        title,
        style: const TextStyle(
            color: Colors.black,
            fontSize: 13,
            letterSpacing: 0.5,
            fontWeight: FontWeight.bold),
      ),
    );
  }

  AwesomeDialog dialog(DialogType type, String title, String description) {
    return AwesomeDialog(
      context: context,
      width: 600,
      dialogType: type,
      animType: AnimType.BOTTOMSLIDE,
      title: title,
      desc: description,
      btnOkOnPress: () {},
    )..show();
  }
}
