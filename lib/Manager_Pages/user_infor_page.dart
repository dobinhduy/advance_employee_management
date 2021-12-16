import 'package:advance_employee_management/models/employee.dart';
import 'package:advance_employee_management/provider/table_provider.dart';
import 'package:advance_employee_management/rounting/route_names.dart';
import 'package:advance_employee_management/service/auth_services.dart';
import 'package:advance_employee_management/service/employee_service.dart';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';

class EmployeeInfor extends StatefulWidget {
  const EmployeeInfor(
      {Key? key,
      required this.name,
      required this.email,
      required this.id,
      required this.photoURL,
      required this.birthday,
      required this.address,
      required this.gender,
      required this.phone,
      required this.position,
      required this.department})
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
  final String department;

  @override
  State<EmployeeInfor> createState() => _EmployeeInforState();
}

class _EmployeeInforState extends State<EmployeeInfor> {
  late TextEditingController emailController;
  late TextEditingController nameController;
  late TextEditingController idController;
  late TextEditingController addressController;
  late TextEditingController phoneController;
  late String birthdayController;
  late String genderController;
  EmployeeModel? employeeInfor;
  EmployeeServices employeeServices = EmployeeServices();
  AuthClass authClass = AuthClass();

  late String photoURLController;
  String department = "";
  List<String> listDepartment = [];

  String _imageURL = "";
  String role = "";
  String managerIDcontroller = "";

  DateTime selectedDate = DateTime.now();

  bool male = false;
  bool female = false;
  bool isEdit = false;
  bool loading = true;
  isLoading() {
    Future.delayed(const Duration(seconds: 1), () {
      if (mounted) {
        setState(() {
          loading = false;
        });
      }
    });
  }

  getEmployeeInf() async {
    employeeInfor = await employeeServices.getEmployeebyEmail(widget.email);
    Future.delayed(const Duration(seconds: 1), () {});
    managerIDcontroller = await employeeServices.getSupervisorID(widget.id);
    role = employeeInfor!.role;
    if (mounted) {
      setState(() {});
    }
  }

  @override
  void initState() {
    super.initState();
    getEmployeeInf();

    idController = TextEditingController(text: widget.id);
    emailController = TextEditingController(text: widget.email);
    nameController = TextEditingController(text: widget.name);
    phoneController = TextEditingController(text: widget.phone);
    addressController = TextEditingController(text: widget.address);
    genderController = widget.gender;
    birthdayController = widget.birthday;
    photoURLController = widget.photoURL;
    department = widget.department;

    if (genderController == "Male") {
      male = true;
    } else {
      female = true;
    }
  }

