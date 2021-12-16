import 'dart:math';

import 'package:advance_employee_management/locator.dart';
import 'package:advance_employee_management/provider/table_provider.dart';
import 'package:advance_employee_management/rounting/route_names.dart';
import 'package:advance_employee_management/service/auth_services.dart';
import 'package:advance_employee_management/service/department_service.dart';
import 'package:advance_employee_management/service/navigation_service.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:provider/provider.dart';

// ignore: must_be_immutable
class AddDepartment extends StatefulWidget {
  AddDepartment({
    Key? key,
    required this.email,
    required this.id,
    required this.name,
    required this.phone,
  }) : super(key: key);

  TextEditingController id;
  TextEditingController name;
  TextEditingController phone;
  TextEditingController email;
  @override
  _AddDepartmentState createState() => _AddDepartmentState();
}

class _AddDepartmentState extends State<AddDepartment> {
  DepartmentService departmentService = DepartmentService();
  DateTime startday = DateTime.now();
  List<String> list = <String>[];
  String randomID = "";
  random() async {
    bool isExist;
    String id = "";
    const _chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
    const _nums = "1234567890";
    Random _rnd = Random();
    String getRandomString(int length) =>
        String.fromCharCodes(Iterable.generate(
            length, (_) => _chars.codeUnitAt(_rnd.nextInt(_chars.length))));
    String getRandomNum(int length) => String.fromCharCodes(Iterable.generate(
        length, (_) => _nums.codeUnitAt(_rnd.nextInt(_nums.length))));
    id = getRandomString(2) + getRandomNum(5);
    isExist = await departmentService.checkUniqueID(id);
    if (!isExist) {
      setState(() {
        randomID = id;
      });
    } else {
      random();
    }
  }

  @override
  Widget build(BuildContext context) {
    TableProvider provider = Provider.of<TableProvider>(context);
    return AlertDialog(
      insetPadding: const EdgeInsets.symmetric(vertical: 150),
      title: const Text("Add Department"),
      content: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Column(
              children: <Widget>[
                SizedBox(
                  width: 300,
                  child: Row(
                    children: [
                      randomBox(),
                      const SizedBox(
                        width: 5,
                      ),
                      ElevatedButton(
                          onPressed: () {
                            random();
                          },
                          child: const Text("Generate"))
                    ],
                  ),
                ),
                const SizedBox(
                  height: 6,
                ),
                SizedBox(
                  width: 300,
                  child: TextField(
                    controller: widget.name,
                    obscureText: false,
                    decoration: const InputDecoration(
                      icon: Icon(Icons.local_fire_department),
                      labelText: 'Department Name',
                    ),
                  ),
                ),
              ],
            ),
            Column(
              children: [
                SizedBox(
                  width: 300,
                  child: TextField(
                    controller: widget.phone,
                    decoration: const InputDecoration(
                      icon: Icon(Icons.phone),
                      labelText: 'Phone Number',
                    ),
                  ),
                ),
                SizedBox(
                  width: 300,
                  child: TextField(
                    controller: widget.email,
                    obscureText: false,
                    decoration: const InputDecoration(
                      icon: Icon(Icons.email_outlined),
                      labelText: 'Email',
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
      actions: <Widget>[
        ElevatedButton(
            child: const Text("CANCEL"),
            onPressed: () {
              Navigator.of(context).pop();
            }),
        ElevatedButton(
            child: const Text('Create'),
            onPressed: () async {
              bool checkID =
                  await departmentService.checkExistDepartment(widget.id.text);
              bool checkName = await departmentService
                  .checkExistDepartmentName(widget.name.text);
              if (checkFillAll()) {
                if (!checkName) {
                  if (!checkID) {
                    setState(() {
                      departmentService.addDepartment(
                          randomID,
                          widget.name.text,
                          widget.email.text,
                          widget.phone.text,
                          list,
                          "${startday.toLocal()}".split(' ')[0]);
                      provider.departmentSource.add({
                        "id": randomID,
                        "name": widget.name.text,
                        "email": widget.email.text,
                        "phone": widget.phone.text,
                        "createday": "${startday.toLocal()}".split(' ')[0],
                      });
                    });
                    Navigator.pop(context);
                    await EasyLoading.showSuccess('Add Success!');
                    locator<NavigationService>().navigateTo(DepartmentLayout);
                  } else {
                    Navigator.pop(context);
                    AuthClass().showSnackBar(
                        context, "Department id is already exist");
                  }
                } else {
                  Navigator.pop(context);
                  AuthClass().showSnackBar(
                      context, "Department name is already exist");
                }
              } else {
                Navigator.pop(context);
                AuthClass().showSnackBar(
                    context, "Please fill all required information!!");
              }
            }),
      ],
    );
  }

  AwesomeDialog dialog(DialogType type, String title, String description) {
    return AwesomeDialog(
      context: context,
      width: 600,
      dialogType: type,
      animType: AnimType.LEFTSLIDE,
      title: title,
      desc: description,
      btnOkOnPress: () {
        Navigator.pop(context);
      },
    )..show();
  }

  Widget randomBox() {
    return SizedBox(
      width: 200,
      height: 40,
      child: TextFormField(
        enabled: false,
        obscureText: true,
        style: const TextStyle(color: Colors.black),
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.only(bottom: 5),
          hintText: randomID,
          icon: const Icon(
            Icons.vpn_key_rounded,
          ),
        ),
      ),
    );
  }

  bool checkFillAll() {
    if (widget.phone.text.isEmpty ||
        randomID.isEmpty ||
        widget.email.text.isEmpty ||
        widget.name.text.isEmpty) {
      return false;
    }
    return true;
  }
}
