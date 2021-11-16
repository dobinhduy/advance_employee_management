import 'dart:math';

import 'package:advance_employee_management/pages/Admin_Manager_page/manager_information_page.dart';
import 'package:advance_employee_management/pages/PageHeader/page_header.dart';
import 'package:advance_employee_management/provider/table_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:responsive_table/responsive_table.dart';

class ManagerPage extends StatefulWidget {
  const ManagerPage({Key? key}) : super(key: key);

  @override
  _ManagerPageState createState() => _ManagerPageState();
}

class _ManagerPageState extends State<ManagerPage> {
  @override
  Widget build(BuildContext context) {
    TableProvider managersProvider = Provider.of<TableProvider>(context);
    return SingleChildScrollView(
        child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            children: [
          const PageHeader(
            text: 'Manager table',
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
                headers: managersProvider.managerHeaders,
                source: managersProvider.managerSource,
                selecteds: managersProvider.selecteds,
                showSelect: managersProvider.showSelect,
                autoHeight: false,
                title: !managersProvider.isSearch
                    ? ElevatedButton.icon(
                        onPressed: () {},
                        icon: const Icon(Icons.add),
                        label: const Text("ADD CATEGORY"))
                    : null,
                actions: [
                  if (managersProvider.isSearch)
                    Expanded(
                        child: TextField(
                      decoration: InputDecoration(
                          prefixIcon: IconButton(
                              icon: const Icon(Icons.cancel),
                              onPressed: () {
                                setState(() {
                                  managersProvider.isSearch = false;
                                });
                              }),
                          suffixIcon: IconButton(
                              icon: const Icon(Icons.search),
                              onPressed: () {})),
                    )),
                  if (!managersProvider.isSearch)
                    IconButton(
                        icon: const Icon(Icons.search),
                        onPressed: () {
                          setState(() {
                            managersProvider.isSearch = true;
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
                          builder: (context) => ManagerInPage(
                                gender: map.values.elementAt(2),
                                phone: map.values.elementAt(6),
                                name: map.values.elementAt(1),
                                email: map.values.elementAt(4),
                                id: map.values.elementAt(0),
                                birthday: map.values.elementAt(3),
                                address: map.values.elementAt(5),
                                photoURL: map.values.elementAt(7),
                                position: map.values.elementAt(8),
                              )));
                },
                onSort: managersProvider.onSort,
                sortAscending: managersProvider.sortAscending,
                sortColumn: managersProvider.sortColumn,
                isLoading: managersProvider.isLoading,
                onSelect: managersProvider.onSelect,
                onSelectAll: managersProvider.onSelectAll,
                footers: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: const Text("Rows per page:"),
                  ),
                  // ignore: unnecessary_null_comparison
                  if (managersProvider.perPages != null)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      child: DropdownButton(
                          value: managersProvider.currentPerPage,
                          items: managersProvider.perPages
                              .map((e) => DropdownMenuItem(
                                    child: Text("$e"),
                                    value: e,
                                  ))
                              .toList(),
                          onChanged: (int? value) {
                            setState(() {
                              managersProvider.currentPerPage = value!;
                            });
                          }),
                    ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: Text(
                        "${managersProvider.currentPage} - ${managersProvider.currentPerPage} of ${managersProvider.total}"),
                  ),
                  IconButton(
                    icon: const Icon(
                      Icons.arrow_back_ios,
                      size: 16,
                    ),
                    onPressed: managersProvider.previous,
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                  ),
                  IconButton(
                    icon: const Icon(Icons.arrow_forward_ios, size: 16),
                    onPressed: managersProvider.next,
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                  )
                ],
              ),
            ),
          ),
        ]));
  }
}