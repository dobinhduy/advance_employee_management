import 'package:advance_employee_management/service/auth_services.dart';
import 'package:advance_employee_management/service/manager_service.dart';
import 'package:flutter/material.dart';

class NavBarLogoManager extends StatefulWidget {
  const NavBarLogoManager({Key? key}) : super(key: key);

  @override
  State<NavBarLogoManager> createState() => _NavBarLogoManagerState();
}

class _NavBarLogoManagerState extends State<NavBarLogoManager> {
  ManagerServices managerServices = ManagerServices();

  String email = AuthClass().user()!;
  String photoURL = "";
  getPhotoURl() async {
    photoURL = await managerServices.getphotoURL(email);
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
