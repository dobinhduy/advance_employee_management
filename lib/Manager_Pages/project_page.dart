import 'package:advance_employee_management/Manager_Pages/add_project_page.dart';
import 'package:advance_employee_management/Manager_Pages/modify_project_page.dart';
import 'package:advance_employee_management/admin_pages/page_header.dart';
import 'package:advance_employee_management/models/project.dart';
import 'package:advance_employee_management/provider/table_provider.dart';
import 'package:advance_employee_management/provider/theme_provider.dart';
import 'package:advance_employee_management/service/auth_services.dart';
import 'package:advance_employee_management/service/employee_service.dart';
import 'package:advance_employee_management/service/project_service.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:responsive_table/ResponsiveDatatable.dart';

class ProjectPage extends StatefulWidget {
  const ProjectPage({Key? key}) : super(key: key);

  @override
  _ProjectPageState createState() => _ProjectPageState();
}

class _ProjectPageState extends State<ProjectPage> {
  bool loading = true;
  String email = AuthClass().user()!;
  ProjectService projectService = ProjectService();
  EmployeeServices employeeServices = EmployeeServices();
  List<ProjectModel> projectOfManager = <ProjectModel>[];
  List<Map<String, dynamic>> projectOfManagerSource = <Map<String, dynamic>>[];
  String id = "";
  loadProjectOfManager() async {
    id = await employeeServices.getEmployeeIDbyEmail(email);
    projectOfManager = await projectService.getAllProjectOfManager(id);
    projectOfManagerSource.addAll(_getProjectOfDataManager());
    setState(() {});
  }

  isLoading() {
    Future.delayed(const Duration(seconds: 1), () {
      setState(() {
        loading = false;
      });
    });
  }

  delectProjecteOfManager(List<Map<String, dynamic>> list) {
    for (Map<String, dynamic> item in list) {
      projectOfManagerSource.remove(item);
    }
  }

  @override
  void initState() {
    super.initState();
    isLoading();
    loadProjectOfManager();
  }

