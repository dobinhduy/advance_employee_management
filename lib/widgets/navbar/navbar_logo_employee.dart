import 'package:advance_employee_management/service/auth_services.dart';
import 'package:advance_employee_management/service/employee_service.dart';
import 'package:flutter/material.dart';

class NavBarLogoEmployee extends StatefulWidget {
  const NavBarLogoEmployee({Key? key}) : super(key: key);

  @override
  State<NavBarLogoEmployee> createState() => _NavBarLogoEmployeeState();
}

class _NavBarLogoEmployeeState extends State<NavBarLogoEmployee> {
  EmployeeServices employeeServices = EmployeeServices();

  String email = AuthClass().user()!;

  String photoURL = "";
  String name = "";
  getPhotoURl() async {
    photoURL = await employeeServices.getphotoURL(email);
    setState(() {}); //????????
  }

  getName() async {
    name = await employeeServices.getEmployeeName(email);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    getName();
    getPhotoURl();
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 40),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
              height: 70,
              width: 70,
              child: photoURL != ""
                  ? CircleAvatar(
                      radius: 30,
                      backgroundImage: NetworkImage(photoURL),
                    )
                  : CircleAvatar(
                      radius: 30,
                      child: Image.asset(
                        "images/userimage.png",
                      ),
                    )),
          const SizedBox(
            height: 8,
          ),
          name != ""
              ? Text(
                  name,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 15),
                )
              : Container()
        ],
      ),
    );
  }
}
