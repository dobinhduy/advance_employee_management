// ignore: avoid_web_libraries_in_flutter
import 'dart:html';

import 'package:advance_employee_management/models/task.dart';
import 'package:advance_employee_management/service/notification_service.dart';
import 'package:advance_employee_management/service/project_service.dart';
import 'package:advance_employee_management/service/task_service.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class ViewAnswer extends StatefulWidget {
  ViewAnswer({
    Key? key,
    required this.task,
  }) : super(key: key);
  TaskModel task;

  @override
  _ViewAnswerState createState() => _ViewAnswerState();
}

class _ViewAnswerState extends State<ViewAnswer> {
  TaskService taskService = TaskService();
  ProjectService projectService = ProjectService();
  NotificationService notificationService = NotificationService();
  TextEditingController? answeCon;
  String? answer;
  String filePath = "";

  @override
  void initState() {
    super.initState();
    answer = widget.task.answer;
    answeCon = TextEditingController(text: widget.task.answer);
    filePath = widget.task.file;
  }

  downloadFile(url) {
    AnchorElement anchorElement = AnchorElement(href: url);
    anchorElement.download = "Download File";
    anchorElement.click();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      insetPadding: const EdgeInsets.symmetric(vertical: 150),
      title: const Text("Answer"),
      content: SizedBox(
        width: 500,
        height: 500,
        child: Column(
          children: <Widget>[
            SizedBox(
              height: 200,
              width: 400,
              child: TextField(
                enabled: false,
                controller: answeCon,
                maxLines: 7,
                autofocus: true,
                decoration: const InputDecoration(
                    border: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.teal))),
                onChanged: (value) {
                  answer = value;
                },
              ),
            ),
            const SizedBox(
              height: 8,
            ),
            // widget.task.file.isNotEmpty
            filePath.isNotEmpty
                ? Column(
                    children: [
                      const Text("There is one attached file"),
                      TextButton.icon(
                          onPressed: () {
                            downloadFile(widget.task.file);
                          },
                          icon: const Icon(Icons.download),
                          label: const Text("Download Here")),
                    ],
                  )
                : Column(
                    children: const [
                      Text("There is no attached file"),
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
      ],
    );
  }
}