  List<Map<String, dynamic>> _getProjectOfDataManager() {
    List<Map<String, dynamic>> temps = <Map<String, dynamic>>[];

    for (ProjectModel project in projectOfManager) {
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

  @override
  Widget build(BuildContext context) {
    TableProvider projectProvider = Provider.of<TableProvider>(context);
    ThemeProvider themeProvider = Provider.of<ThemeProvider>(context);

    return loading == false
        ? SingleChildScrollView(
            child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.max,
                children: [
                const PageHeader(
                  text: '  Project Table',
                ),
                Container(
                  constraints: const BoxConstraints(
                    maxHeight: 745,
                  ),
                  child: Card(
                    elevation: 1,
                    shadowColor: Colors.black,
                    clipBehavior: Clip.none,
                    child: ResponsiveDatatable(
                      headers: projectProvider.projectHeaders,
                      source: projectOfManagerSource,
                      selecteds: projectProvider.selecteds,
                      showSelect: projectProvider.showSelect,
                      autoHeight: false,
                      title: !projectProvider.isSearch
                          ? Row(
                              children: [
                                ElevatedButton.icon(
                                    onPressed: () {
                                      _openAddEntryDialog();
                                    },
                                    icon: const Icon(
                                      Icons.delete,
                                    ),
                                    label: const Text("ADD PROJECT")),
                                const SizedBox(
                                  width: 30,
                                ),
                                ElevatedButton.icon(
                                  onPressed: () {
                                    dialog(
                                      DialogType.QUESTION,
                                      "Are you sure",
                                      "",
                                    );
                                  },
                                  icon: const Icon(
                                    Icons.delete_forever,
                                  ),
                                  label: const Text("DELETE"),
                                ),
                              ],
                            )
                          : null,
                      actions: [
                        if (projectProvider.isSearch)
                          Expanded(
                              child: TextField(
                            decoration: InputDecoration(
                                prefixIcon: IconButton(
                                    icon: const Icon(Icons.cancel),
                                    onPressed: () {
                                      setState(() {
                                        projectProvider.isSearch = false;
                                      });
                                    }),
                                suffixIcon: IconButton(
                                    icon: const Icon(Icons.search),
                                    onPressed: () {})),
                          )),
                        if (!projectProvider.isSearch)
                          IconButton(
                              icon: const Icon(Icons.search),
                              onPressed: () {
                                setState(() {
                                  projectProvider.isSearch = true;
                                });
                              })
                      ],
                      onTabRow: (data) {
                        Map<String, dynamic> map = Map<String, dynamic>.from(
                            data as Map<String, dynamic>);
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ModifyProjectPage(
                                      projectid: map.values.elementAt(0),
                                      projectName: map.values.elementAt(1),
                                      startDay: map.values.elementAt(2),
                                      endDay: map.values.elementAt(3),
                                      status: map.values.elementAt(4),
                                      complete: map.values.elementAt(5),
                                      member: map.values.elementAt(6),
                                      managerid: map.values.elementAt(7),
                                      department: map.values.elementAt(8),
                                      description: map.values.elementAt(9),
                                    )));
                      },
                      onSort: projectProvider.onSort,
                      sortAscending: projectProvider.sortAscending,
                      sortColumn: projectProvider.sortColumn,
                      isLoading: projectProvider.isLoading,
                      onSelect: projectProvider.onSelect,
                      onSelectAll: projectProvider.onSelectAllProject,
                      footers: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 15),
                          child: const Text("Rows per page:"),
                        ),
                        // ignore: unnecessary_null_comparison
                        if (projectProvider.perPages != null)
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 15),
                            child: DropdownButton(
                                value: projectProvider.currentPerPage,
                                items: projectProvider.perPages
                                    .map((e) => DropdownMenuItem(
                                          child: Text("$e"),
                                          value: e,
                                        ))
                                    .toList(),
                                onChanged: (value) {
                                  int? num = value as int?;
                                  projectProvider.onChange(num!);
                                }),
                          ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 15),
                          child: Text(
                              "${projectProvider.currentPage} - ${projectProvider.currentPerPage} of ${projectProvider.total}"),
                        ),
                        IconButton(
                          icon: const Icon(
                            Icons.arrow_back_ios,
                            size: 16,
                          ),
                          onPressed: projectProvider.previous,
                          padding: const EdgeInsets.symmetric(horizontal: 15),
                        ),
                        IconButton(
                          icon: const Icon(Icons.arrow_forward_ios, size: 16),
                          onPressed: projectProvider.next,
                          padding: const EdgeInsets.symmetric(horizontal: 15),
                        )
                      ],
                    ),
                  ),
                ),
              ]))
        : Container(
            color: themeProvider.isLightMode ? Colors.white : Colors.brown,
            child: const Center(
                child: SpinKitPouringHourGlass(
              color: Colors.orangeAccent,
            )),
          );
  }

  void _openAddEntryDialog() {
    Navigator.of(context).push(MaterialPageRoute<void>(
        builder: (BuildContext context) {
          return const AddProjectPage();
        },
        fullscreenDialog: true));
  }

  AwesomeDialog dialog(DialogType type, String title, String description) {
    TableProvider provider = Provider.of<TableProvider>(context, listen: false);
    return AwesomeDialog(
      context: context,
      width: 600,
      dialogType: type,
      animType: AnimType.LEFTSLIDE,
      title: title,
      desc: description,
      btnCancelOnPress: () {
        setState(() {});
      },
      btnOkOnPress: () {
        for (var project in provider.selecteds) {
          projectService.deleteProject(project["id"]);
        }

        setState(() {
          for (Map<String, dynamic> item in provider.selecteds) {
            projectOfManagerSource.remove(item);
            provider.isSelect == false;
          }
        });
        EasyLoading.showSuccess('Delete Success!');
      },
    )..show();
  }
}
