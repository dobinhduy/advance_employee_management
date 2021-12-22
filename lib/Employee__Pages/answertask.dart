import 'dart:typed_data';

import 'package:advance_employee_management/models/task.dart';
import 'package:advance_employee_management/service/auth_services.dart';
import 'package:advance_employee_management/service/notification_service.dart';
import 'package:advance_employee_management/service/project_service.dart';
import 'package:advance_employee_management/service/task_service.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:uuid/uuid.dart';

// ignore: must_be_immutable
class AnswerTask extends StatefulWidget {
  AnswerTask(
      {Key? key,
      required this.task,
      required this.projectName,
      required this.employeeID,
      required this.projectid,
      required this.managerID,
      required this.employeeName,
      required this.complete})
      : super(key: key);
  TaskModel task;
  String projectName;
  String employeeID;
  String projectid;
  String managerID;
  String employeeName;
  String complete;

  @override
  _AnswerTaskState createState() => _AnswerTaskState();
}

class _AnswerTaskState extends State<AnswerTask> {
  TextEditingController id = TextEditingController();
  TaskService taskService = TaskService();
  ProjectService projectService = ProjectService();
  NotificationService notificationService = NotificationService();
  String answer = "";
  String message = "";
  String path = "";
  String filename = "";

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      insetPadding: const EdgeInsets.symmetric(vertical: 150),
      title: const Text("Your Answer"),
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
                    hintText: "Type your answer here",
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
            filename.isNotEmpty
                ? Row(
                    children: [
                      Text("File Name:       " + filename),
                    ],
                  )
                : const Text(""),
            Text(
              message,
              style: const TextStyle(color: Colors.red),
            ),
            uploadImageButton(),
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
            child: const Text('Submit'),
            onPressed: () async {
              if (widget.task.status == "Uncomplete") {
                taskService.updateStatus(widget.task.id, "Complete");
                if (answer.isNotEmpty) {
                  taskService.updateAnswer(widget.task.id, answer);
                }
                if (path.isNotEmpty) {
                  taskService.updateFilePath(widget.task.id, path);
                }
                projectService.addCompletion(
                    widget.projectid, widget.task.percent);
                notificationService.createNotification(
                    const Uuid().v4(),
                    widget.employeeID,
                    widget.managerID,
                    DateTime.now().millisecondsSinceEpoch,
                    false,
                    widget.employeeName +
                        " has finished his/her task in project " +
                        widget.projectName);
                Navigator.pop(context);
                await EasyLoading.showSuccess('Submit Success!!!');

                if (mounted) {
                  setState(() {});
                }
              } else {
                AuthClass().showSnackBar(context,
                    "You can not change the status. Try to connect to you manager");
              }
            }),
      ],
    );
  }

  Widget uploadImageButton() {
    return ElevatedButton(
        onPressed: () async {
          FilePickerResult? result = await FilePicker.platform.pickFiles(
              type: FileType.custom, allowedExtensions: ['jpg', 'pdf', 'doc']);
          if (result != null) {
            Uint8List? uploadfile = result.files.single.bytes;
            String fileName = result.files.single.name;
            Reference reference =
                FirebaseStorage.instance.ref().child(fileName);
            final UploadTask uploadTask = reference.putData(uploadfile!);
            uploadTask.whenComplete(() async {
              String filePath = await uploadTask.snapshot.ref.getDownloadURL();
              if (mounted) {
                setState(() {
                  filename = fileName;
                  path = filePath;
                });
              }
            });
          }
        },
        child: const Text("Upload File"));
  }
}
