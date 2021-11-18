import 'package:advance_employee_management/service/auth_services.dart';
import 'package:advance_employee_management/service/manager_service.dart';
import 'package:advance_employee_management/service/project_service.dart';
import 'package:flutter/material.dart';

class AddEntryDialog extends StatefulWidget {
  const AddEntryDialog({Key? key}) : super(key: key);

  @override
  AddEntryDialogState createState() => AddEntryDialogState();
}

class AddEntryDialogState extends State<AddEntryDialog> {
  TextEditingController projectName = TextEditingController();
  TextEditingController id = TextEditingController();
  TextEditingController startday = TextEditingController();
  TextEditingController endday = TextEditingController();
  TextEditingController desController = TextEditingController();
  TextEditingController memberID1 = TextEditingController();
  TextEditingController memberID2 = TextEditingController();
  TextEditingController memberID3 = TextEditingController();
  TextEditingController memberID4 = TextEditingController();
  TextEditingController memberID5 = TextEditingController();
  DateTime selectedStartDate = DateTime.now();
  DateTime selectedEndDate = DateTime.now();
  String startDayCon = "";
  String endayCon = "";
  ManagerServices managerServices = ManagerServices();
  ProjectService projectService = ProjectService();

  String managerIDcontroller = "";
  String email = AuthClass().user()!;
  getManagerID() async {
    managerIDcontroller = await managerServices.getManagerIDbyEmail(email);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    getManagerID();
    return Scaffold(
        appBar: AppBar(
          title: const Text('New Project'),
          actions: [
            TextButton(
                onPressed: () {
                  List<String> members = <String>[];
                  members.add(memberID1.text);
                  members.add(memberID2.text);
                  projectService.createProject(
                      id.text,
                      projectName.text,
                      managerIDcontroller,
                      "${selectedStartDate.toLocal()}".split(' ')[0],
                      "${selectedEndDate.toLocal()}".split(' ')[0],
                      desController.text,
                      members,
                      "Open",
                      0);
                },
                child: Text('SAVE',
                    style: Theme.of(context)
                        .textTheme
                        .subtitle1
                        ?.copyWith(color: Colors.white))),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(vertical: 50, horizontal: 50),
          child: Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    titlebox("Project Name*"),
                    textItem("Project Name", projectName, false, true),
                    titlebox("Project ID*"),
                    textItem("Project ID", id, false, true),
                    titlebox("Start Day*"),
                    Row(
                      children: [
                        textItem("${selectedStartDate.toLocal()}".split(' ')[0],
                            startday, false, false),
                        const SizedBox(
                          width: 40,
                        ),
                        ElevatedButton.icon(
                          onPressed: () => _selectStartDate(context),
                          icon: const Icon(
                            Icons.calendar_view_month_outlined,
                            color: Colors.white,
                            size: 30.0,
                          ),
                          label: const Text(
                            '',
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                    titlebox("End Day*"),
                    Row(
                      children: [
                        textItem("${selectedEndDate.toLocal()}".split(' ')[0],
                            endday, false, false),
                        const SizedBox(
                          width: 40,
                        ),
                        ElevatedButton.icon(
                          onPressed: () => _selectEndDate(context),
                          icon: const Icon(
                            Icons.calendar_view_week,
                            color: Colors.white,
                            size: 30.0,
                          ),
                          label: const Text(
                            '',
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                    titlebox("Description*"),
                    description(desController),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 300),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      titlebox("Member 1*"),
                      textItem("Input member ID", memberID1, false, true),
                      titlebox("Member 2*"),
                      textItem("Input member ID", memberID2, false, true),
                      titlebox("Member 3*"),
                      textItem("Input member ID", memberID3, false, true),
                      titlebox("Member 4*"),
                      textItem("Input member ID", memberID4, false, true),
                      titlebox("Member 5*"),
                      textItem("Input member ID", memberID5, false, true),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ));
  }

  Widget textItem(String text, TextEditingController controller,
      bool obscureText, bool enable) {
    return SizedBox(
      width: 280,
      height: 40,
      child: TextFormField(
          enabled: enable,
          controller: controller,
          obscureText: obscureText,
          style: const TextStyle(color: Colors.black),
          decoration: InputDecoration(
            hintText: text,
            labelStyle: const TextStyle(fontSize: 13, color: Colors.black),
            focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
                borderSide: const BorderSide(width: 1, color: Colors.amber)),
            enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
                borderSide: const BorderSide(width: 1, color: Colors.grey)),
          )),
    );
  }

  Widget description(TextEditingController desciption) {
    return Container(
      height: 150,
      width: MediaQuery.of(context).size.width / 2.5 - 200,
      decoration: BoxDecoration(
        color: const Color(0xff2a2e3d),
        borderRadius: BorderRadius.circular(15),
      ),
      child: TextFormField(
        controller: desciption,
        maxLines: null,
        style: const TextStyle(color: Colors.grey, fontSize: 17),
        decoration: const InputDecoration(
          border: InputBorder.none,
          hintText: "Description",
          hintStyle: TextStyle(
            color: Colors.grey,
            fontSize: 17,
          ),
          contentPadding: EdgeInsets.only(left: 20, right: 20),
        ),
      ),
    );
  }

  Widget titlebox(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
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

  _selectStartDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedStartDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2025),
    );
    if (picked != null && picked != selectedStartDate) {
      if (!mounted) {}
      setState(() {
        selectedStartDate = picked;
      });
    }
  }

  _selectEndDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedEndDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2025),
    );
    if (picked != null && picked != selectedEndDate) {
      if (!mounted) {
        setState(() {
          selectedEndDate = picked;
        });
      }
    }
  }
}
