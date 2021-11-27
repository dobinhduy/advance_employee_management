import 'dart:typed_data';
import 'package:advance_employee_management/provider/table_provider.dart';
import 'package:advance_employee_management/rounting/route_names.dart';
import 'package:advance_employee_management/service/auth_services.dart';
import 'package:advance_employee_management/service/employee_service.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:awesome_dialog/awesome_dialog.dart';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

class AddUserPage extends StatefulWidget {
  const AddUserPage({Key? key}) : super(key: key);

  @override
  _AddUserPageState createState() => _AddUserPageState();
}

class _AddUserPageState extends State<AddUserPage> {
  final TextEditingController fisrtname = TextEditingController();
  final TextEditingController lastname = TextEditingController();
  final TextEditingController password = TextEditingController();
  final TextEditingController id = TextEditingController();
  final TextEditingController address = TextEditingController();
  final TextEditingController phone = TextEditingController();
  final TextEditingController email = TextEditingController();
  final TextEditingController supervisorid = TextEditingController();

  String role = "";
  String department = "";

  final AuthClass authClass = AuthClass();

  DateTime selectedDate = DateTime.now();

  final EmployeeServices employeeServices = EmployeeServices();

  String _imageURL = "";
  bool timeup = false;

  bool male = false;
  bool female = false;
  String gender = "";
  String dropDownvalue = 'Employee';
  String dropDownRole = "Software developer";
  String dropDownDepartment = "IT department";

  void deplay() {
    Future.delayed(const Duration(seconds: 2), () {
      timeup = true;
    });
  }

