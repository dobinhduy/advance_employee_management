import 'package:advance_employee_management/Manager_Pages/add_project_page.dart';
import 'package:advance_employee_management/Manager_Pages/modify_project_page.dart';
import 'package:advance_employee_management/pages/PageHeader/page_header.dart';
import 'package:advance_employee_management/provider/table_provider.dart';
import 'package:advance_employee_management/service/project_service.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:responsive_table/ResponsiveDatatable.dart';

class ProjectPage extends StatefulWidget {
  const ProjectPage({Key? key}) : super(key: key);

  @override
  _ProjectPageState createState() => _ProjectPageState();
}

class _ProjectPageState extends State<ProjectPage> {
  @override
  Widget build(BuildContext context) {
    TableProvider projectProvider = Provider.of<TableProvider>(context);
    return SingleChildScrollView(
        child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            children: [
          const PageHeader(
            text: 'Project Table',
          ),
          Container(
            margin: const EdgeInsets.all(5),
            padding: const EdgeInsets.all(0),
            constraints: const BoxConstraints(
              maxHeight: 700,
            ),
            child: Card(
              elevation: 1,
              shadowColor: Colors.black,
              clipBehavior: Clip.none,
              child: ResponsiveDatatable(
                headers: projectProvider.projectHeaders,
                source: projectProvider.projectSource,
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
                              color: Colors.redAccent,
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
                  print(data);

                  Map<String, dynamic> map =
                      Map<String, dynamic>.from(data as Map<String, dynamic>);
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
        ]));
    // return SizedBox(
    //   height: 120,
    //   child: Row(
    //     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
    //     children: [
    //       CardItem(
    //         icon: Icons.monetization_on_outlined,
    //         title: "Revenue",
    //         subtitle: "Revenue this month",
    //         value: "\$ 4,323",
    //         color1: Colors.green.shade700,
    //         color2: Colors.green,
    //       ),
    //       CardItem(
    //         icon: Icons.shopping_basket_outlined,
    //         title: "Products",
    //         subtitle: "Total products on store",
    //         value: "231",
    //         color1: Colors.lightBlueAccent,
    //         color2: Colors.blue,
    //       ),
    //       CardItem(
    //         icon: Icons.delivery_dining,
    //         title: "Orders",
    //         subtitle: "Total orders for this month",
    //         value: "33",
    //         color1: Colors.redAccent,
    //         color2: Colors.red,
    //       ),
    //     ],
    //   ),
    // );
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
        ProjectService projectService = ProjectService();
        for (var employee in provider.selecteds) {
          projectService.deleteProject(employee["email"]);
        }

        setState(() {
          provider.delectProject(provider.selecteds);
          provider.isSelect == false;
        });
      },
    )..show();
  }
}
