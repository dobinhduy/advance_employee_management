import 'package:advance_employee_management/provider/table_provider.dart';
import 'package:advance_employee_management/rounting/route_names.dart';
import 'package:advance_employee_management/service/auth_services.dart';
import 'package:advance_employee_management/service/employee_service.dart';
import 'package:advance_employee_management/service/manager_service.dart';
import 'package:advance_employee_management/service/navigation_service.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:provider/provider.dart';

import '../../locator.dart';

class ManagerInPage extends StatefulWidget {
  const ManagerInPage(
      {Key? key,
      required this.name,
      required this.email,
      required this.id,
      required this.photoURL,
      required this.birthday,
      required this.address,
      required this.gender,
      required this.phone,
      required this.position})
      : super(key: key);
  final String name;
  final String email;
  final String birthday;
  final String address;
  final String id;
  final String photoURL;
  final String gender;
  final String phone;
  final String position;

  @override
  _ManagerInPageState createState() => _ManagerInPageState();
}

class _ManagerInPageState extends State<ManagerInPage> {
  late TextEditingController emailController;
  late TextEditingController nameController;
  late TextEditingController idController;
  late TextEditingController addressController;
  late TextEditingController phoneController;
  late String birthdayController;
  late String genderController;
  late String positionController;
  late String photoURLController;
  ManagerServices managerServices = ManagerServices();
  EmployeeServices employeeServices = EmployeeServices();
  String _imageURL = "";
  String dropDownvalue = 'Manager';
  List<String> listPosition = ['Employee', 'Manager'];

  DateTime selectedDate = DateTime.now();
  AuthClass authClass = AuthClass();

  bool male = false;
  bool female = false;
  bool timeup = false;

  bool editInfo = false;
  bool editName = false;
  bool editEmail = false;
  bool editAdd = false;
  bool editGender = false;
  bool editID = false;
  bool editPhone = false;
  bool editBirthday = false;
  bool editPosition = false;

  @override
  void initState() {
    super.initState();
    idController = TextEditingController(text: widget.id);
    emailController = TextEditingController(text: widget.email);
    nameController = TextEditingController(text: widget.name);
    phoneController = TextEditingController(text: widget.phone);
    addressController = TextEditingController(text: widget.address);
    genderController = widget.gender;
    birthdayController = widget.birthday;
    positionController = widget.position;
    photoURLController = widget.photoURL;
    if (genderController == "Male") {
      male = true;
    } else {
      female = true;
    }
  }

  getImage() async {
    final ref = FirebaseStorage.instance.ref().child(widget.photoURL);
    _imageURL = await ref.getDownloadURL();
    setState(() {});
  }

