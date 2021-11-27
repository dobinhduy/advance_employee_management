import 'package:advance_employee_management/models/employee.dart';
import 'package:advance_employee_management/service/auth_services.dart';
import 'package:advance_employee_management/service/employee_service.dart';
import 'package:flutter/material.dart';

class EmployeeInformation extends StatefulWidget {
  const EmployeeInformation({Key? key}) : super(key: key);

  @override
  _EmployeeInformationState createState() => _EmployeeInformationState();
}

class _EmployeeInformationState extends State<EmployeeInformation> {
  EmployeeServices employeeServices = EmployeeServices();
  EmployeeModel? employeeInfor;
  String email = AuthClass().user()!;
  bool loading = true;

  getManagerInf() async {
    employeeInfor = await employeeServices.getEmployeebyEmail(email);

    if (!mounted) {
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
                  child: CircularProgressIndicator(),
                  height: 50.0,
                  width: 50.0,
                ),
              ],
            ),
          )
        : Scaffold(
            backgroundColor: Colors.deepPurple[200],
            appBar: AppBar(
              backgroundColor: Colors.blueAccent,
              title: const Text("Employee Information"),
            ),
            body: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  const SizedBox(
                    width: 20,
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height,
                    width: MediaQuery.of(context).size.width / 4.4,
                    child: Column(
                      children: [
                        const SizedBox(
                          height: 140,
                        ),
                        Image.network(employeeInfor!.photourl,
                            width: 300, height: 300, fit: BoxFit.fill)
                      ],
                    ),
                  ),
                  const SizedBox(
                    width: 100,
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height,
                    width: 100,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(
                          height: 100,
                        ),
                        titlebox("Name"),
                        titlebox("ID"),
                        titlebox("Gender"),
                        titlebox("Birthday"),
                        titlebox("Address"),
                        titlebox("Phone"),
                        titlebox("Email"),
                      ],
                    ),
                  ),
                  const SizedBox(
                    width: 90,
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height,
                    width: MediaQuery.of(context).size.width / 5,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(
                          height: 100,
                        ),
                        titlebox(employeeInfor!.name),
                        titlebox(employeeInfor!.id),
                        titlebox(employeeInfor!.gender),
                        titlebox(employeeInfor!.birthday),
                        titlebox(employeeInfor!.address),
                        titlebox(employeeInfor!.phone),
                        titlebox(employeeInfor!.email),
                      ],
                    ),
                  ),
                  Column(
                    children: [
                      const SizedBox(
                        height: 50,
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height / 5,
                        width: MediaQuery.of(context).size.width / 5,
                        child: Column(
                          children: [
                            IconButton(
                                onPressed: () {},
                                icon: const Icon(Icons.backspace,
                                    color: Colors.blue, size: 28)),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 350,
                      ),
                    ],
                  )
                ]),
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
}
