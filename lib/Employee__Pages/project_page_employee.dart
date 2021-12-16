import 'package:advance_employee_management/Custom/carditem_custom.dart';
import 'package:advance_employee_management/models/project.dart';
import 'package:advance_employee_management/service/auth_services.dart';
import 'package:advance_employee_management/service/employee_service.dart';
import 'package:advance_employee_management/service/project_service.dart';
import 'package:flutter/material.dart';

class ProjectEmployeePage extends StatefulWidget {
  const ProjectEmployeePage({Key? key}) : super(key: key);

  @override
  _ProjectPageEmployeeState createState() => _ProjectPageEmployeeState();
}

class _ProjectPageEmployeeState extends State<ProjectEmployeePage> {
  String employeeEmail = AuthClass().user()!;
  ProjectService projectService = ProjectService();
  EmployeeServices employeeServices = EmployeeServices();
  List<ProjectModel> _projects = <ProjectModel>[];
  final List<ProjectModel> _employeeProject = <ProjectModel>[];
  final List<ProjectModel> _openproject = <ProjectModel>[];
  final List<ProjectModel> _inprocessproject = <ProjectModel>[];
  final List<ProjectModel> _finishproject = <ProjectModel>[];
  final List<ProjectModel> _closeproject = <ProjectModel>[];

  String memid = "";
  bool isADD = false;
  int i = 0;

  @override
  void initState() {
    super.initState();
    getMemberID(employeeEmail);

    getALLProject();
    getEmployeeProject();
  }

  getALLProject() async {
    _projects = await projectService.getAllProject();
    setState(() {});
  }

  getMemberID(String email) async {
    memid = await employeeServices.getEmployeeIDbyEmail(email);
    setState(() {});
  }

  classifyProject() {
    for (var project in _employeeProject) {
      if (project.status == "Open") {
        _openproject.add(project);
      }
      if (project.status == "In Progress") {
        _inprocessproject.add(project);
      }
      if (project.status == "Finish") {
        _finishproject.add(project);
      }
      if (project.status == "Close") {
        _closeproject.add(project);
      }
    }
    setState(() {});
  }

  getEmployeeProject() {
    for (ProjectModel project in _projects) {
      for (String member in project.members) {
        if (member == memid) {
          _employeeProject.add(project);
        }
      }
    }
    setState(() {});
  }

  setisADD() {
    isADD = true;

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    getEmployeeProject();
    classifyProject();
    setisADD();

    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              titlebox("Open Project"),
              _openproject.isEmpty ? titlebox2("(No data)") : Container(),
              isADD == true
                  ? SizedBox(
                      child: Wrap(
                      children: [
                        for (var project in _openproject)
                          CardItem(
                              project: project,
                              projectname: project.name,
                              projectid: project.id,
                              color1: Colors.white,
                              color2: Colors.pinkAccent,
                              icon: Icons.book,
                              startday: project.start,
                              manager: project.manager,
                              endday: project.end)
                      ],
                    ))
                  : Container(
                      height: 20,
                    ),
              titlebox("In Process Project"),
              _inprocessproject.isEmpty ? titlebox2("(No data)") : Container(),
              isADD == true
                  ? SizedBox(
                      child: Wrap(
                      children: [
                        for (var project in _inprocessproject)
                          CardItem(
                              project: project,
                              projectname: project.name,
                              projectid: project.id,
                              color1: Colors.white,
                              color2: Colors.purpleAccent,
                              icon: Icons.book,
                              startday: project.start,
                              manager: project.manager,
                              endday: project.end)
                      ],
                    ))
                  : Container(
                      height: 20,
                    ),
              titlebox("Finish Project"),
              _finishproject.isEmpty ? titlebox2("(No data)") : Container(),
              isADD == true
                  ? SizedBox(
                      child: Wrap(
                      children: [
                        for (var project in _finishproject)
                          CardItem(
                              project: project,
                              projectname: project.name,
                              projectid: project.id,
                              color1: Colors.white,
                              color2: Colors.orangeAccent,
                              icon: Icons.book,
                              startday: project.start,
                              manager: project.manager,
                              endday: project.end)
                      ],
                    ))
                  : Container(
                      height: 20,
                    ),
              titlebox("Close Project"),
              _closeproject.isEmpty ? titlebox2("(No data)") : Container(),
              isADD == true
                  ? SizedBox(
                      child: Wrap(
                      children: [
                        for (var project in _closeproject)
                          CardItem(
                              project: project,
                              projectname: project.name,
                              projectid: project.id,
                              color1: Colors.white,
                              color2: Colors.blueAccent,
                              icon: Icons.book,
                              startday: project.start,
                              manager: project.manager,
                              endday: project.end)
                      ],
                    ))
                  : Container(
                      height: 20,
                    ),
            ],
          ),
        ),
      ),
    );
  }

  Widget titlebox2(String title) {
    return Padding(
      padding: const EdgeInsets.only(top: 10, left: 40),
      child: Text(
        title,
        style: const TextStyle(
          color: Colors.black,
          fontSize: 13,
          letterSpacing: 0.5,
        ),
      ),
    );
  }

  Widget titlebox(String title) {
    return Padding(
      padding: const EdgeInsets.only(top: 15),
      child: Text(
        title,
        style: const TextStyle(
          color: Colors.black,
          fontSize: 17,
          letterSpacing: 2,
        ),
      ),
    );
  }
}