  _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2025),
    );
    if (picked != null && picked != selectedDate) {
      selectedDate = picked;
      birthdayController =
          "${selectedDate.toLocal()}".split(' ')[0].replaceAll("-", "/");
      setState(() {});
    }
  }

  updateManager() {
    setState(() {
      idController = idController;
      emailController = emailController;
      addressController = addressController;
      genderController = genderController;
      birthdayController = birthdayController;
      genderController = genderController;
      positionController = positionController;
      phoneController = phoneController;
      photoURLController = photoURLController;
    });
  }

  @override
  Widget build(BuildContext context) {
    getImage();
    TableProvider provider = Provider.of<TableProvider>(context);
    return Scaffold(
      backgroundColor: Colors.deepPurple[200],
      appBar: AppBar(
        backgroundColor: Colors.blueAccent,
        title: const Text("Manager Information"),
      ),
      body: Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: <
          Widget>[
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
              _imageURL != ""
                  ? Image.network(_imageURL,
                      width: 300, height: 300, fit: BoxFit.fill)
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
              titlebox("ID"),
              titlebox("Gender"),
              titlebox("Birthday"),
              titlebox("Address"),
              titlebox("Phone"),
              titlebox("Email"),
              titlebox("Position"),
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
              !editName
                  ? titlebox(nameController.text)
                  : inputBox(nameController, 20),
              !editID ? titlebox(idController.text) : inputBox(idController, 8),
              !editGender ? titlebox(genderController) : genderSelectedBox(),
              !editBirthday ? titlebox(birthdayController) : birthdayButton(35),
              !editAdd
                  ? titlebox(addressController.text)
                  : inputBox(addressController, 8),
              !editPhone
                  ? titlebox(phoneController.text)
                  : inputBox(phoneController, 8),
              titlebox(widget.email),
              !editPosition ? titlebox(positionController) : selectPosition(),
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
                          editAdd = !editAdd;
                          editBirthday = !editBirthday;
                          editEmail = !editEmail;
                          editGender = !editGender;
                          editID = !editID;
                          editName = !editName;
                          editPhone = !editPhone;
                          editPosition = !editPosition;
                        });
                      },
                      icon: Icon(Icons.edit,
                          color: editInfo ? Colors.blue : Colors.white,
                          size: 28)),
                ],
              ),
            ),
            const SizedBox(
              height: 350,
            ),
            editInfo
                ? InkWell(
                    onTap: () {
                      updateManager();
                      Map<String, dynamic> map = <String, dynamic>{};
                      map.addAll({
                        "id": idController.text,
                        "name": nameController.text,
                        "gender": genderController,
                        "birthday": birthdayController,
                        "email": emailController.text,
                        "address": addressController.text,
                        "phone": phoneController.text,
                        "photoURL": photoURLController,
                        "position": positionController,
                      });
                      if (positionController == "Employee") {
                        setState(() {
                          managerServices.deleteManager(emailController.text);
                          employeeServices.addEmployee(
                            idController.text,
                            nameController.text,
                            genderController,
                            birthdayController,
                            emailController.text,
                            phoneController.text,
                            addressController.text,
                            widget.photoURL,
                            positionController,
                          );
                          provider.employeeSource.add(map);
                          for (Map<String, dynamic> manager
                              in provider.managerSource) {
                            if (manager.values.elementAt(4) ==
                                emailController.text) {
                              provider.managerSource.remove(manager);
                            }
                          }
                        });
                      } else {
                        setState(() {
                          managerServices.updateManager(widget.email, map);
                          for (Map<String, dynamic> manager
                              in provider.managerSource) {
                            if (manager.values.elementAt(4) ==
                                emailController.text) {
                              manager.update(
                                "name",
                                (value) => nameController.text,
                              );
                              manager.update(
                                "id",
                                (value) => idController.text,
                              );
                              manager.update(
                                "address",
                                (value) => addressController.text,
                              );
                              manager.update(
                                "email",
                                (value) => emailController.text,
                              );
                              manager.update(
                                "phone",
                                (value) => phoneController.text,
                              );
                              manager.update(
                                "gender",
                                (value) => genderController,
                              );
                              manager.update(
                                "position",
                                (value) => positionController,
                              );
                              manager.update(
                                "birthday",
                                (value) => birthdayController,
                              );
                            }
                          }
                        });
                      }

                      authClass.showSnackBar(context, "Add success");
                      SchedulerBinding.instance?.addPostFrameCallback((_) {
                        Navigator.of(context)
                            .pushReplacementNamed(ManagerLayout);
                      });
                    },
                    child: Container(
                      height: 40,
                      width: 75,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: Colors.blueAccent),
                      child: Center(
                        child: Text(editInfo ? "Update" : "Ok"),
                      ),
                    ),
                  )
                : Container(),
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
          positionController = dropDownvalue;
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

  Widget birthdayButton(double size) {
    return Column(
      children: [
        SizedBox(
          height: size,
        ),
        Row(
          children: [
            Text(
              widget.birthday,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w300),
            ),
            const SizedBox(
              width: 20.0,
            ),
            ElevatedButton(
              onPressed: () => _selectDate(context),
              child: const Text(
                'Select date',
                style:
                    TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
        const SizedBox(
          height: 10,
        )
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

  Widget inputBox(TextEditingController controller, double size) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 15),
          child: SizedBox(
            height: 30,
            width: 200,
            child: TextFormField(
              enabled: true,
              controller: controller,
              decoration: const InputDecoration(
                contentPadding: EdgeInsets.symmetric(vertical: 15),
                border: UnderlineInputBorder(),
              ),
            ),
          ),
        ),
        SizedBox(
          height: size,
        )
      ],
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
          value: male,
          onChanged: (bool? value) {
            setState(() {
              female = false;
              male = true;
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
          value: female,
          onChanged: (bool? value) {
            setState(() {
              female = true;
              male = false;
            });
          },
        ),
      ],
    );
  }
}
