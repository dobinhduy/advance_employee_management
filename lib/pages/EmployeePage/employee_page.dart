// ignore_for_file: unrelated_type_equality_checks

import 'package:advance_employee_management/pages/EmployeePage/employee_information_page.dart';
import 'package:advance_employee_management/pages/PageHeader/page_header.dart';
import 'package:advance_employee_management/provider/table_provider.dart';
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
                title: !employeeProvider.isSearch
                    ? ElevatedButton.icon(
                        onPressed: () {},
                        icon: const Icon(Icons.add),
                        label: const Text("ADD CATEGORY"))
                    : null,
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
                                id: map.values.elementAt(0),
                                name: map.values.elementAt(1),
                                gender: map.values.elementAt(2),
                                birthday: map.values.elementAt(3),
                                email: map.values.elementAt(4),
                                address: map.values.elementAt(5),
                                phone: map.values.elementAt(6),
                                photoURL: map.values.elementAt(7),
                                position: map.values.elementAt(8),
                              )));
                },
                onSort: employeeProvider.onSort,
                sortAscending: employeeProvider.sortAscending,
                sortColumn: employeeProvider.sortColumn,
                isLoading: employeeProvider.isLoading,
                onSelect: employeeProvider.onSelect,
                onSelectAll: employeeProvider.onSelectAll,
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
}