  getImage() async {
    final ref = FirebaseStorage.instance.ref().child(widget.photoURL);
    _imageURL = await ref.getDownloadURL();
    if (mounted) {
      setState(() {});
    }
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
      if (mounted) {
        setState(() {});
      }
    }
  }

  updateEmployee() {
    if (mounted) {
      setState(() {
        idController = idController;
        emailController = emailController;
        addressController = addressController;
        genderController = genderController;
        birthdayController = birthdayController;
        genderController = genderController;

        phoneController = phoneController;
        photoURLController = photoURLController;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    getImage();
    getEmployeeInf();
    isLoading();

    TableProvider provider = Provider.of<TableProvider>(context);
    return loading == false
        ? Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBar(
              backgroundColor: Colors.deepPurple,
              title: const Text("Employee Information"),
            ),
            body: SingleChildScrollView(
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
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
                            height: 100,
                          ),
                          _imageURL != ""
                              ? Image.network(_imageURL,
                                  width: 300, height: 300, fit: BoxFit.fill)
                              : const SpinKitSpinningLines(
                                  color: Colors.black,
                                  size: 50,
                                )
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
                                isEdit == false
                                    ? inputBox2(nameController.text)
                                    : inputBox(nameController, 20),
                              ],
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                titlebox("Address:"),
                                isEdit == false
                                    ? inputBox2(addressController.text)
                                    : inputBox(addressController, 8),
                              ],
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                titlebox("Gender:"),
                                isEdit == false
                                    ? inputBox2(genderController)
                                    : genderSelectedBox(),
                              ],
                            )
                          ]),
                          TableRow(children: [
                            Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                titlebox("Birthday:"),
                                isEdit == false
                                    ? inputBox2(birthdayController)
                                    : birthdayButton(15)
                              ],
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                titlebox("Identification Number:"),
                                inputBox2(idController.text)
                              ],
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                titlebox("Phone:"),
                                isEdit == false
                                    ? inputBox2(phoneController.text)
                                    : inputBox(phoneController, 8),
                              ],
                            )
                          ]),
                          TableRow(children: [
                            Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                titlebox("Department:"),
                                inputBox2(department)
                              ],
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [titlebox("Role:"), inputBox2(role)],
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                titlebox("Supervisor ID:"),
                                inputBox2(managerIDcontroller)
                              ],
                            )
                          ])
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
                          width: 50,
                          child: Column(
                            children: [
                              IconButton(
                                  onPressed: () {
                                    if (mounted) {
                                      setState(() {
                                        isEdit = !isEdit;
                                      });
                                    }
                                  },
                                  icon: Icon(Icons.edit,
                                      color: isEdit ? Colors.red : Colors.blue,
                                      size: 28)),
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 350,
                        ),
                        isEdit
                            ? InkWell(
                                onTap: () async {
                                  //Update controller
                                  updateEmployee();
                                  Map<String, dynamic> map =
                                      <String, dynamic>{};
                                  map.addAll({
                                    "id": idController.text,
                                    "name": nameController.text,
                                    "gender": genderController,
                                    "birthday": birthdayController,
                                    "email": emailController.text,
                                    "address": addressController.text,
                                    "phone": phoneController.text,
                                    "photourl": photoURLController,
                                  });

                                  setState(() {
                                    employeeServices.updateEmployeeManager(
                                        widget.email, map);
                                    for (Map<String, dynamic> employee
                                        in provider.employeeSource) {
                                      if (employee.values.elementAt(4) ==
                                          emailController.text) {
                                        employee.update(
                                          "name",
                                          (value) => nameController.text,
                                        );
                                        employee.update(
                                          "id",
                                          (value) => idController.text,
                                        );
                                        employee.update(
                                          "address",
                                          (value) => addressController.text,
                                        );
                                        employee.update(
                                          "email",
                                          (value) => emailController.text,
                                        );
                                        employee.update(
                                          "phone",
                                          (value) => phoneController.text,
                                        );
                                        employee.update(
                                          "gender",
                                          (value) => genderController,
                                        );

                                        employee.update(
                                          "birthday",
                                          (value) => birthdayController,
                                        );
                                        employee.update("department",
                                            (value) => department);
                                      }
                                    }
                                  });

                                  await EasyLoading.showSuccess(
                                      'Update Success!');
                                  SchedulerBinding.instance
                                      ?.addPostFrameCallback((_) {
                                    Navigator.of(context).pushReplacementNamed(
                                        EmployeeOfManagerPageRoute);
                                  });
                                },
                                child: Container(
                                  height: 40,
                                  width: 75,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20),
                                      color: Colors.blueAccent),
                                  child: Center(
                                    child: Text(isEdit ? "Update" : "Ok"),
                                  ),
                                ),
                              )
                            : Container(),
                      ],
                    )
                  ]),
            ),
          )
        : Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: const [
              SizedBox(
                width: 50,
                height: 50,
                child: SpinKitChasingDots(
                  color: Colors.purpleAccent,
                ),
              ),
            ],
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
              birthdayController,
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

  Widget titlebox2(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 22),
      child: Text(
        title,
        style: const TextStyle(
          color: Colors.black,
          fontSize: 15,
          letterSpacing: 2,
        ),
      ),
    );
  }

  Widget inputBox(TextEditingController controller, double size) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 10),
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

  Widget inputBox2(String text) {
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
          value: male,
          onChanged: (bool? value) {
            setState(() {
              female = false;
              male = true;
              genderController = "Male";
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
          value: female,
          onChanged: (bool? value) {
            setState(() {
              male = false;
              female = true;
              genderController = "Female";
            });
          },
        ),
      ],
    );
  }
}
