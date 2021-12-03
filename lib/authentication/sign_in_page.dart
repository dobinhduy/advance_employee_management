// ignore: file_names

import 'package:advance_employee_management/rounting/route_names.dart';
import 'package:advance_employee_management/service/admin_service.dart';
import 'package:advance_employee_management/service/auth_services.dart';
import 'package:advance_employee_management/service/employee_service.dart';
import 'package:advance_employee_management/service/navigation_service.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;

import '../../locator.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({Key? key}) : super(key: key);

  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignInPage> {
  firebase_auth.FirebaseAuth firebaseAuth = firebase_auth.FirebaseAuth.instance;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  EmployeeServices employeeServices = EmployeeServices();
  AdminService adminService = AdminService();

  bool circular = false;
  AuthClass authClass = AuthClass();
  String position = "";
  String employeeID = "";
  // checkisEmployee(String email) async {
  //   bool isEmployee = await employeeServices.checkExistEmployee(email);
  //   if (isEmployee) {
  //     setState(() {
  //       position = "Employee";
  //     });
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        physics: const ScrollPhysics(),
        child: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment(
                  0.8, 0.0), // 10% of the width, so there are ten blinds.
              colors: <Color>[
                Color(0xFFB2EBF2),
                Color(0xFF81D4FA)
              ], // red to yellow
              tileMode:
                  TileMode.repeated, // repeats the gradient over the canvas
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                "Sign In",
                style: TextStyle(
                    fontSize: 35,
                    color: Colors.black,
                    fontWeight: FontWeight.bold),
              ),
              const SizedBox(
                height: 40,
              ),
              usernameBox("Email", _emailController, false),
              const SizedBox(
                height: 15,
              ),
              passwordBox("Password", _passwordController, false),
              const SizedBox(
                height: 30,
              ),
              loginButton(),
              const SizedBox(
                height: 15,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  InkWell(
                    onTap: () {
                      locator<NavigationService>()
                          .globalNavigateTo(RecoverPassRoute, context);
                    },
                    child: const Text(
                      "Forget Password ?",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget usernameBox(
      String text, TextEditingController controller, bool obscureText) {
    return SizedBox(
      width: MediaQuery.of(context).size.width / 4.5,
      height: 50,
      child: TextFormField(
          controller: controller,
          obscureText: obscureText,
          style: const TextStyle(color: Colors.black),
          decoration: InputDecoration(
            prefixIcon: const Icon(
              Icons.people,
              color: Colors.black,
            ),
            labelText: text,
            labelStyle: const TextStyle(fontSize: 17, color: Colors.black),
            focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
                borderSide: const BorderSide(width: 1, color: Colors.amber)),
            enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
                borderSide: const BorderSide(width: 1, color: Colors.grey)),
          )),
    );
  }

  Widget passwordBox(
      String text, TextEditingController controller, bool obscureText) {
    return SizedBox(
      width: MediaQuery.of(context).size.width / 4.5,
      height: 50,
      child: TextFormField(
          controller: controller,
          obscureText: obscureText,
          style: const TextStyle(color: Colors.black),
          decoration: InputDecoration(
            prefixIcon: const Icon(
              Icons.vpn_key,
              color: Colors.black,
            ),
            labelText: text,
            labelStyle: const TextStyle(fontSize: 17, color: Colors.black),
            focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
                borderSide: const BorderSide(width: 1, color: Colors.amber)),
            enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
                borderSide: const BorderSide(width: 1, color: Colors.grey)),
          )),
    );
  }

  Widget loginButton() {
    return InkWell(
      onTap: () async {
        setState(() {
          circular = true;
        });

        try {
          bool isAdmin = await adminService.getPosition(_emailController.text);

          employeeID = await employeeServices
              .getEmployeeIDbyEmail(_emailController.text);
          bool isManager = await employeeServices.checkhasEmployee(employeeID);
          await firebaseAuth.signInWithEmailAndPassword(
              email: _emailController.text, password: _passwordController.text);
          setState(() {
            circular = true;
          });

          if (isAdmin) {
            locator<NavigationService>()
                .globalNavigateTo(AdLayOutRoute, context);
          } else if (isManager) {
            locator<NavigationService>()
                .globalNavigateTo(ManagerRouteLayout, context);
          } else {
            locator<NavigationService>()
                .globalNavigateTo(EmployeeRouteLayout, context);
          }
        } catch (e) {
          final snackbar = SnackBar(content: Text(e.toString()));
          AuthClass().showSnackBar(context, "Invalid email or password");
          setState(() {
            circular = false;
          });
        }
      },
      child: Container(
        width: MediaQuery.of(context).size.width / 4.5,
        height: 60,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(17), color: Colors.blueAccent),
        child: Center(
          child: circular
              ? const CircularProgressIndicator()
              : const Text(
                  "Login",
                  style: TextStyle(fontSize: 17, color: Colors.white),
                ),
        ),
      ),
    );
  }

  Widget buttonItem(
      String imagepath, String buttonName, double size, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: SizedBox(
        width: MediaQuery.of(context).size.width / 10,
        height: 50,
        child: Card(
          color: Colors.white,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
              side: const BorderSide(width: 1, color: Colors.grey)),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                imagepath,
                height: size,
                width: size,
              ),
              const SizedBox(
                width: 10,
              ),
              Text(
                buttonName,
                style: const TextStyle(color: Colors.black),
              ),
            ],
          ),
        ),
      ),
    );
  }
}