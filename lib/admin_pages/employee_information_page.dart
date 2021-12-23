import 'package:advance_employee_management/models/employee.dart';
import 'package:advance_employee_management/provider/table_provider.dart';
import 'package:advance_employee_management/provider/theme_provider.dart';
import 'package:advance_employee_management/rounting/route_names.dart';
import 'package:advance_employee_management/service/auth_services.dart';
import 'package:advance_employee_management/service/department_service.dart';
import 'package:advance_employee_management/service/employee_service.dart';
import 'package:advance_employee_management/service/project_service.dart';
import 'package:advance_employee_management/widgets/change_button/change_theme_button.dart';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';

class UserInforPage extends StatefulWidget {
  const UserInforPage(
      {Key? key,
      required this.name,
      required this.email,
      required this.id,
      required this.photoURL,
      required this.birthday,
      required this.address,
      required this.gender,
      required this.phone,
      required this.role,
      required this.department,
      required this.supID})
      : super(key: key);
  final String name;
  final String email;
  final String birthday;
  final String address;
  final String id;
  final String photoURL;
  final String gender;
  final String phone;
  final String role;
  final String department;
  final String supID;

  @override
  State<UserInforPage> createState() => _UserInforPageState();
}

class _UserInforPageState extends State<UserInforPage> {
  late TextEditingController emailController;
  late TextEditingController nameController;
  late TextEditingController idController;
  late TextEditingController addressController;
  late TextEditingController phoneController;
  late TextEditingController supervisorIDController;
  late String birthdayController;
  late String genderController;
  EmployeeModel? employeeInfor;
  EmployeeServices employeeServices = EmployeeServices();
  ProjectService projectService = ProjectService();
  DepartmentService departmentService = DepartmentService();
  AuthClass authClass = AuthClass();

  late String photoURLController;

  List<String> listDepartment = [];
  String _imageURL = "";
  String role = "";
  String managerIDcontroller = "";
  String departmentName = "";
  String? dropdownDeName;
  String? dropDownRole;
  bool isChange = false;

