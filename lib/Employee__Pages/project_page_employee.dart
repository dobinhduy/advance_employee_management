import 'package:advance_employee_management/Custom/carditem_custom.dart';
import 'package:advance_employee_management/models/project.dart';
import 'package:advance_employee_management/provider/table_provider.dart';
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
  List<ProjectModel> _employeeProject = <ProjectModel>[];

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
    setisADD();
    int i = 0;
    if (i == 0) {
      getEmployeeProject();
      setState(() {
        i++;
      });
    }

    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 30),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              titlebox("Open Project"),
              Container(
                  height: 3500,
                  width: MediaQuery.of(context).size.width,
                  child: isADD == true
                      ? Wrap(
                          children: [
                            for (var project in _employeeProject)
                              CardItem(
                                  projectname: project.name,
                                  projectid: project.id,
                                  color1: Colors.white,
                                  color2: Colors.pinkAccent,
                                  icon: Icons.book,
                                  startday: project.start,
                                  manager: project.manager,
                                  endday: project.end)
                          ],
                        )
                      : Container()),
            ],
          ),
        ),
      ),
    );
  }

  Widget titlebox(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 22),
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
