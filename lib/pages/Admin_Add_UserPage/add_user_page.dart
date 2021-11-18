import 'dart:typed_data';
import 'package:advance_employee_management/locator.dart';
import 'package:advance_employee_management/provider/table_provider.dart';
import 'package:advance_employee_management/rounting/route_names.dart';
import 'package:advance_employee_management/service/auth_services.dart';
import 'package:advance_employee_management/service/employee_service.dart';
import 'package:advance_employee_management/service/manager_service.dart';
import 'package:advance_employee_management/service/navigation_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
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
  String position = "";

  final AuthClass authClass = AuthClass();

  DateTime selectedDate = DateTime.now();

  final EmployeeServices employeeServices = EmployeeServices();
  final ManagerServices managerServices = ManagerServices();
  String _imageURL = "";
  bool timeup = false;

  bool male = false;
  bool female = false;
  String gender = "";
  String dropDownvalue = 'Employee';

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
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
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
            child: Row(
              children: <Widget>[
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
                                height: 100,
                              ),
                              _imageURL != ""
                                  ? Image.network(
                                      _imageURL,
                                      width: 300,
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
                            children: [
                              uploadImageButton(),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
                Column(
                  children: [
                    const SizedBox(
                      height: 70,
                    ),
                    titlebox("Frist Name"),
                    titlebox("Password"),
                    titlebox("Birthday"),
                    titlebox("ID"),
                    titlebox("Gender"),
                  ],
                ),
                const SizedBox(
                  width: 30,
                ),
                Column(
                  children: [
                    const SizedBox(
                      height: 70,
                    ),
                    inputBox(fisrtname),
                    inputBox(password),
                    const SizedBox(
                      height: 25,
                    ),
                    birthdayButton(),
                    const SizedBox(
                      height: 25,
                    ),
                    inputBox(id),
                    const SizedBox(
                      height: 30,
                    ),
                    genderSelectedBox(),
                  ],
                ),
                Column(
                  children: [
                    const SizedBox(
                      height: 70,
                    ),
                    titlebox("Last Name"),
                    titlebox("Address"),
                    titlebox("Phone"),
                    titlebox("Email"),
                    titlebox("Position"),
                    const SizedBox(
                      height: 90,
                    ),
                    butonCancle(context),
                  ],
                ),
                Column(
                  children: [
                    const SizedBox(
                      height: 70,
                    ),
                    inputBox(lastname),
                    inputBox(address),
                    inputBox(phone),
                    inputBox(email),
                    const SizedBox(
                      height: 15,
                    ),
                    selectPosition(),
                    const SizedBox(
                      height: 105,
                    ),
                    butonAdd(context),
                  ],
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget inputBox(TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 25),
      child: Container(
        height: 30,
        width: 200,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(0),
          color: Colors.grey[100],
        ),
        child: TextFormField(
          controller: controller,
          maxLines: 1,
          style: const TextStyle(color: Colors.black, fontSize: 17),
          decoration: const InputDecoration(
            contentPadding: EdgeInsets.symmetric(vertical: 15),
            border: InputBorder.none,
          ),
        ),
      ),
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

  Widget selectPosition() {
    return DropdownButton<String>(
      value: dropDownvalue,
      iconSize: 24,
      elevation: 16,
      style: const TextStyle(color: Colors.deepPurple),
      underline: Container(
        height: 2,
        color: Colors.deepPurpleAccent,
      ),
      onChanged: (String? newValue) {
        setState(() {
          dropDownvalue = newValue!;
          position = dropDownvalue;
        });
      },
      items: <String>['Employee', 'Manager']
          .map<DropdownMenuItem<String>>((String value) {
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
        Text(
          "${selectedDate.toLocal()}".split(' ')[0].replaceAll("-", "/"),
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w300),
        ),
        const SizedBox(
          width: 20.0,
        ),
        ElevatedButton(
          onPressed: () => _selectDate(context),
          child: const Text(
            'Select date',
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
          ),
        ),
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
                await FirebaseAuth.instance
                    .createUserWithEmailAndPassword(
                        email: email.text, password: password.text)
                    .then((value) async {
                  locator<NavigationService>()
                      .globalNavigateTo(AdLayOutRoute, context);
                });

                if (position == "Employee") {
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
                  );
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
                    "position": position
                  });
                  authClass.showSnackBar(context, "Add success");
                  SchedulerBinding.instance?.addPostFrameCallback((_) {
                    Navigator.of(context).pushReplacementNamed(AddUserLayout);
                  });
                } else {
                  managerServices.addManager(
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
                    "Manager",
                  );
                  provider.managerSource.add({
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
                    "position": position
                  });
                  authClass.showSnackBar(context, "Add success");
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
