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
  String name = "";
  String photoURL = "";
  getPhotoURl() async {
    photoURL = await managerServices.getphotoURL(email);
    setState(() {}); //????????
  }

  getName() async {
    name = await managerServices.getEmployeeName(email);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    getPhotoURl();
    getName();
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
                : Container(),
          ),
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