  getAllDepartmentName() async {
    listDepartment = await departmentService.getAllDepartmentName();
    if (mounted) {
      setState(() {});
    }
  }

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
    Future.delayed(const Duration(seconds: 1), () {});
    managerIDcontroller = await employeeServices.getSupervisorID(widget.id);
    if (mounted) {
      setState(() {});
    }
  }

  @override
  void initState() {
    super.initState();

    idController = TextEditingController(text: widget.id);
    emailController = TextEditingController(text: widget.email);
    nameController = TextEditingController(text: widget.name);
    phoneController = TextEditingController(text: widget.phone);
    addressController = TextEditingController(text: widget.address);
    supervisorIDController = TextEditingController(text: widget.supID);
    genderController = widget.gender;
    birthdayController = widget.birthday;
    photoURLController = widget.photoURL;
    departmentName = widget.department;
    role = widget.role;

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
          role = dropDownRole!;
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

  Widget selectDepartment() {
    return DropdownButton<String>(
      value: dropdownDeName,
      iconSize: 24,
      elevation: 16,
      style: const TextStyle(color: Colors.deepPurple),
      underline: Container(
        height: 2,
        color: Colors.deepPurpleAccent,
      ),
      onChanged: (String? newValue) {
        setState(() {
          dropdownDeName = newValue!;
          departmentName = dropdownDeName!;
        });
      },
      items: listDepartment.map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
    );
  }

  updateEmployee() {
    setState(() {
      idController = idController;
      emailController = emailController;
      addressController = addressController;
      genderController = genderController;
      birthdayController = birthdayController;
      genderController = genderController;
      supervisorIDController = supervisorIDController;
      phoneController = phoneController;
      photoURLController = photoURLController;
    });
  }

  checkFinishAllProject() async {
    isChange = await projectService.checkFinishAllProject(widget.id);
    if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    getImage();
    getEmployeeInf();
    getAllDepartmentName();
    checkFinishAllProject();
    isLoading();

    ThemeProvider themeProvider = Provider.of<ThemeProvider>(context);
    TableProvider provider = Provider.of<TableProvider>(context);
    return loading == false
        ? Scaffold(
            appBar: AppBar(
              leading: BackButton(
                  color:
                      themeProvider.isLightMode ? Colors.black : Colors.white),
              backgroundColor:
                  themeProvider.isLightMode ? Colors.brown[50] : Colors.black,
              title: Text(
                "Employee Information",
                style: TextStyle(
                    color: themeProvider.isLightMode
                        ? Colors.black
                        : Colors.white),
              ),
            ),
            body: SingleChildScrollView(
              child: Column(
                children: [
                  Row(
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
                                  : const Padding(
                                      padding: EdgeInsets.only(top: 50),
                                      child: SpinKitFadingCircle(
                                        color: Colors.green,
                                      ),
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
                                    isEdit == true && isChange
                                        ? selectDepartment()
                                        : inputBox2(departmentName)
                                  ],
                                ),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    titlebox("Role:"),
                                    isEdit == false
                                        ? inputBox2(role)
                                        : selectedRole(),
                                  ],
                                ),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    titlebox("Supervisor ID:"),
                                    isEdit == true && isChange
                                        ? inputBox(supervisorIDController, 10)
                                        : inputBox2(managerIDcontroller)
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
                                          color:
                                              isEdit ? Colors.red : Colors.blue,
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
                                      bool isExist = await employeeServices
                                          .checkExistEmployeebyID(
                                              supervisorIDController.text);

                                      if (checkFill()) {
                                        if (isExist) {
                                          Map<String, dynamic> map =
                                              <String, dynamic>{};
                                          map.addAll({
                                            "name": nameController.text,
                                            "gender": genderController,
                                            "birthday": birthdayController,
                                            "email": emailController.text,
                                            "address": addressController.text,
                                            "phone": phoneController.text,
                                            "role": role,
                                            "department": departmentName,
                                            "supervisorid":
                                                supervisorIDController.text
                                          });

                                          setState(() {
                                            employeeServices.updateEmployee(
                                                widget.email, map);
                                            for (Map<String, dynamic> employee
                                                in provider.employeeSource) {
                                              if (employee.values
                                                      .elementAt(4) ==
                                                  emailController.text) {
                                                employee.update(
                                                  "name",
                                                  (value) =>
                                                      nameController.text,
                                                );
                                                employee.update(
                                                  "id",
                                                  (value) => idController.text,
                                                );
                                                employee.update(
                                                  "address",
                                                  (value) =>
                                                      addressController.text,
                                                );
                                                employee.update(
                                                  "email",
                                                  (value) =>
                                                      emailController.text,
                                                );
                                                employee.update(
                                                  "phone",
                                                  (value) =>
                                                      phoneController.text,
                                                );
                                                employee.update(
                                                  "gender",
                                                  (value) => genderController,
                                                );

                                                employee.update(
                                                  "birthday",
                                                  (value) => birthdayController,
                                                );
                                                employee.update(
                                                    "role", (value) => role);
                                                employee.update("department",
                                                    (value) => departmentName);
                                              }
                                            }
                                          });

                                          await EasyLoading.showSuccess(
                                              'Update Success!');
                                          SchedulerBinding.instance
                                              ?.addPostFrameCallback((_) {
                                            Navigator.of(context)
                                                .pushReplacementNamed(
                                                    EmployeeLayout);
                                          });
                                        } else {
                                          authClass.showSnackBar(context,
                                              "Supervisor ID is not exsit");
                                        }
                                      } else {
                                        authClass.showSnackBar(context,
                                            "Please fill all information!!");
                                      }
                                    },
                                    child: Container(
                                      height: 40,
                                      width: 75,
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(20),
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
                ],
              ),
            ),
          )
        : Container(
            color: themeProvider.isLightMode ? Colors.white : Colors.brown,
            child: Column(
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
            ),
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

  bool checkFill() {
    if (nameController.text.isEmpty ||
        genderController.isEmpty ||
        addressController.text.isEmpty ||
        phoneController.text.isEmpty ||
        supervisorIDController.text.isEmpty) {
      return false;
    }
    return true;
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
