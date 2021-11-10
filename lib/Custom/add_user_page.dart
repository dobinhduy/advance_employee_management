import 'dart:typed_data';

import 'package:advance_employee_management/provider/table_provider.dart';

import 'package:advance_employee_management/service/auth_services.dart';
import 'package:advance_employee_management/service/employee_service.dart';
import 'package:advance_employee_management/service/manager_service.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';

import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

class AddEmployee extends StatefulWidget {
  const AddEmployee(
      {Key? key, required this.context, required this.employeeProvider})
      : super(key: key);

  final BuildContext context;
  final TableProvider employeeProvider;

  @override
  _AddEmployeeState createState() => _AddEmployeeState();
}

class _AddEmployeeState extends State<AddEmployee> {
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
  String _imageURL = "";
  bool timeup = false;
  void deplay() {
    Future.delayed(Duration(seconds: 2), () {
      timeup = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Add Employee")),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        color: Colors.white,
        child: Row(
          children: <Widget>[
            Column(
              children: [
                SizedBox(
                  height: 200,
                ),
                _imageURL != ""
                    ? Image.network(
                        _imageURL,
                        width: 200,
                        height: 200,
                      )
                    : Text("Upload image file here"),
                SizedBox(
                  height: 100,
                ),
                ElevatedButton(
                    onPressed: () async {
                      FilePickerResult? result = await FilePicker.platform
                          .pickFiles(type: FileType.image);
                      if (result != null) {
                        Uint8List? uploadfile = result.files.single.bytes;
                        // String fileName = result.files.single.name;
                        Reference reference = FirebaseStorage.instance
                            .ref()
                            .child(const Uuid().v1());
                        final UploadTask uploadTask =
                            reference.putData(uploadfile!);
                        uploadTask.whenComplete(() async {
                          String image =
                              await uploadTask.snapshot.ref.getDownloadURL();
                          setState(() {
                            _imageURL = image;
                          });
                        });
                      }
                    },
                    child: const Text("Upload image")),
              ],
            ),
            const SizedBox(
              width: 50,
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width / 4,
              child: Column(
                children: [
                  SizedBox(
                    height: 50,
                  ),
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
                      const SizedBox(
                        width: 50,
                      ),
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
            const SizedBox(
              width: 50,
            ),
            Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width / 3.5,
              decoration: const BoxDecoration(
                  gradient: LinearGradient(colors: [
                Colors.red,
                Colors.yellow,
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
                                      butonAdd(
                                          context, widget.employeeProvider),
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
    );
  }

  Widget inputBox(TextEditingController controller) {
    return Container(
      height: 45,
      width: 150,
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
              gender.text,
              _imageURL,
            );
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
                gender.text,
                _imageURL);
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
}
