import 'package:advance_employee_management/models/notification.dart';
import 'package:advance_employee_management/service/auth_services.dart';
import 'package:advance_employee_management/service/employee_service.dart';
import 'package:advance_employee_management/service/manager_service.dart';
import 'package:advance_employee_management/service/notification_service.dart';
import 'package:flutter/material.dart';

class NotificationPage extends StatefulWidget {
  const NotificationPage({Key? key}) : super(key: key);

  @override
  _NotificationPageState createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  NotificationService notificationService = NotificationService();
  EmployeeServices employeeServices = EmployeeServices();
  ManagerServices managerServices = ManagerServices();
  String useremail = AuthClass().user()!;
  List<NotificationModel>? notifies;
  String userID = "";
  bool timeout = false;
  @override
  void initState() {
    super.initState();
    getUserID();
    getNotify();
  }

  getUserID() async {
    userID = await employeeServices.getEmployeeIDbyEmail(useremail);
    setState(() {});
  }

  getNotify() async {
    notifies = await notificationService.getNotificationbyemployeeID(userID);
    setState(() {});
  }

  void deplay() {
    Future.delayed(const Duration(seconds: 1), () {
      timeout = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    getUserID();
    getNotify();
    deplay();
    return timeout
        ? Scaffold(
            appBar: AppBar(title: const Text('Notification')),
            body: SingleChildScrollView(
              child: Column(
                children: [
                  for (NotificationModel notify in notifies!)
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 10, horizontal: 20),
                      child: notify.isread == false
                          ? Container(
                              color: Colors.amber[50],
                              width: 400,
                              height: 80,
                              child: InkWell(
                                onTap: () {},
                                child: Column(
                                  children: [
                                    Row(
                                      children: [
                                        titlebox("Send by: "),
                                        titlebox(notify.sendername)
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        titlebox("Message: "),
                                        titlebox("You was add to " +
                                            notify.projectname +
                                            "project"),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        titlebox("Send at: " + notify.sendday),
                                        const SizedBox(
                                          width: 100,
                                        ),
                                        ElevatedButton(
                                            style: ElevatedButton.styleFrom(
                                                textStyle: const TextStyle(
                                                    fontSize: 18)),
                                            onPressed: () {},
                                            child: const Text('Read More'))
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            )
                          : Container(
                              color: Colors.white,
                              width: 400,
                              height: 80,
                              child: InkWell(
                                onTap: () {},
                                child: Column(
                                  children: [
                                    Row(
                                      children: [
                                        titlebox("Send by: "),
                                        titlebox(notify.sendername)
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        titlebox("Message: "),
                                        titlebox("You was add to " +
                                            notify.projectname +
                                            "project"),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        titlebox("Send at: " + notify.sendday),
                                        const SizedBox(
                                          width: 100,
                                        ),
                                        ElevatedButton(
                                            style: ElevatedButton.styleFrom(
                                                textStyle: const TextStyle(
                                                    fontSize: 18)),
                                            onPressed: () {},
                                            child: const Text('Read More'))
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            ),
                    )
                ],
              ),
            ),
          )
        : SizedBox(
            width: 200,
            height: 200,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: const [
                CircularProgressIndicator(),
              ],
            ));
  }

  Widget titlebox(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3, horizontal: 5),
      child: Text(
        title,
        style: const TextStyle(
            color: Colors.black,
            fontSize: 13,
            letterSpacing: 0.5,
            fontWeight: FontWeight.bold),
      ),
    );
  }
}
