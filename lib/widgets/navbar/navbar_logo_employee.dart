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
  getPhotoURl() async {
    photoURL = await employeeServices.getphotoURL(email);
    setState(() {}); //????????
  }

  @override
  Widget build(BuildContext context) {
    getPhotoURl();
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 40),
      child: SizedBox(
        height: 50,
        width: 100,
        child: photoURL != ""
            ? Image.network(
                photoURL,
                width: 100,
                height: 100,
              )
            : const CircularProgressIndicator(),
      ),
    );
  }
}
