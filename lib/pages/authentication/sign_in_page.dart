// ignore: file_names

import 'package:advance_employee_management/pages/Admin_Manager_page/manager_information_page.dart';
import 'package:advance_employee_management/rounting/route_names.dart';
import 'package:advance_employee_management/service/auth_services.dart';
import 'package:advance_employee_management/service/employee_service.dart';
import 'package:advance_employee_management/service/manager_service.dart';
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
  ManagerServices managerServices = ManagerServices();

  bool circular = false;
  AuthClass authClass = AuthClass();
  bool isEmployee = false;
  bool isManager = false;
  checkisEmployee(String email) async {
    isEmployee = await employeeServices.checkExistEmployee(email);
  }

  checkisManager(String email) async {
    isManager = await managerServices.checkExisManager(email);
  }

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
                Color(0xffee0000),
                Color(0xffeeee00)
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
              textItem("Email", _emailController, false),
              const SizedBox(
                height: 15,
              ),
              textItem("Password", _passwordController, false),
              const SizedBox(
                height: 15,
              ),
              const SizedBox(
                height: 20,
              ),
              const Text(
                'Or continute with',
                style: TextStyle(color: Colors.black, fontSize: 20),
              ),
              const SizedBox(
                height: 15,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  buttonItem(
                    "images/google.png",
                    "Google",
                    25,
                    () {
                      authClass.googleSignIn(context);
                    },
                  ),
                  const SizedBox(
                    width: 30,
                  ),
                  buttonItem("images/phone.png", "Phone", 25, () {
                    locator<NavigationService>()
                        .globalNavigateTo(PhoneAuthLog, context);
                  }),
                ],
              ),
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
                  const Text(
                    "If you don't have an account?",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                    ),
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                  InkWell(
                    onTap: () {
                      locator<NavigationService>()
                          .globalNavigateTo(SignupRoute, context);
                    },
                    child: const Text(
                      "Sign up",
                      // ignore: unnecessary_const
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
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

  Widget textItem(
      String text, TextEditingController controller, bool obscureText) {
    return SizedBox(
      width: MediaQuery.of(context).size.width / 4.5,
      height: 50,
      child: TextFormField(
          controller: controller,
          obscureText: obscureText,
          style: const TextStyle(color: Colors.black),
          decoration: InputDecoration(
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
        checkisEmployee(_emailController.text);
        checkisManager(_emailController.text);
        setState(() {
          circular = true;
        });
        try {
          await firebaseAuth.signInWithEmailAndPassword(
              email: _emailController.text, password: _passwordController.text);
          setState(() {
            circular = true;
          });
          if (isEmployee) {
            print(isEmployee);
            locator<NavigationService>()
                .globalNavigateTo(EmployeeRouteLayout, context);
          } else if (isManager) {
            locator<NavigationService>()
                .globalNavigateTo(ManagerRouteLayout, context);
          } else {
            locator<NavigationService>()
                .globalNavigateTo(AdLayOutRoute, context);
          }
        } catch (e) {
          final snackbar = SnackBar(content: Text(e.toString()));
          ScaffoldMessenger.of(context).showSnackBar(snackbar);
          setState(() {
            circular = false;
          });
        }
      },
      child: Container(
        width: MediaQuery.of(context).size.width / 4.5,
        height: 60,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(17),
          gradient: const LinearGradient(colors: [
            Color(0xfffd746c),
            Color(0xffff9068),
            Color(0xfffd746c)
          ]),
        ),
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
