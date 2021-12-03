import 'package:advance_employee_management/models/employee.dart';
import 'package:advance_employee_management/provider/table_provider.dart';
import 'package:advance_employee_management/rounting/route_names.dart';
import 'package:advance_employee_management/service/auth_services.dart';
import 'package:advance_employee_management/service/department_service.dart';
import 'package:advance_employee_management/service/employee_service.dart';
import 'package:advance_employee_management/service/notification_service.dart';
import 'package:advance_employee_management/service/project_service.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
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

  ProjectService projectService = ProjectService();
  EmployeeServices employeeServices = EmployeeServices();
  DepartmentService departmentService = DepartmentService();
  NotificationService notificationService = NotificationService();
  AuthClass authClass = AuthClass();
  List<String> listDepartment = [];

  String managerIDcontroller = "";
  String managerName = "";
  String? dropdownDeName;
  String departmentName = "";
  getManagerID() async {
    String email = AuthClass().user()!;
    managerIDcontroller = await employeeServices.getEmployeeIDbyEmail(email);
    managerName = await employeeServices.getEmployeeName(email);
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
                onPressed: () async {
                  List<String> members = <String>[];
                  bool isExistE1 = true;
                  bool isExistE2 = true;
                  bool isExistE3 = true;
                  if (memberID1.text.isNotEmpty) {
                    isExistE1 = await checkIsExistEmployee(memberID1);
                    if (isExistE1) {
                      members.add(memberID1.text);
                    } else {
                      isExistE1 = false;
                    }
                  }
                  if (memberID2.text.isNotEmpty) {
                    isExistE2 = await checkIsExistEmployee(memberID2);
                    if (isExistE2) {
                      members.add(memberID2.text);
                    } else {
                      isExistE2 = false;
                    }
                  }
                  if (memberID3.text.isNotEmpty) {
                    isExistE3 = await checkIsExistEmployee(memberID3);
                    if (isExistE3) {
                      members.add(memberID3.text);
                    } else {
                      isExistE3 = false;
                    }
                  }
                  if (isExistE1 && isExistE2 && isExistE3) {
                    projectService.createProject(
                        id.text,
                        projectName.text,
                        managerIDcontroller,
                        "${selectedStartDate.toLocal()}".split(' ')[0],
                        "${selectedEndDate.toLocal()}".split(' ')[0],
                        desController.text,
                        members,
                        departmentName,
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
                        "department": departmentName,
                        "manager": managerIDcontroller,
                        "description": desController.text,
                        "action": [id.text, null],
                      });
                    });
                    departmentService.addProjectID(departmentName, id.text);
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
                        DateTime.now().millisecondsSinceEpoch,
                        false,
                        "ADDPROJECT");
                  } else {
                    AuthClass().showSnackBar(
                        context, "Some of employee id are not exist");
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
                          titlebox("Project Title *"),
                          textItem("Project Name", projectName, false, true),
                          titlebox("Project ID *"),
                          textItem("Project ID", id, false, true),
                          titlebox("Start Day *"),
                          Row(
                            children: [
                              textItem(
                                  "${selectedStartDate.toLocal()}"
                                      .split(' ')[0],
                                  startday,
                                  false,
                                  false),
                              const SizedBox(
                                width: 20,
                              ),
                              IconButton(
                                  onPressed: () => _selectStartDate(context),
                                  icon:
                                      const Icon(Icons.calendar_today_outlined))
                            ],
                          ),
                          titlebox("End Day *"),
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
                              IconButton(
                                  onPressed: () => _selectEndDate(context),
                                  icon:
                                      const Icon(Icons.calendar_today_outlined))
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
                            titlebox("Member 1"),
                            Row(
                              children: [
                                textItem(
                                    "Input member ID", memberID1, false, true),
                                const SizedBox(
                                  width: 50,
                                ),
                              ],
                            ),
                            titlebox("Member 2"),
                            Row(
                              children: [
                                textItem(
                                    "Input member ID", memberID2, false, true),
                                const SizedBox(
                                  width: 50,
                                ),
                              ],
                            ),
                            titlebox("Member 3"),
                            Row(
                              children: [
                                textItem(
                                    "Input member ID", memberID3, false, true),
                                const SizedBox(
                                  width: 50,
                                ),
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
                          const SizedBox(height: 10),
                          description(desController),
                        ],
                      ),
                      Column(
                        children: const [
                          SizedBox(
                            width: 100,
                          )
                        ],
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        ));
  }

  Widget selectDepartment() {
    return SizedBox(
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
            departmentName = dropdownDeName!;
          });
        },
        icon: const Icon(Icons.arrow_back, color: Colors.white),
        items: listDepartment.map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          );
        }).toList(),
      ),
    );
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

  Widget checkExistButton(TextEditingController textEditingController) {
    return InkWell(
      onTap: () async {
        bool result = await employeeServices
            .checkExistEmployeebyID(textEditingController.text);

        if (result) {
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
          borderRadius: BorderRadius.circular(0),
          color: Colors.blueAccent,
        ),
        child: const Center(
          child: Text(
            "Varify",
            style: TextStyle(fontSize: 15, color: Colors.white),
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
      height: 500,
      width: 400,
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
