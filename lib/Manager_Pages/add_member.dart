import 'package:advance_employee_management/service/auth_services.dart';
import 'package:advance_employee_management/service/employee_service.dart';
import 'package:advance_employee_management/service/notification_service.dart';
import 'package:advance_employee_management/service/project_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:uuid/uuid.dart';

// ignore: must_be_immutable
class AddMember extends StatefulWidget {
  AddMember(
      {Key? key,
      required this.managerID,
      required this.proID,
      required this.proName,
      required this.members,
      required this.memberName,
      required this.managerName})
      : super(key: key);
  final String managerID;
  final String proID;
  final String proName;
  final String managerName;
  List<dynamic> members;
  List<dynamic> memberName;
  @override
  _AddMemberState createState() => _AddMemberState();
}

class _AddMemberState extends State<AddMember> {
  TextEditingController id = TextEditingController();
  String message = "";
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      insetPadding: const EdgeInsets.symmetric(vertical: 250),
      title: const Text("Add Member"),
      content: SizedBox(
        child: Row(
          children: [
            Column(
              children: <Widget>[
                SizedBox(
                  width: 300,
                  child: TextField(
                    controller: id,
                    decoration: const InputDecoration(
                      icon: Icon(
                        Icons.vpn_key_rounded,
                      ),
                      labelText: 'Member ID',
                    ),
                  ),
                ),
                const SizedBox(
                  height: 5,
                ),
                Text("" + message,
                    style: const TextStyle(
                      color: Colors.red,
                    )),
              ],
            ),
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
            onPressed: () async {
              DateTime now = DateTime.now();
              EmployeeServices employeeServices = EmployeeServices();
              ProjectService projectService = ProjectService();
              NotificationService notificationService = NotificationService();

              bool isExist =
                  await employeeServices.checkExistEmployeebyID(id.text);
              if (isExist) {
                String supID = await employeeServices.getSupervisorID(id.text);

                if (supID == widget.managerID) {
                  String employeeName =
                      await employeeServices.getEmployeeNamebyID(id.text);

                  if (mounted) {
                    setState(() {
                      projectService.addMember(id.text, widget.proID);
                      widget.members.add(id.text);
                      widget.memberName.add(employeeName);
                    });
                  }
                  notificationService.createNotification(
                      const Uuid().v4(),
                      widget.managerID,
                      id.text,
                      now.millisecondsSinceEpoch,
                      false,
                      "You was add to new project: " + widget.proName);
                  Navigator.pop(context);
                  await EasyLoading.showSuccess('Add Success!');
                  if (mounted) {
                    setState(() {});
                  }
                } else {
                  AuthClass().showSnackBar(
                      context, "This employee is not belong to you");
                  Navigator.of(context).pop();
                }
              } else {
                AuthClass().showSnackBar(context, "Employee is not exist");
                Navigator.of(context).pop();
              }
            },
            child: const Text(
              "Add",
              style: TextStyle(fontSize: 20),
            )),
      ],
    );
  }
}
