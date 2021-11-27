import 'package:advance_employee_management/provider/table_provider.dart';
import 'package:advance_employee_management/service/auth_services.dart';
import 'package:advance_employee_management/service/department_service.dart';
import 'package:advance_employee_management/service/employee_service.dart';
import 'package:advance_employee_management/service/notification_service.dart';
import 'package:advance_employee_management/service/project_service.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:uuid/uuid.dart';

class ModifyProjectPage extends StatefulWidget {
  const ModifyProjectPage({
    Key? key,
    required this.projectid,
    required this.projectName,
    required this.startDay,
    required this.endDay,
    required this.status,
    required this.complete,
    required this.member,
    required this.managerid,
    required this.department,
    required this.description,
  }) : super(key: key);
  final String projectName;
  final String projectid;
  final String startDay;
  final String endDay;
  final String status;
  final List complete;
  final String description;
  final String managerid;
  final List member;
  final String department;

  @override
  _ModifyProjectPageState createState() => _ModifyProjectPageState();
}

class _ModifyProjectPageState extends State<ModifyProjectPage> {
  DepartmentService departmentService = DepartmentService();

  late TextEditingController proName;
  late TextEditingController proID;
  late TextEditingController start;
  late TextEditingController end;
  late TextEditingController description;
  late TextEditingController complete;
  bool isOpen = false;
  bool isProgress = false;
  bool isClose = false;
  bool isFinish = false;
  DateTime selectedStartDate = DateTime.now();
  DateTime selectedEndDate = DateTime.now();
  List<dynamic> members = [];
  List<dynamic> memberName = [];

  String managerIDcontroller = "";
  String managerName = "";

  String departmentName = "";
  String managerID = "";
  String status = "";

  bool isEdit = false;
  bool isEditStart = false;
  bool isEditEnd = false;
  bool isEditDes = false;
  bool isEditStatus = false;
  bool isEditComplete = false;

