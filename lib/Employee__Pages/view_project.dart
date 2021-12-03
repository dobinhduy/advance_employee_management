import 'package:advance_employee_management/models/task.dart';
import 'package:advance_employee_management/service/auth_services.dart';
import 'package:advance_employee_management/service/employee_service.dart';
import 'package:advance_employee_management/service/project_service.dart';
import 'package:advance_employee_management/service/task_service.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ViewProject extends StatefulWidget {
  const ViewProject(
      {Key? key,
      required this.projectName,
      required this.projectid,
      required this.startDay,
      required this.endDay,
      required this.status,
      required this.complete,
      required this.description,
      required this.managerid,
      required this.member,
      required this.department})
      : super(key: key);
  final String projectName;
  final String projectid;
  final String startDay;
  final String endDay;
  final String status;
  final String complete;
  final String description;
  final String managerid;
  final List member;
  final String department;

  @override
  _ViewProjectState createState() => _ViewProjectState();
}

class _ViewProjectState extends State<ViewProject> {
  String email = AuthClass().user()!;
  EmployeeServices employeeServices = EmployeeServices();
  ProjectService projectService = ProjectService();
  TaskService taskService = TaskService();
  String employeeID = "";
  List<dynamic> members = [];
  List<dynamic> memberName = [];
  List<TaskModel>? tasks = [];

  bool timeout = false;
  getEmployeeID() async {
    employeeID = await employeeServices.getEmployeeIDbyEmail(email);
    if (mounted) {
      setState(() {});
    }
  }

  getMemberName(List<dynamic> members) async {
    EmployeeServices employeeServices = EmployeeServices();
    for (var item in members) {
      memberName.add(await employeeServices.getEmployeeNamebyID(item));
    }
    if (mounted) {
      setState(() {});
    }
  }

  void deplay() {
    Future.delayed(const Duration(seconds: 1), () {
      timeout = true;
    });
  }

  getAllTask() async {
    tasks = await taskService.getAllTask(
        widget.projectid, await employeeServices.getEmployeeIDbyEmail(email));

    if (mounted) {
      setState(() {});
    }
  }

  @override
  void initState() {
    super.initState();
    members = widget.member;
    getAllTask();
    getMemberName(members);
  }

  @override
  Widget build(BuildContext context) {
    getAllTask();

    deplay();

    return timeout
        ? Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.purpleAccent[400],
              title: const Text('Project Information'),
            ),
            body: SingleChildScrollView(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 40, horizontal: 50),
                child: SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width,
                        height: 300,
                        color: Colors.blue[100],
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Row(
                              children: [
                                titlebox("Project Title:"),
                                titlebox2(widget.projectName),
                                const SizedBox(
                                  width: 230,
                                ),
                                titlebox("Project ID:"),
                                titlebox2(widget.projectid),
                              ],
                            ),
                            Row(
                              children: [
                                titlebox("Duration:"),
                                titlebox2(widget.startDay.replaceAll("-", "/") +
                                    "-" +
                                    widget.endDay.replaceAll("-", "/")),
                                const SizedBox(
                                  width: 230,
                                ),
                                titlebox("Complete:"),
                                titlebox2(widget.complete),
                              ],
                            ),
                            Row(
                              children: [
                                titlebox("Department:"),
                                titlebox2(widget.department),
                                const SizedBox(
                                  width: 230,
                                ),
                                titlebox("Status:"),
                                titlebox2(widget.status),
                                const SizedBox(
                                  width: 30,
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                titlebox("Members"),
                                const SizedBox(
                                  width: 20,
                                ),
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
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                titlebox("Description"),
                                const SizedBox(height: 10),
                                titlebox2(widget.description),
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
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          titlebox("Your task"),
                          Column(
                            children: [
                              for (TaskModel task in tasks!)
                                task.status == "Uncomplete"
                                    ? taskBox(task, "Mark as Complete",
                                        const Color(0xFF9575CD))
                                    : taskBox(task, "Complete",
                                        const Color(0xFFe0e0e0))
                            ],
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ))
        : SizedBox(
            width: 100,
            height: 100,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: const [
                CircularProgressIndicator(),
              ],
            ));
  }

  Widget taskBox(TaskModel task, String title, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      child: Container(
        color: color,
        width: 500,
        height: 170,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [titlebox("Description: "), titlebox(task.description)],
            ),
            Row(
              children: [
                titlebox("Assign at: " +
                    DateFormat("dd/MM/yyyy,HH:mm").format(
                        DateTime.fromMillisecondsSinceEpoch(task.assignday))),
              ],
            ),
            Row(
              children: [
                titlebox("DeadLine:" + task.deadline),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(right: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          textStyle: const TextStyle(fontSize: 18)),
                      onPressed: () {
                        if (task.status == "Uncomplete") {
                          taskService.updateStatus(task.id, "Complete");
                          projectService.addCompletion(
                              widget.projectid, task.percent);
                        } else {
                          print(
                              "You can not change the status. Try to connect to you manager");
                        }
                      },
                      child: Text(title))
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget titlebox(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 10),
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
}