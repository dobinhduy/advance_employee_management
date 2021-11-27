// ignore_for_file: unrelated_type_equality_checks

import 'package:advance_employee_management/models/manager.dart';
import 'package:advance_employee_management/pages/Admin_Employee/employee_information_page.dart';
import 'package:advance_employee_management/pages/PageHeader/page_header.dart';
import 'package:advance_employee_management/provider/table_provider.dart';
import 'package:advance_employee_management/service/auth_services.dart';
import 'package:advance_employee_management/service/manager_service.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:responsive_table/ResponsiveDatatable.dart';

class EmployeeOfManagerPage extends StatefulWidget {
  const EmployeeOfManagerPage({Key? key}) : super(key: key);

  @override
  _EmployeeOfManagerPageState createState() => _EmployeeOfManagerPageState();
}

class _EmployeeOfManagerPageState extends State<EmployeeOfManagerPage> {
  bool isOK = false;

  bool loading = true;
  String email = AuthClass().user()!;

  ManagerServices managerServices = ManagerServices();
  ManagerModel? managerInfor;

  isLoading() {
    Future.delayed(const Duration(seconds: 1), () {
      setState(() {
        loading = false;
      });
    });
  }

  @override
  void initState() {
    super.initState();
    isLoading();
  }

  getManager() async {
    managerInfor = await managerServices.getManagerByEmail(AuthClass().user()!);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    getManager();

    TableProvider employeeProvider = Provider.of<TableProvider>(context);

    return loading == false
        ? SingleChildScrollView(
            child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.max,
                children: [
                const PageHeader(
                  text: 'Employee Table',
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
                      headers: employeeProvider.employeeHeaders,
                      source: employeeProvider.employeeSource,
                      selecteds: employeeProvider.selecteds,
                      showSelect: employeeProvider.showSelect,
                      autoHeight: false,
                      title: ElevatedButton.icon(
                        onPressed: () {
                          dialog(
                            DialogType.INFO,
                            "",
                            "Are your sure",
                          );
                        },
                        icon: const Icon(Icons.delete_forever),
                        label: const Text("DELETE"),
                      ),
                      actions: [
                        if (employeeProvider.isSearch)
                          Expanded(
                              child: TextField(
                            decoration: InputDecoration(
                                prefixIcon: IconButton(
                                    icon: const Icon(Icons.cancel),
                                    onPressed: () {
                                      setState(() {
                                        employeeProvider.isSearch = false;
                                      });
                                    }),
                                suffixIcon: IconButton(
                                    icon: const Icon(Icons.search),
                                    onPressed: () {})),
                          )),
                        if (!employeeProvider.isSearch)
                          IconButton(
                              hoverColor: Colors.blueAccent,
                              icon: const Icon(Icons.search),
                              onPressed: () {
                                setState(() {
                                  employeeProvider.isSearch = true;
                                });
                              })
                      ],
                      onTabRow: (data) {
                        print(data);

                        Map<String, dynamic> map = Map<String, dynamic>.from(
                            data as Map<String, dynamic>);
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => UserInforPage(
                                      gender: map.values.elementAt(2),
                                      phone: map.values.elementAt(6),
                                      name: map.values.elementAt(1),
                                      email: map.values.elementAt(4),
                                      id: map.values.elementAt(0),
                                      birthday: map.values.elementAt(3),
                                      address: map.values.elementAt(5),
                                      photoURL: map.values.elementAt(7),
                                      position: map.values.elementAt(8),
                                      department: map.values.elementAt(10),
                                    )));
                      },
                      onSort: employeeProvider.onSort,
                      sortAscending: employeeProvider.sortAscending,
                      sortColumn: employeeProvider.sortColumn,
                      isLoading: employeeProvider.isLoading,
                      onSelect: employeeProvider.onSelect,
                      onSelectAll: employeeProvider.onSelectAllEmployee,
                      footers: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 15),
                          child: const Text("Rows per page:"),
                        ),
                        // ignore: unnecessary_null_comparison
                        if (employeeProvider.perPages != null)
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 15),
                            child: DropdownButton(
                                value: employeeProvider.currentPerPage,
                                items: employeeProvider.perPages
                                    .map((e) => DropdownMenuItem(
                                          child: Text("$e"),
                                          value: e,
                                        ))
                                    .toList(),
                                onChanged: (value) {
                                  int? num = value as int?;
                                  employeeProvider.onChange(num!);
                                }),
                          ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 15),
                          child: Text(
                              "${employeeProvider.currentPage} - ${employeeProvider.currentPerPage} of ${employeeProvider.total}"),
                        ),
                        IconButton(
                          icon: const Icon(
                            Icons.arrow_back_ios,
                            size: 16,
                          ),
                          onPressed: employeeProvider.previous,
                          padding: const EdgeInsets.symmetric(horizontal: 15),
                        ),
                        IconButton(
                          icon: const Icon(Icons.arrow_forward_ios, size: 16),
                          onPressed: employeeProvider.next,
                          padding: const EdgeInsets.symmetric(horizontal: 15),
                        )
                      ],
                    ),
                  ),
                ),
              ]))
        : const SizedBox(
            child: Center(child: CircularProgressIndicator()),
            width: 50,
            height: 50,
          );
  }

  showAlertDialog(BuildContext context, Function function) {
    // Create button
    Widget okButton = TextButton(
      child: const Text("OK"),
      onPressed: () {
        function;
        Navigator.of(context).pop();
      },
    );
    Widget cancelButton = TextButton(
      child: Text("Cancel"),
      onPressed: () {
        print("cancel");
        Navigator.of(context).pop();
      },
    );

    // Create AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Simple Alert"),
      content: Text("This is an alert message."),
      actions: [okButton, cancelButton],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
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
        provider.delectEmployee(provider.selecteds);
        setState(() {
          provider.isSelect == false;
        });
      },
    )..show();
  }
}