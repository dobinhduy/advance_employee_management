import 'dart:typed_data';

import 'package:advance_employee_management/locator.dart';
import 'package:advance_employee_management/provider/table_provider.dart';

import 'package:advance_employee_management/service/auth_services.dart';
import 'package:advance_employee_management/service/employee_service.dart';
import 'package:advance_employee_management/service/manager_service.dart';
import 'package:advance_employee_management/service/navigation_service.dart';
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
  final TextEditingController address = TextEditingController();
  final TextEditingController phone = TextEditingController();
  final TextEditingController email = TextEditingController();

  final AuthClass authClass = AuthClass();
  List<String> listPosition = ['Employee', 'Manager'];
  DateTime selectedDate = DateTime.now();

  final EmployeeServices employeeServices = EmployeeServices();
  final ManagerServices managerServices = ManagerServices();
  String _imageURL = "";
  bool timeup = false;
  String positionSelected = 'Employee';
  bool male = false;
  bool female = false;
  String gender = "";

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
      setState(() {
        selectedDate = picked;
      });
    }
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
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Container(
                width: MediaQuery.of(context).size.width / 5,
                height: MediaQuery.of(context).size.height,
                child: Column(
                  children: [
                    Container(
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
                                  fit: BoxFit.cover,
                                )
                              : Container(),
                          const SizedBox(
                            height: 20,
                          ),
                        ],
                      ),
                    ),
                    Container(
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
                  height: 20,
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
                  height: 8,
                ),
                selectPosition(),
                const SizedBox(
                  height: 20,
                ),
                butonAdd(context, widget.employeeProvider),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget inputBox(TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 23),
      child: Container(
        height: 35,
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
              setState(() {
                _imageURL = image;
              });
            });
          }
        },
        child: const Text("Upload image"));
  }

  Widget genderSelectedBox() {
    return Row(
      children: [
        const Text(
          "Male",
          style: const TextStyle(fontSize: 18),
        ),
        Checkbox(
          checkColor: Colors.black,
          activeColor: Colors.red,
          value: female,
          onChanged: (bool? value) {
            setState(() {
              female = true;
              male = false;
              gender = "female";
            });
          },
        ),
        const SizedBox(
          width: 30,
        ),
        const Text(
          "Female",
          style: const TextStyle(fontSize: 18),
        ),
        Checkbox(
          checkColor: Colors.black,
          activeColor: Colors.red,
          value: male,
          onChanged: (bool? value) {
            setState(() {
              male = true;
              female = false;
              gender = "male";
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

  Widget selectPosition() {
    return DropdownButton<String>(
      value: positionSelected,
      iconSize: 24,
      elevation: 16,
      style: const TextStyle(color: Colors.deepPurple),
      underline: Container(
        height: 2,
        color: Colors.deepPurpleAccent,
      ),
      onChanged: (String? newValue) {
        setState(() {
          positionSelected = newValue!;
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
          if (positionSelected == "Employee") {
            authClass.signUpWithEmailPass(lastname.text + fisrtname.text,
                email.text, password.text, context);
            employeeServices.addEmployee(
              id.text,
              fisrtname.text + lastname.text,
              "${selectedDate.toLocal()}".split(' ')[0].replaceAll("-", "/"),
              phone.text,
              address.text,
              positionSelected,
              email.text,
              gender,
              _imageURL,
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
            });
            Navigator.pop(context);
          } else if (positionSelected == "Manager") {
            authClass.signUpWithEmailPass(lastname.text + fisrtname.text,
                email.text, password.text, context);
            managerServices.addManager(
                id.text,
                fisrtname.text + lastname.text,
                "${selectedDate.toLocal()}".split(' ')[0].replaceAll("-", "/"),
                phone.text,
                address.text,
                positionSelected,
                email.text,
                gender,
                _imageURL);
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
            });
            Navigator.pop(context);
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