  _selectEndDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedEndDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2025),
    );
    if (picked != null && picked != selectedEndDate) {
      selectedEndDate = picked;
      end.text = "${selectedEndDate.toLocal()}".split(' ')[0];
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
      start.text = "${selectedStartDate.toLocal()}".split(' ')[0];
    }
    setState(() {});
  }

  getMemberName(List<dynamic> members) async {
    EmployeeServices employeeServices = EmployeeServices();
    for (var item in members) {
      memberName.add(await employeeServices.getEmployeeNamebyID(item));
    }
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    proName = TextEditingController(text: widget.projectName);
    proID = TextEditingController(text: widget.projectid);
    start = TextEditingController(text: widget.startDay);
    end = TextEditingController(text: widget.endDay);
    description = TextEditingController(text: widget.description);
    complete = TextEditingController(text: widget.complete.first.toString());
    departmentName = widget.department;
    members = widget.member;
    status = widget.status;
    getMemberName(members);
    if (widget.status == "Open") {
      setState(() {
        isOpen == true;
      });
    }
    if (widget.status == "In Progress") {
      setState(() {
        isProgress == true;
      });
    }
    if (widget.status == "Finish") {
      setState(() {
        isFinish == true;
      });
    }
    if (widget.status == "Close") {
      setState(() {
        isClose == true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    TableProvider projectProvider = Provider.of<TableProvider>(
      context,
    );
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.purpleAccent[400],
          title: const Text('Project Information'),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 50),
            child: Column(
              children: <Widget>[
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        titlebox("Project Title*"),
                        textItem("Project Name", proName, false, false),
                        titlebox("Project ID*"),
                        textItem("Project ID", proID, false, false),
                        titlebox("Start Day*"),
                        Row(
                          children: [
                            textItem(start.text, start, false, false),
                            const SizedBox(
                              width: 5,
                            ),
                            isEditStart == true
                                ? IconButton(
                                    onPressed: () => _selectStartDate(context),
                                    icon: const Icon(
                                        Icons.calendar_today_outlined))
                                : Container(
                                    width: 40,
                                  ),
                          ],
                        ),
                        titlebox("End Day*"),
                        Row(
                          children: [
                            textItem(end.text, end, false, false),
                            const SizedBox(
                              width: 5,
                            ),
                            isEditEnd == true
                                ? IconButton(
                                    onPressed: () => _selectEndDate(context),
                                    icon: const Icon(
                                        Icons.calendar_today_outlined))
                                : Container(
                                    width: 40,
                                  ),
                          ],
                        ),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            titlebox("Department"),
                            const SizedBox(
                              width: 20,
                            ),
                            titlebox(departmentName)
                          ],
                        ),
                        Row(
                          children: [
                            titlebox("Status"),
                            const SizedBox(
                              width: 25,
                            ),
                            isEditStatus == true
                                ? statusButton()
                                : Text(
                                    status,
                                    style: const TextStyle(
                                        color: Colors.orangeAccent,
                                        fontSize: 18),
                                  )
                          ],
                        ),
                        Row(
                          children: [
                            titlebox("Complete"),
                            const SizedBox(
                              width: 40,
                            ),
                            isEditComplete == true
                                ? Container(
                                    padding: const EdgeInsets.only(
                                        bottom: 12, left: 10),
                                    width: 30,
                                    height: 40,
                                    child: TextField(
                                        controller: complete,
                                        decoration: const InputDecoration(
                                          contentPadding:
                                              EdgeInsets.only(bottom: 5),
                                          hintStyle: TextStyle(
                                            color: Colors.grey,
                                            fontSize: 17,
                                          ),
                                        )),
                                  )
                                : Text(
                                    complete.text,
                                    style: const TextStyle(fontSize: 18),
                                  ),
                            const SizedBox(
                              width: 5,
                            ),
                            const Text(
                              "/100",
                              style: TextStyle(fontSize: 18),
                            ),
                          ],
                        ),
                        titlebox("Members"),
                        Column(children: [
                          Row(
                            children: [
                              Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  for (var member in members)
                                    titlebox2("ID: " + member),
                                ],
                              ),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  for (var name in memberName)
                                    titlebox2("   Name: " + name),
                                ],
                              ),
                              Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  for (int i = 0; i < members.length; i++)
                                    Container(
                                      padding: const EdgeInsets.only(left: 10),
                                      child: Row(
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                top: 10, bottom: 10),
                                            child: TextButton.icon(
                                                onPressed: () {},
                                                icon: const Icon(
                                                    Icons.assessment),
                                                label:
                                                    const Text("Assign Task")),
                                          ),
                                          const SizedBox(
                                            width: 10,
                                          ),
                                          const SizedBox(
                                            height: 10,
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                top: 10, bottom: 10),
                                            child: TextButton.icon(
                                                onPressed: () {
                                                  setState(() {
                                                    ProjectService
                                                        projectService =
                                                        ProjectService();
                                                    projectService.removeMember(
                                                        members[i], proID.text);
                                                    members.remove(members[i]);
                                                    memberName
                                                        .remove(memberName[i]);
                                                  });
                                                },
                                                icon: const Icon(Icons.delete),
                                                label: const Text("Delete")),
                                          ),
                                        ],
                                      ),
                                    ),
                                ],
                              ),
                            ],
                          ),
                        ]),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            TextButton.icon(
                                onPressed: () {
                                  _openPopup(context);
                                },
                                icon: const Icon(Icons.add),
                                label: const Text("Add member"))
                          ],
                        )
                      ],
                    ),
                    const SizedBox(
                      width: 200,
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        IconButton(
                            onPressed: () {
                              setState(() {
                                isEdit = !isEdit;
                                isEditDes = !isEditDes;
                                isEditEnd = !isEditEnd;
                                isEditStart = !isEditStart;
                                isEditStatus = !isEditStatus;
                                isEditComplete = !isEditComplete;
                              });
                            },
                            icon: isEdit == false
                                ? const Icon(Icons.edit,
                                    color: Colors.blue, size: 28)
                                : const Icon(
                                    Icons.edit,
                                    color: Colors.red,
                                    size: 28,
                                  )),
                      ],
                    )
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
                        isEditDes == true
                            ? descriptionProject(description, true)
                            : descriptionProject(description, false),
                      ],
                    ),
                    Column(
                      children: const [
                        SizedBox(
                          width: 100,
                        )
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Container(
                          padding: const EdgeInsets.only(left: 200),
                          child: Row(
                            children: [
                              TextButton.icon(
                                  onPressed: () {
                                    ProjectService projectService =
                                        ProjectService();
                                    DepartmentService departmentService =
                                        DepartmentService();

                                    projectService.deleteProject(proID.text);

                                    departmentService.removeProject(
                                        departmentName, proID.text);
                                    for (Map<String, dynamic> project
                                        in projectProvider.projectSource) {
                                      if (project.values.elementAt(0) ==
                                          proID.text) {
                                        setState(() {
                                          projectProvider.projectSource
                                              .remove(project);
                                        });
                                      }
                                    }
                                    AuthClass().showSnackBar(
                                        context, "Delete Success");
                                    Navigator.pop(context);
                                  },
                                  icon: const Icon(Icons.delete),
                                  label: const Text("Delete")),
                              TextButton.icon(
                                  onPressed: () {
                                    ProjectService projectService =
                                        ProjectService();
                                    Map<String, dynamic> map =
                                        <String, dynamic>{};
                                    map.addAll({
                                      "id": proID.text,
                                      "name": proName.text,
                                      "start": start.text,
                                      "end": end.text,
                                      "status": status,
                                      "complete": int.parse(complete.text),
                                      "members": members,
                                      "manager": managerID,
                                      "department": departmentName,
                                      "description": description.text,
                                    });
                                    projectService.updateProject(
                                        proID.text, map);
                                    setState(() {
                                      for (Map<String, dynamic> project
                                          in projectProvider.projectSource) {
                                        if (project.values.elementAt(0) ==
                                            proID.text) {
                                          project.update(
                                              "id", (value) => proID.text);
                                          project.update(
                                              "name", (value) => proName.text);
                                          project.update(
                                              "start", (value) => start.text);
                                          project.update(
                                              "end", (value) => end.text);
                                          project.update(
                                              "status", (value) => status);
                                          project.update(
                                              "complete",
                                              (value) => [
                                                    int.parse(complete.text),
                                                    100
                                                  ]);
                                          project.update(
                                              "members", (value) => members);
                                          project.update(
                                              "manager", (value) => managerID);
                                          project.update("department",
                                              (value) => departmentName);
                                          project.update("description",
                                              (value) => description.text);
                                          project.update("action",
                                              (value) => [proID.text, null]);
                                        }
                                      }
                                    });
                                    dialog(
                                        DialogType.INFO, "", "Update Success");
                                  },
                                  icon: const Icon(Icons.update),
                                  label: const Text("Update")),
                            ],
                          ),
                        )
                      ],
                    )
                  ],
                )
              ],
            ),
          ),
        ));
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

  Widget descriptionProject(TextEditingController desciption, bool enable) {
    return Container(
      height: 500,
      width: 400,
      decoration: BoxDecoration(
        color: Colors.white12,
        borderRadius: BorderRadius.circular(15),
      ),
      child: TextFormField(
        enabled: enable,
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

  _openPopup(context) {
    TextEditingController id = TextEditingController();
    String message = "";

    Alert(
        context: context,
        title: "Add Member",
        content: StatefulBuilder(
          builder: (BuildContext context, setState) {
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  Column(
                    children: <Widget>[
                      SizedBox(
                        width: 300,
                        child: TextField(
                          controller: id,
                          decoration: const InputDecoration(
                            icon: Icon(
                              Icons.vpn_key_rounded,
                            ),
                            labelText: 'Member ID',
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Text("" + message,
                          style: const TextStyle(
                            color: Colors.red,
                          )),
                    ],
                  ),
                ],
              ),
            );
          },
        ),
        buttons: [
          DialogButton(
            onPressed: () async {
              DateTime now = DateTime.now();
              EmployeeServices employeeServices = EmployeeServices();
              ProjectService projectService = ProjectService();
              NotificationService notificationService = NotificationService();
              bool isExist =
                  await employeeServices.checkExistEmployeebyID(id.text);
              if (isExist) {
                String employeeName =
                    await employeeServices.getEmployeeNamebyID(id.text);

                setState(() {
                  projectService.addMember(id.text, proID.text);
                  members.add(id.text);
                  memberName.add(employeeName);
                });
                notificationService.createNotification(
                    const Uuid().v4(),
                    proName.text,
                    managerID,
                    managerName,
                    id.text,
                    now.millisecondsSinceEpoch,
                    false);
                AuthClass().showSnackBar(context, "Add success");
              } else {
                AuthClass().showSnackBar(context, "Employee is not exist");
              }
            },
            child: const Text(
              "Add",
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
          )
        ]).show();
  }

  Widget statusButton() {
    return Row(
      children: [
        const Text(
          "Open",
          style: TextStyle(fontSize: 18),
        ),
        Checkbox(
          hoverColor: Colors.red,
          checkColor: Colors.black,
          activeColor: Colors.pink,
          value: isOpen,
          onChanged: (bool? value) {
            setState(() {
              isOpen = true;
              isFinish = false;
              isProgress = false;
              isClose = false;
              status = "Open";
            });
          },
        ),
        const SizedBox(
          width: 30,
        ),
        const Text(
          "In Progress",
          style: TextStyle(fontSize: 18),
        ),
        Checkbox(
          hoverColor: Colors.red,
          checkColor: Colors.black,
          activeColor: Colors.pinkAccent,
          value: isProgress,
          onChanged: (bool? value) {
            setState(() {
              isOpen = false;
              isFinish = false;
              isProgress = true;
              isClose = false;
              status = "In Progress";
            });
          },
        ),
        const SizedBox(
          width: 30,
        ),
        const Text(
          "Finish",
          style: TextStyle(fontSize: 18),
        ),
        Checkbox(
          hoverColor: Colors.red,
          checkColor: Colors.black,
          activeColor: Colors.pink,
          value: isFinish,
          onChanged: (bool? value) {
            setState(() {
              isOpen = false;
              isFinish = true;
              isProgress = false;
              isClose = false;
              status = "Finish";
            });
          },
        ),
        const SizedBox(
          width: 30,
        ),
        const Text(
          "Close",
          style: TextStyle(fontSize: 18),
        ),
        Checkbox(
          hoverColor: Colors.red,
          checkColor: Colors.black,
          activeColor: Colors.pink,
          value: isClose,
          onChanged: (bool? value) {
            setState(() {
              isOpen = false;
              isFinish = false;
              isProgress = false;
              isClose = true;
              status = "Close";
            });
          },
        ),
      ],
    );
  }

  Widget titlebox(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Text(
        title,
        style: const TextStyle(
            color: Colors.black,
            fontSize: 17,
            letterSpacing: 0.5,
            fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget titlebox2(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Text(
        title,
        style: const TextStyle(
            color: Colors.grey, fontSize: 17, fontWeight: FontWeight.normal),
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
