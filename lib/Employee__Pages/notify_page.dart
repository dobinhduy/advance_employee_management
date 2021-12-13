import 'package:advance_employee_management/models/notification.dart';
import 'package:advance_employee_management/service/auth_services.dart';
import 'package:advance_employee_management/service/employee_service.dart';
import 'package:advance_employee_management/service/notification_service.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class NotificationPage extends StatefulWidget {
  const NotificationPage({Key? key}) : super(key: key);

  @override
  _NotificationPageState createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  NotificationService notificationService = NotificationService();
  EmployeeServices employeeServices = EmployeeServices();

  String useremail = AuthClass().user()!;
  List<NotificationModel>? notifies;
  String userID = "";
  bool read = false;
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
    notifies = await notificationService.getAllNotification(userID);
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
            appBar: AppBar(
              title: const Text('Notification'),
              backgroundColor: Colors.purpleAccent,
              automaticallyImplyLeading: false,
            ),
            body: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20),
                  const Text("Your notification"),
                  const SizedBox(height: 20),
                  for (NotificationModel notify in notifies!.reversed)
                    Center(
                      child: Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 10, horizontal: 20),
                          child: notify.isread == false
                              ? notification(notify, Colors.amberAccent)
                              : notification(notify, Colors.white)),
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

  Widget notification(NotificationModel notify, Color color) {
    Color textColor = color;
    bool read = notify.isread;
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          decoration: BoxDecoration(
            border: Border.all(width: 1),
            color: textColor,
          ),
          width: 550,
          height: 100,
          child: Column(
            children: [
              Row(
                children: [
                  titlebox("Message: "),
                  titlebox(notify.message),
                ],
              ),
              Row(
                children: [
                  titlebox("Send at:      " +
                      DateFormat("dd/MM/yyyy,HH:mm").format(
                          DateTime.fromMillisecondsSinceEpoch(notify.sendday))),
                  const SizedBox(
                    width: 100,
                  ),
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          primary: Colors.redAccent,
                          textStyle: const TextStyle(fontSize: 18)),
                      onPressed: () {
                        notificationService.updateStatus(notify.id, true);
                        setState(() {
                          notificationService.deleteNotification(notify.id);
                        });
                      },
                      child: const Text('Delete')),
                  const SizedBox(
                    width: 20,
                  ),
                  ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          textStyle: const TextStyle(fontSize: 18)),
                      onPressed: () {
                        setState(() {
                          read = !read;
                          notificationService.updateStatus(notify.id, read);
                        });
                      },
                      child: read == false
                          ? const Text('Mark as read')
                          : const Text("Mark as unread")),
                  const SizedBox(
                    width: 20,
                  ),
                ],
              )
            ],
          ),
        ),
      ],
    );
  }
}
