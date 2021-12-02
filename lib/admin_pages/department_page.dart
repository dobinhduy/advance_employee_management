import 'package:advance_employee_management/admin_pages/add_department_dialog.dart';
import 'package:advance_employee_management/admin_pages/page_header.dart';
import 'package:advance_employee_management/provider/table_provider.dart';
import 'package:advance_employee_management/service/auth_services.dart';
import 'package:advance_employee_management/service/department_service.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:responsive_table/responsive_table.dart';

class DepartmentPage extends StatefulWidget {
  const DepartmentPage({Key? key}) : super(key: key);

  @override
  _DepartmentPageState createState() => _DepartmentPageState();
}

class _DepartmentPageState extends State<DepartmentPage> {
  final TextEditingController id = TextEditingController();
  final TextEditingController phone = TextEditingController();
  final TextEditingController email = TextEditingController();
  final TextEditingController name = TextEditingController();
  DepartmentService departmentService = DepartmentService();
  final AuthClass authClass = AuthClass();

  String establishday = "";
  Future<void> _dialogAddDepartment(BuildContext context) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AddDepartment(
            email: email,
            id: id,
            name: name,
            phone: phone,
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    TableProvider departmentProvider = Provider.of<TableProvider>(context);
    return SingleChildScrollView(
        child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            children: [
          const PageHeader(
            text: 'Department Table',
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
                headers: departmentProvider.departmentHeaders,
                source: departmentProvider.departmentSource,
                selecteds: departmentProvider.selecteds,
                showSelect: departmentProvider.showSelect,
                autoHeight: false,
                title: !departmentProvider.isSearch
                    ? Row(
                        children: [
                          ElevatedButton.icon(
                              onPressed: () {
                                _dialogAddDepartment(context);
                              },
                              icon: const Icon(
                                Icons.delete,
                              ),
                              label: const Text("ADD DEPARTMENT")),
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
                  if (departmentProvider.isSearch)
                    Expanded(
                        child: TextField(
                      decoration: InputDecoration(
                          prefixIcon: IconButton(
                              icon: const Icon(Icons.cancel),
                              onPressed: () {
                                setState(() {
                                  departmentProvider.isSearch = false;
                                });
                              }),
                          suffixIcon: IconButton(
                              icon: const Icon(Icons.search),
                              onPressed: () {})),
                    )),
                  if (!departmentProvider.isSearch)
                    IconButton(
                        icon: const Icon(Icons.search),
                        onPressed: () {
                          setState(() {
                            departmentProvider.isSearch = true;
                          });
                        })
                ],
                onTabRow: (data) {
                  // Map<String, dynamic> map =
                  //     Map<String, dynamic>.from(data as Map<String, dynamic>);
                  // Navigator.push(
                  //     context,
                  //     MaterialPageRoute(
                  //         builder: (context) => UserInforPage(
                  //               id: map.values.elementAt(0),
                  //               name: map.values.elementAt(1),
                  //               gender: map.values.elementAt(2),
                  //               birthday: map.values.elementAt(3),
                  //               email: map.values.elementAt(4),
                  //               address: map.values.elementAt(5),
                  //               phone: map.values.elementAt(6),
                  //               photoURL: map.values.elementAt(7),
                  //               position: map.values.elementAt(8),
                  //             )));
                },
                onSort: departmentProvider.onSort,
                sortAscending: departmentProvider.sortAscending,
                sortColumn: departmentProvider.sortColumn,
                isLoading: departmentProvider.isLoading,
                onSelect: departmentProvider.onSelect,
                onSelectAll: departmentProvider.onSelectAllDepartment,
                footers: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: const Text("Rows per page:"),
                  ),
                  // ignore: unnecessary_null_comparison
                  if (departmentProvider.perPages != null)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      child: DropdownButton(
                          value: departmentProvider.currentPerPage,
                          items: departmentProvider.perPages
                              .map((e) => DropdownMenuItem(
                                    child: Text("$e"),
                                    value: e,
                                  ))
                              .toList(),
                          onChanged: (value) {
                            int? num = value as int?;
                            departmentProvider.onChange(num!);
                          }),
                    ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: Text(
                        "${departmentProvider.currentPage} - ${departmentProvider.currentPerPage} of ${departmentProvider.total}"),
                  ),
                  IconButton(
                    icon: const Icon(
                      Icons.arrow_back_ios,
                      size: 16,
                    ),
                    onPressed: departmentProvider.previous,
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                  ),
                  IconButton(
                    icon: const Icon(Icons.arrow_forward_ios, size: 16),
                    onPressed: departmentProvider.next,
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                  )
                ],
              ),
            ),
          ),
        ]));
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
        for (var department in provider.selecteds) {
          departmentService.deleteDepartment(department["id"]);
        }

        setState(() {
          provider.delectDepartment(provider.selecteds);
          provider.isSelect == false;
        });
      },
    )..show();
  }
}
