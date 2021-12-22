import 'package:advance_employee_management/models/task.dart';
import 'package:advance_employee_management/service/notification_service.dart';
import 'package:advance_employee_management/service/task_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

class AssignTask extends StatefulWidget {
  AssignTask(
      {Key? key,
      required this.projectName,
      required this.projectid,
      required this.memberid,
      required this.percent,
      required this.list,
      required this.managerid})
      : super(key: key);
  final String projectName;
  final String projectid;
  final String memberid;
  final num percent;
  final List<TaskModel> list;
  final String managerid;

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
              String id = const Uuid().v4();

              if (description.isNotEmpty && percent.isNotEmpty) {
                if (isNumeric(percent)) {
                  if ((100 - widget.percent) >= num.parse(percent)) {
                    taskService.createTask(
                        id,
                        widget.projectid,
                        DateFormat("dd/MM/yyyy").format(deadline),
                        widget.memberid,
                        description,
                        DateTime.now().millisecondsSinceEpoch,
                        "Uncomplete",
                        int.parse(percent),
                        "",
                        "");
                    TaskModel task = TaskModel(
                        id,
                        widget.projectid,
                        widget.memberid,
                        DateTime.now().millisecondsSinceEpoch,
                        "Uncomplete",
                        DateFormat("dd/MM/yyyy").format(deadline),
                        description,
                        int.parse(percent),
                        "",
                        "");
                    widget.list.add(task);

                    notificationService.createNotification(
                        const Uuid().v4(),
                        widget.managerid,
                        widget.memberid,
                        DateTime.now().millisecondsSinceEpoch,
                        false,
                        "You was assigned a new task in project " +
                            widget.projectName);
                    Navigator.pop(context);
                    await EasyLoading.showSuccess('Assign task success!');
                    if (mounted) {
                      setState(() {});
                    }
                  } else {
                    message = "The percent of this task can not greater than " +
                        (100 - widget.percent).toString();
                    if (mounted) {
                      setState(() {});
                    }
                  }
                } else {
                  message = "Percent must be a number !!";
                  if (mounted) {
                    setState(() {});
                  }
                }
              } else {
                message = "Please, Fill all information";
                if (mounted) {
                  setState(() {});
                }
              }
            }),
      ],
    );
  }
}
