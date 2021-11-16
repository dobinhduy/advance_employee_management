import 'package:advance_employee_management/Custom/carditem_custom.dart';
import 'package:advance_employee_management/models/project.dart';
import 'package:advance_employee_management/provider/table_provider.dart';
import 'package:advance_employee_management/service/auth_services.dart';
import 'package:advance_employee_management/service/employee_service.dart';
import 'package:advance_employee_management/service/project_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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
  bool isADD = false;
  int i = 0;

  @override
  void initState() {
    super.initState();

    getALLProject();
    getEmployeeProject();
  }

  getALLProject() async {
    _projects = await projectService.getAllProject();
    setState(() {});
  }

  getEmployeeProject() {
    for (ProjectModel project in _projects) {
      for (String member in project.members) {
        if (member == employeeEmail) {
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
    getEmployeeProject();
    TableProvider projectProvider = Provider.of<TableProvider>(context);

    // for (ProjectModel item in _projects) {
    //   print(item.members);
    // }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 30),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          titlebox("Open Project"),
          isADD == true
              ? Row(
                  children: [
                    for (ProjectModel project in _employeeProject)
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
              : Container()
        ],
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
