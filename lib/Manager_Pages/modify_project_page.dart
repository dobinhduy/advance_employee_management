import 'package:advance_employee_management/Manager_Pages/add_member.dart';
import 'package:advance_employee_management/locator.dart';
import 'package:advance_employee_management/models/task.dart';
import 'package:advance_employee_management/provider/table_provider.dart';
import 'package:advance_employee_management/rounting/route_names.dart';
import 'package:advance_employee_management/service/auth_services.dart';
import 'package:advance_employee_management/service/department_service.dart';
import 'package:advance_employee_management/service/employee_service.dart';
import 'package:advance_employee_management/service/navigation_service.dart';
import 'package:advance_employee_management/service/project_service.dart';
import 'package:advance_employee_management/service/task_service.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import 'assign_task.dart';

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
  String name = "";
  bool button = false;
  DateTime when = DateTime.now();
  DepartmentService departmentService = DepartmentService();
  TextEditingController percented = TextEditingController();
  TextEditingController taskDescription = TextEditingController();
  ProjectService projectService = ProjectService();
  EmployeeServices employeeServices = EmployeeServices();
  TaskService taskService = TaskService();

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
  num percent = 0;
  DateTime selectedStartDate = DateTime.now();
  DateTime selectedEndDate = DateTime.now();
  bool loading = true;

  List<dynamic> members = [];
  List<dynamic> memberName = [];
  List<TaskModel> tasks = [];

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
  isLoading() {
    Future.delayed(const Duration(seconds: 1), () {
      if (mounted) {
        setState(() {
          loading = false;
        });
      }
    });
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
      end.text = "${selectedEndDate.toLocal()}".split(' ')[0];
    }
    setState(() {});
  }

  Future<void> _dialogCall(BuildContext context, String memberid,
      String projectid, num percent, List<TaskModel> list, String managerid) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AssignTask(
              projectName: proName.text,
              memberid: memberid,
              projectid: projectid,
              percent: percent,
              list: tasks,
              managerid: widget.managerid);
        });
  }

  getAllTask() async {
    percent = await taskService.getComplete(widget.projectid);
    print(percent);
    tasks = await taskService.getAllTask(widget.projectid);
    setState(() {});
  }

  getManagerName() async {
    managerName = await employeeServices.getEmployeeNamebyID(widget.managerid);
    setState(() {});
  }

  Future<void> _dialogAddMember(BuildContext context) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AddMember(
              managerID: widget.managerid,
              proID: proID.text,
              proName: proName.text,
              members: members,
              memberName: memberName,
              managerName: managerName);
        });
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
    getAllTask();
    getMemberName(members);
    getManagerName();
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
    isLoading();
    TableProvider projectProvider = Provider.of<TableProvider>(
      context,
    );
    return loading == false
        ? Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.purpleAccent[400],
              title: const Text('Project Information'),
            ),
            body: SingleChildScrollView(
              physics: const ScrollPhysics(),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 40, horizontal: 50),
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
                            titlebox("Project Title:"),
                            textItem("Project Name", proName, false, false),
                            titlebox("Project ID:"),
                            textItem("Project ID", proID, false, false),
                            titlebox("Start Day:"),
                            Row(
                              children: [
                                textItem(start.text, start, false, false),
                                const SizedBox(
                                  width: 5,
                                ),
                                isEditStart == true
                                    ? IconButton(
                                        onPressed: () =>
                                            _selectStartDate(context),
                                        icon: const Icon(
                                            Icons.calendar_today_outlined))
                                    : Container(
                                        width: 40,
                                      ),
                              ],
                            ),
                            titlebox("End Day:"),
                            Row(
                              children: [
                                textItem(end.text, end, false, false),
                                const SizedBox(
                                  width: 5,
                                ),
                                isEditEnd == true
                                    ? IconButton(
                                        onPressed: () =>
                                            _selectEndDate(context),
                                        icon: const Icon(
                                            Icons.calendar_today_outlined))
                                    : Container(
                                        width: 40,
                                      ),
                              ],
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                titlebox("Description:"),
                                const SizedBox(height: 10),
                                isEditDes == true
                                    ? descriptionProject(description, true)
                                    : descriptionProject(description, false),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(
                          width: 50,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                titlebox("Department:"),
                                const SizedBox(
                                  width: 20,
                                ),
                                titlebox(departmentName)
                              ],
                            ),
                            Row(
                              children: [
                                titlebox("Status:"),
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
                                titlebox("Complete:"),
                                const SizedBox(
                                  width: 40,
                                ),
                                Text(
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
                            titlebox("Members:"),
                            SizedBox(
                              width: 600,
                              child: Column(children: [
                                Row(
                                  children: [
                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        for (int i = 1;
                                            i <= members.length;
                                            i++)
                                          titlebox2(i.toString() + ". "),
                                      ],
                                    ),
                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        for (var member in members)
                                          titlebox2("ID: " + member),
                                      ],
                                    ),
                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        for (var name in memberName)
                                          titlebox2("  Name: " + name),
                                      ],
                                    ),
                                    isEdit == false
                                        ? Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              for (int i = 0;
                                                  i < members.length;
                                                  i++)
                                                Container(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 10),
                                                  child: Row(
                                                    children: [
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                    .only(
                                                                top: 10,
                                                                bottom: 10),
                                                        child: TextButton.icon(
                                                            onPressed:
                                                                () async {
                                                              if (status !=
                                                                  "Finish") {
                                                                await _dialogCall(
                                                                    context,
                                                                    members[i],
                                                                    proID.text,
                                                                    percent,
                                                                    tasks,
                                                                    managerID);
                                                              }
                                                            },
                                                            icon: const Icon(
                                                                Icons
                                                                    .assessment),
                                                            label: const Text(
                                                                "Assign Task")),
                                                      ),
                                                      const SizedBox(
                                                        width: 10,
                                                      ),
                                                      const SizedBox(
                                                        height: 10,
                                                      ),
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                    .only(
                                                                top: 10,
                                                                bottom: 10),
                                                        child: TextButton.icon(
                                                            onPressed: () {
                                                              if (status !=
                                                                  "Finish") {
                                                                setState(() {
                                                                  ProjectService
                                                                      projectService =
                                                                      ProjectService();

                                                                  taskService
                                                                      .removeAllTasknwithMemberID(
                                                                          members[
                                                                              i]);
                                                                  projectService
                                                                      .removeMember(
                                                                          members[
                                                                              i],
                                                                          proID
                                                                              .text);
                                                                  members.remove(
                                                                      members[
                                                                          i]);
                                                                  memberName.remove(
                                                                      memberName[
                                                                          i]);
                                                                });
                                                              } else {
                                                                dialog(
                                                                    DialogType
                                                                        .INFO,
                                                                    "You can not edit project",
                                                                    "Because this project have already finished");
                                                              }
                                                            },
                                                            icon: const Icon(
                                                                Icons.delete),
                                                            label: const Text(
                                                                "Delete")),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                            ],
                                          )
                                        : Container()
                                  ],
                                ),
                              ]),
                            ),
                            isEdit == false
                                ? Column(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      TextButton.icon(
                                          onPressed: () {
                                            if (status != "Finish") {
                                              setState(() {
                                                _dialogAddMember(context);
                                              });
                                            } else {
                                              dialog(
                                                  DialogType.INFO,
                                                  "You can not edit project",
                                                  "Because this project have already finished");
                                            }
                                          },
                                          icon: const Icon(Icons.add),
                                          label: const Text("Add member"))
                                    ],
                                  )
                                : Container()
                          ],
                        ),
                        const SizedBox(
                          width: 80,
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            IconButton(
                                onPressed: () {
                                  if (status == "Finish") {
                                    dialog(DialogType.INFO, "Request Denied",
                                        "You can not edit the project");
                                  } else {
                                    setState(() {
                                      isEdit = !isEdit;
                                      isEditDes = !isEditDes;
                                      isEditEnd = !isEditEnd;
                                      isEditStart = !isEditStart;
                                      isEditStatus = !isEditStatus;
                                      isEditComplete = !isEditComplete;
                                    });
                                  }
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
                    isEdit == false
                        ? const Text(
                            "Project's Tasks",
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          )
                        : Container(),
                    Column(
                      children: <Widget>[
                        isEdit == false
                            ? tasks.isNotEmpty
                                ? Container(
                                    margin: const EdgeInsets.all(20),
                                    padding: const EdgeInsets.only(bottom: 50),
                                    child: Table(
                                      defaultColumnWidth:
                                          const FixedColumnWidth(200.0),
                                      border: TableBorder.all(
                                          color: Colors.black,
                                          style: BorderStyle.solid,
                                          width: 2),
                                      children: [
                                        TableRow(children: [
                                          Column(children: const [
                                            SizedBox(
                                              height: 5,
                                            ),
                                            Text('Description',
                                                style:
                                                    TextStyle(fontSize: 20.0)),
                                            SizedBox(
                                              height: 5,
                                            ),
                                          ]),
                                          Column(children: const [
                                            SizedBox(
                                              height: 5,
                                            ),
                                            Text('Member Id',
                                                style:
                                                    TextStyle(fontSize: 20.0)),
                                            SizedBox(
                                              height: 5,
                                            )
                                          ]),
                                          Column(children: const [
                                            SizedBox(
                                              height: 5,
                                            ),
                                            Text('Assign Day',
                                                style:
                                                    TextStyle(fontSize: 20.0)),
                                            SizedBox(
                                              height: 5,
                                            )
                                          ]),
                                          Column(children: const [
                                            SizedBox(
                                              height: 5,
                                            ),
                                            Text('Status',
                                                style:
                                                    TextStyle(fontSize: 20.0)),
                                            SizedBox(
                                              height: 5,
                                            )
                                          ]),
                                          Column(children: const [
                                            SizedBox(
                                              height: 5,
                                            ),
                                            Text('Percent(%)',
                                                style:
                                                    TextStyle(fontSize: 20.0)),
                                            SizedBox(
                                              height: 5,
                                            )
                                          ]),
                                        ]),
                                        for (var item in tasks.reversed)
                                          TableRow(children: [
                                            Column(children: [
                                              const SizedBox(
                                                height: 5,
                                              ),
                                              Text(item.description),
                                              const SizedBox(
                                                height: 5,
                                              )
                                            ]),
                                            Column(
                                              children: [
                                                const SizedBox(
                                                  height: 5,
                                                ),
                                                Text(item.memberid),
                                                const SizedBox(
                                                  height: 5,
                                                )
                                              ],
                                            ),
                                            Column(
                                              children: [
                                                const SizedBox(
                                                  height: 5,
                                                ),
                                                Text(DateFormat(
                                                        "dd/MM/yyyy,HH:mm")
                                                    .format(DateTime
                                                        .fromMillisecondsSinceEpoch(
                                                            item.assignday))),
                                                const SizedBox(
                                                  height: 5,
                                                )
                                              ],
                                            ),
                                            Column(
                                              children: [
                                                const SizedBox(
                                                  height: 5,
                                                ),
                                                Text(item.status),
                                                const SizedBox(
                                                  height: 5,
                                                )
                                              ],
                                            ),
                                            Column(
                                              children: [
                                                const SizedBox(
                                                  height: 5,
                                                ),
                                                Text(item.percent.toString()),
                                                const SizedBox(
                                                  height: 5,
                                                )
                                              ],
                                            ),
                                          ]),
                                      ],
                                    ),
                                  )
                                : const Text("(There is no task)")
                            : Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Container(
                                    padding: const EdgeInsets.only(left: 200),
                                    child: Row(
                                      children: [
                                        TextButton.icon(
                                            onPressed: () {
                                              projectService
                                                  .deleteProject(proID.text);

                                              departmentService.removeProject(
                                                  departmentName, proID.text);
                                              for (Map<String, dynamic> project
                                                  in projectProvider
                                                      .projectSource) {
                                                if (project.values
                                                        .elementAt(0) ==
                                                    proID.text) {
                                                  setState(() {
                                                    projectProvider
                                                        .projectSource
                                                        .remove(project);
                                                  });
                                                }
                                              }
                                              Navigator.pop(context);
                                              AuthClass().showSnackBar(
                                                  context, "Delete Success");
                                            },
                                            icon: const Icon(Icons.delete),
                                            label: const Text("Delete")),
                                        TextButton.icon(
                                            onPressed: () {
                                              if (description.text.isNotEmpty) {
                                                if (status == "Finish" &&
                                                    int.parse(complete.text) <
                                                        100) {
                                                  AuthClass().showSnackBar(
                                                      context,
                                                      "Your project completion is not reached 100 %. So you can not change the status to complete");
                                                } else {
                                                  ProjectService
                                                      projectService =
                                                      ProjectService();
                                                  Map<String, dynamic> map =
                                                      <String, dynamic>{};
                                                  map.addAll({
                                                    "id": proID.text,
                                                    "name": proName.text,
                                                    "start": start.text,
                                                    "end": end.text,
                                                    "status": status,
                                                    "complete": int.parse(
                                                        complete.text),
                                                    "members": members,
                                                    "manager": widget.managerid,
                                                    "department":
                                                        departmentName,
                                                    "description":
                                                        description.text,
                                                  });
                                                  projectService.updateProject(
                                                      proID.text, map);
                                                  setState(() {
                                                    for (Map<String,
                                                            dynamic> project
                                                        in projectProvider
                                                            .projectSource) {
                                                      if (project.values
                                                              .elementAt(0) ==
                                                          proID.text) {
                                                        project.update(
                                                            "id",
                                                            (value) =>
                                                                proID.text);
                                                        project.update(
                                                            "name",
                                                            (value) =>
                                                                proName.text);
                                                        project.update(
                                                            "start",
                                                            (value) =>
                                                                start.text);
                                                        project.update(
                                                            "end",
                                                            (value) =>
                                                                end.text);
                                                        project.update("status",
                                                            (value) => status);
                                                        project.update(
                                                            "complete",
                                                            (value) => [
                                                                  int.parse(
                                                                      complete
                                                                          .text),
                                                                  100
                                                                ]);
                                                        project.update(
                                                            "members",
                                                            (value) => members);
                                                        project.update(
                                                            "manager",
                                                            (value) => widget
                                                                .managerid);
                                                        project.update(
                                                            "department",
                                                            (value) =>
                                                                departmentName);
                                                        project.update(
                                                            "description",
                                                            (value) =>
                                                                description
                                                                    .text);
                                                        project.update(
                                                            "action",
                                                            (value) => [
                                                                  proID.text,
                                                                  null
                                                                ]);
                                                      }
                                                    }
                                                  });

                                                  locator<NavigationService>()
                                                      .navigateTo(
                                                          ProjectPageRoute);
                                                  AuthClass().showSnackBar(
                                                      context,
                                                      "Update Success");
                                                }
                                              } else {
                                                AuthClass().showSnackBar(
                                                    context,
                                                    "Please fill the description!!");
                                              }
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
            ))
        : Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: const [
              SizedBox(
                width: 50,
                height: 50,
                child: CircularProgressIndicator(),
              ),
            ],
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

  Widget descriptionProject(TextEditingController desciption, bool enable) {
    return Container(
      height: 200,
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
          width: 15,
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
          width: 15,
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
          width: 15,
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
