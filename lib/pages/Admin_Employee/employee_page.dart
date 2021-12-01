// ignore_for_file: unrelated_type_equality_checks

import 'package:advance_employee_management/pages/Admin_Employee/employee_information_page.dart';
import 'package:advance_employee_management/pages/PageHeader/page_header.dart';
import 'package:advance_employee_management/provider/table_provider.dart';
import 'package:advance_employee_management/service/employee_service.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:responsive_table/ResponsiveDatatable.dart';

class EmployeePage extends StatefulWidget {
  const EmployeePage({Key? key}) : super(key: key);

  @override
  _EmployeePageState createState() => _EmployeePageState();
}

class _EmployeePageState extends State<EmployeePage> {
  bool isOK = false;
  @override
  Widget build(BuildContext context) {
    TableProvider employeeProvider = Provider.of<TableProvider>(context);

    return SingleChildScrollView(
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

                  Map<String, dynamic> map =
                      Map<String, dynamic>.from(data as Map<String, dynamic>);
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
        ]));
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
      child: const Text("Cancel"),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );

    // Create AlertDialog
    AlertDialog alert = AlertDialog(
      title: const Text("Simple Alert"),
      content: const Text("This is an alert message."),
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
        EmployeeServices employeeServices = EmployeeServices();
        for (var employee in provider.selecteds) {
          employeeServices.deleteEmployee(employee["email"]);
        }

        setState(() {
          provider.delectEmployee(provider.selecteds);
          provider.isSelect == false;
        });
      },
    )..show();
  }
}
