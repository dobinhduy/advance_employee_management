import 'package:advance_employee_management/models/employee.dart';
import 'package:advance_employee_management/service/auth_services.dart';
import 'package:advance_employee_management/service/department_service.dart';
import 'package:advance_employee_management/service/employee_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class EmployeeInformation extends StatefulWidget {
  const EmployeeInformation({Key? key}) : super(key: key);

  @override
  _EmployeeInformationState createState() => _EmployeeInformationState();
}

class _EmployeeInformationState extends State<EmployeeInformation> {
  EmployeeServices employeeServices = EmployeeServices();
  DepartmentService departmentService = DepartmentService();
  EmployeeModel? employeeInfor;
  String email = AuthClass().user()!;
  bool loading = true;
  List<String> list = [];

  getManagerInf() async {
    employeeInfor = await employeeServices.getEmployeebyEmail(email);

    if (mounted) {
      setState(() {});
    }
  }

  isLoading() {
    Future.delayed(const Duration(seconds: 2), () {
      setState(() {
        loading = false;
      });
    });
  }

  @override
  void initState() {
    super.initState();
    getEmployeeInf();
  }

  getEmployeeInf() async {
    employeeInfor = await employeeServices.getEmployeebyEmail(email);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    getEmployeeInf();
    isLoading();
    return loading == true
        ? Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: const <Widget>[
                SizedBox(
                  child: SpinKitCircle(
                    color: Colors.blue,
                    size: 50,
                  ),
                  height: 50.0,
                  width: 50.0,
                ),
              ],
            ),
          )
        : Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBar(
              automaticallyImplyLeading: false,
              backgroundColor: Colors.deepPurpleAccent,
              title: const Text("Your profile"),
            ),
            body: SingleChildScrollView(
              child: Column(
                children: [
                  Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        const SizedBox(
                          width: 15,
                        ),
                        SizedBox(
                          height: 500,
                          width: MediaQuery.of(context).size.width / 4.4,
                          child: Column(
                            children: [
                              const SizedBox(
                                height: 100,
                              ),
                              Image.network(employeeInfor!.photourl,
                                  width: 300, height: 300, fit: BoxFit.fill)
                            ],
                          ),
                        ),
                        const SizedBox(
                          width: 30,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 100),
                          child: Table(
                            defaultColumnWidth: const FixedColumnWidth(280),
                            children: [
                              TableRow(children: [
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    titlebox("Name:"),
                                    inputBox(employeeInfor!.name)
                                  ],
                                ),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    titlebox("Address:"),
                                    inputBox(employeeInfor!.address)
                                  ],
                                ),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    titlebox("Gender:"),
                                    inputBox(employeeInfor!.gender)
                                  ],
                                )
                              ]),
                              TableRow(children: [
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    titlebox("Birthday:"),
                                    inputBox(employeeInfor!.birthday)
                                  ],
                                ),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    titlebox("Identification Number:"),
                                    inputBox(employeeInfor!.id)
                                  ],
                                ),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    titlebox("Phone:"),
                                    inputBox(employeeInfor!.phone)
                                  ],
                                )
                              ]),
                              TableRow(children: [
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    titlebox("Department:"),
                                    inputBox(employeeInfor!.department)
                                  ],
                                ),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    titlebox("Role:"),
                                    inputBox(employeeInfor!.role)
                                  ],
                                ),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    titlebox("Supervisor ID:"),
                                    inputBox(employeeInfor!.supervisorid)
                                  ],
                                )
                              ])
                            ],
                          ),
                        ),
                      ]),
                ],
              ),
            ),
          );
  }

  Widget titlebox(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 22),
      child: Text(
        title,
        style: const TextStyle(
          color: Colors.black,
          fontSize: 17,
          letterSpacing: 2,
        ),
      ),
    );
  }

  Widget inputBox(String text) {
    return SizedBox(
      width: 250,
      height: 40,
      child: TextFormField(
          enabled: false,
          style: const TextStyle(color: Colors.black),
          decoration: InputDecoration(
            hintText: text,
            labelStyle: const TextStyle(fontSize: 17, color: Colors.black),
            enabledBorder: const OutlineInputBorder(
                borderSide: BorderSide(width: 1, color: Colors.grey)),
          )),
    );
  }
}