  _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2025),
    );

    if (picked != null && picked != selectedDate) {
      if (mounted) {
        setState(() {
          selectedDate = picked;
        });
      }
    }
  }

  @override
  void initState() {
    super.initState();
    setState(() {
      fisrtname.clear();
      lastname.clear();
      password.clear();
      address.clear();
      id.clear();
      phone.clear();
      email.clear();
      _imageURL = "";
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          children: [
            Container(
              width: MediaQuery.of(context).size.width,
              decoration: const BoxDecoration(
                color: Colors.deepPurpleAccent,
              ),
              height: 70,
              child: const Padding(
                padding: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                child: Text(
                  "Add New User",
                  style: TextStyle(color: Colors.white, fontSize: 30),
                ),
              ),
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height - 70,
              color: Colors.white,
              padding: const EdgeInsets.only(left: 40),
              child: Row(
                children: <Widget>[
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(
                        height: 20,
                      ),
                      titlebox("Frist Name"),
                      inputBox("First name", fisrtname, false),
                      titlebox("Gender"),
                      genderSelectedBox(),
                      titlebox("Birthday"),
                      birthdayButton(),
                      titlebox("ID"),
                      inputBox("User ID", id, false),
                      titlebox("Password"),
                      inputBox("Password", password, false),
                    ],
                  ),
                  const SizedBox(
                    width: 20,
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(
                        height: 20,
                      ),
                      titlebox("Last Name"),
                      inputBox("Last name", lastname, false),
                      titlebox("Address"),
                      inputBox("Address", address, false),
                      titlebox("Phone"),
                      inputBox("Phone", phone, false),
                      titlebox("Email"),
                      inputBox("Example: abd@gmail.com", email, false),
                      titlebox("Supervisorid"),
                      inputBox("manager id", supervisorid, false),
                      const SizedBox(
                        height: 90,
                      ),
                    ],
                  ),
                  const SizedBox(
                    width: 60,
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(
                        height: 20,
                      ),
                      titlebox("Role"),
                      selectedRole(),
                      titlebox("Department"),
                      selectDepartment(),
                      SizedBox(height: 30),
                      uploadImageButton(),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width / 5,
                      height: MediaQuery.of(context).size.height,
                      child: Column(
                        children: [
                          SizedBox(
                            width: MediaQuery.of(context).size.width / 5,
                            height: MediaQuery.of(context).size.height / 1.6,
                            child: Column(
                              children: [
                                const SizedBox(
                                  height: 50,
                                ),
                                _imageURL != ""
                                    ? Image.network(
                                        _imageURL,
                                        width: 250,
                                        height: 300,
                                        fit: BoxFit.fill,
                                      )
                                    : Container(),
                                const SizedBox(
                                  height: 20,
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            width: MediaQuery.of(context).size.width / 5,
                            height: MediaQuery.of(context).size.height / 5,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    butonCancle(context),
                                    const SizedBox(
                                      width: 70,
                                    ),
                                    butonAdd(context),
                                  ],
                                )
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget inputBox(
      String text, TextEditingController controller, bool obscureText) {
    return SizedBox(
      width: 250,
      height: 40,
      child: TextFormField(
          controller: controller,
          obscureText: obscureText,
          style: const TextStyle(color: Colors.black),
          decoration: InputDecoration(
            hintText: text,
            labelStyle: const TextStyle(fontSize: 17, color: Colors.black),
            focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(width: 1, color: Colors.amber)),
            enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(width: 1, color: Colors.grey)),
          )),
    );
  }

  Widget uploadImageButton() {
    return ElevatedButton(
        onPressed: () async {
          FilePickerResult? result =
              await FilePicker.platform.pickFiles(type: FileType.image);
          if (result != null) {
            Uint8List? uploadfile = result.files.single.bytes;
            // String fileName = result.files.single.name;
            Reference reference =
                FirebaseStorage.instance.ref().child(const Uuid().v1());
            final UploadTask uploadTask = reference.putData(uploadfile!);
            uploadTask.whenComplete(() async {
              String image = await uploadTask.snapshot.ref.getDownloadURL();
              if (mounted) {
                setState(() {
                  _imageURL = image;
                });
              }
            });
          }
        },
        child: const Text("Upload image"));
  }

  Widget selectDepartment() {
    return DropdownButton<String>(
      value: dropDownDepartment,
      iconSize: 24,
      elevation: 16,
      style: const TextStyle(color: Colors.deepPurple),
      underline: Container(
        height: 2,
        color: Colors.deepPurpleAccent,
      ),
      onChanged: (String? newValue) {
        setState(() {
          dropDownDepartment = newValue!;
          department = dropDownDepartment;
        });
      },
      items: <String>[
        'IT department',
        'Support Department  ',
        'Maketting Department'
      ].map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
    );
  }

  Widget selectedRole() {
    return DropdownButton<String>(
      value: dropDownRole,
      iconSize: 24,
      elevation: 16,
      style: const TextStyle(color: Colors.deepPurple),
      underline: Container(
        height: 2,
        color: Colors.deepPurpleAccent,
      ),
      onChanged: (String? newValue) {
        setState(() {
          dropDownRole = newValue!;
          role = dropDownRole;
        });
      },
      items: <String>[
        'Software developer',
        'Hardware Technician',
        'Network Administrator',
        'Business Analyst',
        ' IT Project Manager',
        'Systems Engineering Manager'
      ].map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
    );
  }

  Widget unselectedRole() {
    return DropdownButton<String>(
      value: dropDownRole,
      iconSize: 24,
      elevation: 16,
      style: const TextStyle(color: Colors.deepPurple),
      underline: Container(
        height: 2,
        color: Colors.deepPurpleAccent,
      ),
      onChanged: null,
      items: <String>[
        'Software developer',
        'Hardware Technician',
        'Network Administrator',
        'Business Analyst',
        ' IT Project Manager',
        'Systems Engineering Manager'
      ].map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
    );
  }

  Widget genderSelectedBox() {
    return Row(
      children: [
        const Text(
          "Male",
          style: TextStyle(fontSize: 18),
        ),
        Checkbox(
          checkColor: Colors.black,
          activeColor: Colors.red,
          value: female,
          onChanged: (bool? value) {
            setState(() {
              female = true;
              male = false;
              gender = "Female";
            });
          },
        ),
        const SizedBox(
          width: 30,
        ),
        const Text(
          "Female",
          style: TextStyle(fontSize: 18),
        ),
        Checkbox(
          checkColor: Colors.black,
          activeColor: Colors.red,
          value: male,
          onChanged: (bool? value) {
            setState(() {
              male = true;
              female = false;
              gender = "Male";
            });
          },
        ),
      ],
    );
  }

  Widget birthdayButton() {
    return Row(
      children: [
        SizedBox(
          width: 250,
          height: 40,
          child: TextFormField(
              obscureText: false,
              enabled: true,
              style: const TextStyle(color: Colors.black),
              decoration: InputDecoration(
                hintText: "${selectedDate.toLocal()}"
                    .split(' ')[0]
                    .replaceAll("-", "/"),
                labelStyle: const TextStyle(fontSize: 17, color: Colors.black),
                focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide:
                        const BorderSide(width: 1, color: Colors.amber)),
                enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(width: 1, color: Colors.grey)),
              )),
        ),
        const SizedBox(
          width: 20.0,
        ),
        IconButton(
            onPressed: () {
              _selectDate(context);
            },
            icon: const Icon(Icons.calendar_today))
      ],
    );
  }

  ElevatedButton butonCancle(BuildContext context) {
    final ButtonStyle raisedButtonStyle = ElevatedButton.styleFrom(
      onPrimary: Colors.black87,
      primary: Colors.grey[300],
      minimumSize: const Size(88, 36),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(2)),
      ),
    );
    return ElevatedButton(
      style: raisedButtonStyle,
      onPressed: () {
        setState(() {
          fisrtname.clear();
          lastname.clear();
          password.clear();
          address.clear();
          id.clear();
          phone.clear();
          email.clear();
        });
      },
      child: const Text('Clear'),
    );
  }

  ElevatedButton butonAdd(BuildContext context) {
    TableProvider provider = Provider.of<TableProvider>(context);
    final ButtonStyle raisedButtonStyle = ElevatedButton.styleFrom(
      onPrimary: Colors.black87,
      primary: Colors.grey[300],
      minimumSize: const Size(88, 36),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(2)),
      ),
    );
    return ElevatedButton(
      style: raisedButtonStyle,
      onPressed: () async {
        if (checkFillImage()) {
          if (checkFillAll()) {
            if (validPassword(password.text)) {
              try {
                await FirebaseAuth.instance.createUserWithEmailAndPassword(
                    email: email.text, password: password.text);

                if (1 == 1) {
                  employeeServices.addEmployee(
                      id.text,
                      fisrtname.text + lastname.text,
                      gender,
                      "${selectedDate.toLocal()}"
                          .split(' ')[0]
                          .replaceAll("-", "/"),
                      email.text,
                      address.text,
                      phone.text,
                      _imageURL,
                      "Employee",
                      role,
                      department,
                      supervisorid.text);
                  provider.employeeSource.add({
                    "id": id.text,
                    "name": lastname.text + fisrtname.text,
                    "gender": gender,
                    "birthday": "${selectedDate.toLocal()}"
                        .split(' ')[0]
                        .replaceAll("-", "/"),
                    "email": email.text,
                    "address": address.text,
                    "phone": phone.text,
                    "photoURL": _imageURL,
                    "role": role,
                    "department": department,
                    "action": [id.text, null],
                  });
                  authClass.showSnackBar(context, "Add employee success");
                  SchedulerBinding.instance?.addPostFrameCallback((_) {
                    Navigator.of(context).pushReplacementNamed(AddUserLayout);
                  });
                }
              } catch (e) {
                authClass.showSnackBar(context, e.toString());
              }
            } else {
              dialog(
                  DialogType.WARNING,
                  "Invalid password",
                  "Password must contains: \n" +
                      "+ Minimum 1 Upper case\n " +
                      "+ Minimum 1 lowercase\n" +
                      "+ Minimum 1 Numeric Number\n" +
                      "+ Minimum 1 Special Character ( ! @ #  & * ~ )");
            }
          } else {
            dialog(DialogType.ERROR, "Missing some information",
                "Please fill all the require information");
          }
        } else {
          dialog(DialogType.ERROR, "Missing Image", "Please select a image");
        }
      },
      child: const Text('Add'),
    );
  }

  Widget titlebox(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 18),
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

  AwesomeDialog dialog(DialogType type, String title, String description) {
    return AwesomeDialog(
      context: context,
      width: 600,
      dialogType: type,
      animType: AnimType.BOTTOMSLIDE,
      title: title,
      desc: description,
      btnOkOnPress: () {},
    )..show();
  }

  bool validPassword(String value) {
    String pattern =
        r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$';
    RegExp regExp = RegExp(pattern);
    return regExp.hasMatch(value);
  }

  bool checkFillAll() {
    if (fisrtname.text.isEmpty ||
        lastname.text.isEmpty ||
        password.text.isEmpty ||
        address.text.isEmpty ||
        phone.text.isEmpty ||
        id.text.isEmpty ||
        email.text.isEmpty) {
      return false;
    }
    return true;
  }

  bool checkFillImage() {
    return _imageURL.isNotEmpty;
  }
}
