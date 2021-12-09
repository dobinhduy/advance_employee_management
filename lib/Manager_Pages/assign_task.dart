import 'package:advance_employee_management/service/auth_services.dart';
import 'package:advance_employee_management/service/notification_service.dart';
import 'package:advance_employee_management/service/task_service.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

class AssignTask extends StatefulWidget {
  const AssignTask(
      {Key? key,
      required this.projectName,
      required this.projectid,
      required this.memberid})
      : super(key: key);
  final String projectName;
  final String projectid;
  final String memberid;

  @override
  _AssignTaskState createState() => _AssignTaskState();
}

class _AssignTaskState extends State<AssignTask> {
  TaskService taskService = TaskService();
  NotificationService notificationService = NotificationService();
  String description = "";
  String percent = "";
  bool button = false;
  String message = "";
  DateTime deadline = DateTime.now();
  bool isNumeric(String s) {
    if (s.isEmpty) {
      return false;
    }
    return double.tryParse(s) != null;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      insetPadding: const EdgeInsets.symmetric(vertical: 150),
      title: const Text("Assign Task"),
      content: SizedBox(
        width: 500,
        height: 500,
        child: Column(
          children: <Widget>[
            SizedBox(
              height: 200,
              width: 400,
              child: TextField(
                maxLines: 7,
                autofocus: true,
                decoration: const InputDecoration(
                    hintText: "Task Description",
                    border: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.teal))),
                onChanged: (value) {
                  description = value;
                },
              ),
            ),
            Row(
              children: [
                const Text("Percent of project: "),
                const SizedBox(
                  width: 10,
                ),
                SizedBox(
                  width: 50,
                  height: 30,
                  child: TextField(
                    autofocus: true,
                    decoration: const InputDecoration(
                        contentPadding: EdgeInsets.only(top: 2, left: 5),
                        border: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.teal))),
                    onChanged: (value) {
                      percent = value;
                    },
                  ),
                ),
                const SizedBox(
                  width: 70,
                ),
                const Text("DeadLine: "),
                const SizedBox(
                  width: 10,
                ),
                ElevatedButton(
                    child: Text(DateFormat("dd/MM/yyyy").format(deadline)),
                    onPressed: () async {
                      DateTime? picked = await showDatePicker(
                        context: context,
                        initialDate: deadline,
                        firstDate: DateTime(2015, 8),
                        lastDate: DateTime(2101),
                      );
                      setState(() {
                        deadline = picked!;
                      });
                    }),
              ],
            ),
            const SizedBox(
              height: 8,
            ),
            Text(
              message,
              style: const TextStyle(color: Colors.red),
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
            child: const Text('Assign'),
            onPressed: () async {
              if (isNumeric(percent)) {
                if (description.isNotEmpty && percent.isNotEmpty) {
                  taskService.createTask(
                      const Uuid().v4(),
                      widget.projectid,
                      DateFormat("dd/MM/yyyy").format(deadline),
                      widget.memberid,
                      description,
                      DateTime.now().millisecondsSinceEpoch,
                      "Uncomplete",
                      int.parse(percent));
                  notificationService.createNewTask(
                      const Uuid().v4(),
                      widget.projectName,
                      widget.memberid,
                      DateTime.now().millisecondsSinceEpoch,
                      false,
                      int.parse(percent),
                      description,
                      "ASSIGNTASK");
                  Navigator.pop(context);
                  AuthClass().showSnackBar(context, "Assign Success");
                  setState(() {});
                } else {
                  message = "Fill all information";
                  setState(() {});
                }
              } else {
                message = "Percent must be a number !!";
                setState(() {});
              }
            }),
      ],
    );
  }
}
