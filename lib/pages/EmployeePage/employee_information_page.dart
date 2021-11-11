import 'dart:typed_data';

import 'package:advance_employee_management/provider/table_provider.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_image/flutter_image.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:uuid/uuid.dart';

class UserInforPage extends StatefulWidget {
  const UserInforPage(
      {Key? key,
      required this.name,
      required this.email,
      required this.id,
      required this.photoURL,
      required this.birthday,
      required this.address,
      required this.gender})
      : super(key: key);
  final String name;
  final String email;
  final String birthday;
  final String address;
  final String id;
  final String photoURL;
  final String gender;

  @override
  State<UserInforPage> createState() => _UserInforPageState();
}

class _UserInforPageState extends State<UserInforPage> {
  late TextEditingController emailController;
  late TextEditingController nameController;
  late TextEditingController idController;
  late TextEditingController addressController;
  late TextEditingController nationController;
  String _imageURL = "";
  String dropDownvalue = 'Employee';
  List<String> listPosition = ['Employee', 'Manager'];

  DateTime selectedDate = DateTime.now();
  bool edit = false;
  bool male = false;
  bool female = false;
  bool timeup = false;
  bool editInfo = false;

  @override
  void initState() {
    super.initState();
    idController = TextEditingController(text: widget.id);
    emailController = TextEditingController(text: widget.email);
    nameController = TextEditingController(text: widget.name);
  }

  getImage() async {
    final ref = FirebaseStorage.instance.ref().child(widget.photoURL);
    _imageURL = await ref.getDownloadURL();
    setState(() {
      _imageURL = _imageURL;
    });
  }

  returnImage() {
    Future.delayed(const Duration(seconds: 5), () {
      setState(() {
        timeup = true;
      });
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
    getImage();
    returnImage();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueAccent,
        title: const Text("Employee Information"),
      ),
      body: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            SizedBox(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width / 4.2,
              child: Column(
                children: [
                  const SizedBox(
                    height: 150,
                  ),
                  timeup == true
                      ? Image.network(
                          _imageURL,
                          width: 300,
                          height: 300,
                        )
                      : const CircularProgressIndicator()
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
                  titlebox("Gender"),
                  titlebox("Birthday"),
                  titlebox("Address"),
                  titlebox("Position"),
                  titlebox("Email"),
                ],
              ),
            ),
            SizedBox(
              width: 50,
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
                  titlebox(widget.name),
                  titlebox(widget.gender),
                  titlebox(widget.birthday),
                  titlebox(widget.address),
                  titlebox("Employee"),
                  titlebox(widget.email),
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
                          onPressed: () {
                            setState(() {
                              editInfo = !editInfo;
                            });
                          },
                          icon: Icon(Icons.edit,
                              color: edit ? Colors.red : Colors.blue,
                              size: 28)),
                    ],
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height / 2,
                  width: MediaQuery.of(context).size.width / 5,
                )
              ],
            )
          ]),
    );
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
            });
          },
        ),
      ],
    );
  }
}
