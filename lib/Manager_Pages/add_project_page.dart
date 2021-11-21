import 'package:advance_employee_management/models/employee.dart';
import 'package:advance_employee_management/provider/table_provider.dart';
import 'package:advance_employee_management/rounting/route_names.dart';
import 'package:advance_employee_management/service/auth_services.dart';
import 'package:advance_employee_management/service/department_service.dart';
import 'package:advance_employee_management/service/employee_service.dart';
import 'package:advance_employee_management/service/manager_service.dart';
import 'package:advance_employee_management/service/notification_service.dart';
import 'package:advance_employee_management/service/project_service.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:intl/intl.dart';
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
  TextEditingController memberID1 = TextEditingController();
  TextEditingController memberID2 = TextEditingController();
  TextEditingController memberID3 = TextEditingController();

  DateTime selectedStartDate = DateTime.now();
  DateTime selectedEndDate = DateTime.now();
  String startDayCon = "";
  String endayCon = "";
  ManagerServices managerServices = ManagerServices();
  ProjectService projectService = ProjectService();
  EmployeeServices employeeServices = EmployeeServices();
  DepartmentService departmentService = DepartmentService();
  NotificationService notificationService = NotificationService();
  AuthClass authClass = AuthClass();
  List<String> listDepartment = [];

  String managerIDcontroller = "";
  String managerName = "";
  String? dropdownDeName;
  getManagerID() async {
    String email = AuthClass().user()!;
    managerIDcontroller = await managerServices.getManagerIDbyEmail(email);
    managerName = await managerServices.getManagerName(email);
    setState(() {});
  }

  getAllDepartmentName() async {
    listDepartment = await departmentService.getAllDepartmentName();
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
  Widget build(BuildContext context) {
    TableProvider projectProvider = Provider.of<TableProvider>(context);
    getManagerID();
    getAllDepartmentName();
    return Scaffold(
        appBar: AppBar(
          title: const Text('New Project'),
          actions: [
            TextButton(
                onPressed: () {
                  var now = DateTime.now();
                  var formatter = DateFormat('yyyy-MM-dd');
                  String formattedDate = formatter.format(now);
                  List<String> members = <String>[];
                  if (memberID1.text.isNotEmpty) {
                    members.add(memberID1.text);
                  }
                  if (memberID2.text.isNotEmpty) {
                    members.add(memberID2.text);
                  }
                  if (memberID3.text.isNotEmpty) {
                    members.add(memberID3.text);
                  }

                  projectService.createProject(
                      id.text,
                      projectName.text,
                      managerIDcontroller,
                      "${selectedStartDate.toLocal()}".split(' ')[0],
                      "${selectedEndDate.toLocal()}".split(' ')[0],
                      desController.text,
                      members,
                      "Open",
                      0);
                  setState(() {
                    projectProvider.projectSource.add({
                      "id": id.text,
                      "name": projectName.text,
                      "start": "${selectedStartDate.toLocal()}".split(' ')[0],
                      "end": "${selectedEndDate.toLocal()}".split(' ')[0],
                      "status": "Open",
                      "complete": [0, 100],
                      "members": members,
                      "manager": managerIDcontroller,
                      "description": desController.text,
                      "action": [id.text, null],
                    });
                  });
                  authClass.showSnackBar(context, "Add project success");
                  SchedulerBinding.instance?.addPostFrameCallback((_) {
                    Navigator.of(context)
                        .pushReplacementNamed(ProjectPageRoute);
                  });
                  notificationService.createNotification(
                      const Uuid().v4(),
                      projectName.text,
                      managerIDcontroller,
                      managerName,
                      memberID1.text,
                      formattedDate,
                      false);
                },
                child: Text('SAVE',
                    style: Theme.of(context)
                        .textTheme
                        .subtitle1
                        ?.copyWith(color: Colors.white))),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(vertical: 50, horizontal: 100),
          child: SizedBox(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: Column(
              children: [
                Row(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        titlebox("Project Title*"),
                        textItem("Project Name", projectName, false, true),
                        titlebox("Project ID*"),
                        textItem("Project ID", id, false, true),
                        titlebox("Start Day*"),
                        Row(
                          children: [
                            textItem(
                                "${selectedStartDate.toLocal()}".split(' ')[0],
                                startday,
                                false,
                                false),
                            const SizedBox(
                              width: 20,
                            ),
                            ElevatedButton.icon(
                              onPressed: () => _selectStartDate(context),
                              icon: const Icon(
                                Icons.calendar_view_month_outlined,
                                color: Colors.white,
                                size: 20.0,
                              ),
                              label: const Text(
                                '',
                              ),
                            ),
                          ],
                        ),
                        titlebox("End Day*"),
                        Row(
                          children: [
                            textItem(
                                "${selectedEndDate.toLocal()}".split(' ')[0],
                                endday,
                                false,
                                false),
                            const SizedBox(
                              width: 20,
                            ),
                            ElevatedButton.icon(
                              onPressed: () => _selectEndDate(context),
                              icon: const Icon(
                                Icons.calendar_view_week,
                                color: Colors.white,
                                size: 20.0,
                              ),
                              label: const Text(
                                '',
                                style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 100),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          titlebox("Department"),
                          selectDepartment(),
                          titlebox("Member 1*"),
                          Row(
                            children: [
                              textItem(
                                  "Input member ID", memberID1, false, true),
                              const SizedBox(
                                width: 50,
                              ),
                              checkExistButton(memberID1)
                            ],
                          ),
                          titlebox("Member 2*"),
                          Row(
                            children: [
                              textItem(
                                  "Input member ID", memberID2, false, true),
                              const SizedBox(
                                width: 50,
                              ),
                              checkExistButton(memberID2),
                            ],
                          ),
                          titlebox("Member 3*"),
                          Row(
                            children: [
                              textItem(
                                  "Input member ID", memberID3, false, true),
                              const SizedBox(
                                width: 50,
                              ),
                              checkExistButton(memberID3)
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        titlebox("Description*"),
                        description(desController),
                      ],
                    ),
                    Column(
                      children: [
                        const SizedBox(
                          width: 100,
                        )
                      ],
                    ),
                  ],
                )
              ],
            ),
          ),
        ));
  }

  Widget selectDepartment() {
    return Container(
      width: 400,
      child: DropdownButton<String>(
        value: dropdownDeName,
        iconSize: 24,
        elevation: 16,
        style: const TextStyle(color: Colors.deepPurple),
        underline: Container(
          height: 2,
          color: Colors.deepPurpleAccent,
          width: 380,
        ),
        onChanged: (String? newValue) {
          setState(() {
            dropdownDeName = newValue!;
          });
        },
        icon: Icon(Icons.arrow_back, color: Colors.white),
        items: listDepartment.map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          );
        }).toList(),
      ),
    );
  }

  Widget checkExistButton(TextEditingController textEditingController) {
    return InkWell(
      onTap: () async {
        bool result = await employeeServices
            .checkExistEmployeebyID(textEditingController.text);

        if (result == true) {
          EmployeeModel employee = await employeeServices
              .getEmployeebyID(textEditingController.text);
          dialog(DialogType.INFO, "Employee exist",
              "Name: " + employee.name + "\n Email: " + employee.email);
        } else {
          dialog(DialogType.ERROR, "Employee is not exist", "");
        }
      },
      child: Container(
        width: 50,
        height: 40,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          gradient: const LinearGradient(colors: [
            Color(0xfffd746c),
            Color(0xffff9068),
            Color(0xfffd746c)
          ]),
        ),
        child: const Center(
          child: Text(
            "Varify",
            style: TextStyle(fontSize: 17, color: Colors.white),
          ),
        ),
      ),
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
      height: 200,
      width: MediaQuery.of(context).size.width / 2,
      decoration: BoxDecoration(
        color: Colors.white12,
        borderRadius: BorderRadius.circular(15),
      ),
      child: TextFormField(
        controller: desciption,
        maxLines: null,
        style: const TextStyle(color: Colors.grey, fontSize: 17),
        decoration: InputDecoration(
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(0),
              borderSide: const BorderSide(width: 1, color: Colors.blue)),
          hintText: "Description",
          hintStyle: const TextStyle(
            color: Colors.grey,
            fontSize: 17,
          ),
          contentPadding: const EdgeInsets.only(left: 20, right: 20),
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
