import 'package:advance_employee_management/provider/table_provider.dart';

import 'package:advance_employee_management/service/auth_services.dart';
import 'package:advance_employee_management/service/employee_service.dart';
import 'package:advance_employee_management/service/manager_service.dart';

import 'package:flutter/material.dart';

class AddEmployee extends StatefulWidget {
  AddEmployee({Key? key}) : super(key: key);
  final TextEditingController fisrtname = TextEditingController();
  final TextEditingController lastname = TextEditingController();
  final TextEditingController password = TextEditingController();
  final TextEditingController id = TextEditingController();
  final TextEditingController birthday = TextEditingController();
  final TextEditingController address = TextEditingController();
  final TextEditingController phone = TextEditingController();
  final TextEditingController email = TextEditingController();
  final TextEditingController position = TextEditingController();
  final TextEditingController gender = TextEditingController();
  final AuthClass authClass = AuthClass();

  final EmployeeServices employeeServices = EmployeeServices();
  final ManagerServices managerServices = ManagerServices();

  @override
  _AddEmployeeState createState() => _AddEmployeeState();
  Widget titlebox(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 30),
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

  Widget inputBox(TextEditingController controller) {
    return Container(
      height: 45,
      width: 200,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: Colors.blue,
      ),
      child: TextFormField(
        controller: controller,
        maxLines: 1,
        style: const TextStyle(color: Colors.black, fontSize: 17),
        decoration: const InputDecoration(
          border: InputBorder.none,
        ),
      ),
    );
  }

  Widget butonCancle(BuildContext context) {
    return TextButton(
        style: ButtonStyle(
          overlayColor: MaterialStateProperty.resolveWith<Color?>(
              (Set<MaterialState> states) {
            if (states.contains(MaterialState.focused)) return Colors.red;
            return null; // Defer to the widget's default.
          }),
        ),
        onPressed: () {
          Navigator.pop(context);
        },
        child: const Text("Cancle"));
  }

  Widget butonAdd(BuildContext context, TableProvider provider) {
    return TextButton(
        style: ButtonStyle(
          overlayColor: MaterialStateProperty.resolveWith<Color?>(
              (Set<MaterialState> states) {
            if (states.contains(MaterialState.focused)) return Colors.red;
            return null; // Defer to the widget's default.
          }),
        ),
        onPressed: () {
          if (position.text == "employee") {
            authClass.signUpWithEmailPass(lastname.text + fisrtname.text,
                email.text, password.text, context);
            employeeServices.addEmployee(
                id.text,
                fisrtname.text + lastname.text,
                birthday.text,
                phone.text,
                address.text,
                position.text,
                email.text,
                gender.text);
            provider.employeeSource.add({
              "id": id.text,
              "name": lastname.text + fisrtname.text,
              "gender": gender.text,
              "birthday": birthday.text,
              "email": email.text,
              "address": address.text,
              "phone": phone.text,
            });
          }
          if (position.text == "manager") {
            authClass.signUpWithEmailPass(lastname.text + fisrtname.text,
                email.text, password.text, context);
            managerServices.addManager(
                id.text,
                fisrtname.text + lastname.text,
                birthday.text,
                phone.text,
                address.text,
                position.text,
                email.text,
                gender.text);
            provider.managerSource.add({
              "id": id.text,
              "name": lastname.text + fisrtname.text,
              "gender": gender.text,
              "birthday": birthday.text,
              "email": email.text,
              "address": address.text,
              "phone": phone.text,
            });
          } else {
            authClass.showSnackBar(context, "position is wrong");
          }
        },
        child: const Text("Add"));
  }

  displayDialog(BuildContext context, TableProvider employeeProvider) {
    showGeneralDialog(
      context: context,
      barrierDismissible: false,
      transitionDuration: const Duration(milliseconds: 1000),
      transitionBuilder: (context, animation, secondaryAnimation, child) {
        return FadeTransition(
          opacity: animation,
          child: ScaleTransition(
            scale: animation,
            child: child,
          ),
        );
      },
      pageBuilder: (context, animation, secondaryAnimation) {
        return Padding(
          padding: const EdgeInsets.all(90.0),
          child: Material(
            child: Container(
              width: MediaQuery.of(context).size.width / 2,
              height: MediaQuery.of(context).size.height / 2,
              color: Colors.white,
              child: Row(
                children: <Widget>[
                  SizedBox(
                    height: MediaQuery.of(context).size.height,
                    width: MediaQuery.of(context).size.width / 3,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 50, vertical: 50),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              titlebox("Frist Name"),
                              inputBox(fisrtname),
                            ],
                          ),
                          Row(
                            children: [
                              titlebox("Password"),
                              inputBox(password),
                            ],
                          ),
                          Row(
                            children: [
                              titlebox("Birthday"),
                              inputBox(birthday),
                            ],
                          ),
                          Row(
                            children: [
                              titlebox("ID"),
                              inputBox(id),
                            ],
                          ),
                          Row(
                            children: [
                              titlebox("Gender"),
                              inputBox(gender),
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 30,
                  ),
                  Container(
                    height: MediaQuery.of(context).size.height,
                    width: MediaQuery.of(context).size.width / 2 + 30,
                    decoration: const BoxDecoration(
                        gradient: LinearGradient(colors: [
                      Colors.white,
                      Colors.blue,
                    ])),
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const SizedBox(
                            height: 30,
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 25),
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    Column(
                                      children: [
                                        Row(
                                          children: [
                                            titlebox("Last Name"),
                                            inputBox(lastname),
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            titlebox("Address"),
                                            inputBox(address),
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            titlebox("Phone"),
                                            inputBox(phone),
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            titlebox("Email"),
                                            inputBox(email)
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            titlebox("Position"),
                                            inputBox(position),
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            butonCancle(context),
                                            const SizedBox(
                                              width: 50,
                                            ),
                                            butonAdd(context, employeeProvider),
                                          ],
                                        )
                                      ],
                                    )
                                  ],
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class _AddEmployeeState extends State<AddEmployee> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
