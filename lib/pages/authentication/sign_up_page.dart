// ignore: file_names
import 'package:advance_employee_management/locator.dart';
import 'package:advance_employee_management/rounting/route_names.dart';
import 'package:advance_employee_management/service/auth_services.dart';
import 'package:advance_employee_management/service/navigation_service.dart';
import 'package:flutter/material.dart';

import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;

class SignUpPage extends StatefulWidget {
  const SignUpPage({Key? key}) : super(key: key);

  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  AuthClass authClass = AuthClass();
  firebase_auth.FirebaseAuth firebaseAuth = firebase_auth.FirebaseAuth.instance;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _name = TextEditingController();
  bool circular = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        physics: const ScrollPhysics(),
        child: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          color: Colors.white,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                "Sign Up",
                style: TextStyle(
                    fontSize: 35,
                    color: Colors.black,
                    fontWeight: FontWeight.bold),
              ),
              const SizedBox(
                height: 20,
              ),
              buttonItem("images/google.png", "Continue with google", 25,
                  () async {
                authClass.googleSignIn(context);
              }),
              buttonItem("images/phone.png", "Continue with Phone", 25, () {
                locator<NavigationService>()
                    .globalNavigateTo(PhoneAuthLog, context);
              }),
              const SizedBox(
                height: 15,
              ),
              const Text(
                'Or',
                style: TextStyle(color: Colors.black, fontSize: 20),
              ),
              const SizedBox(
                height: 15,
              ),
              textItem("Name", _name, false),
              const SizedBox(
                height: 15,
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
                height: 15,
              ),
              colorButton(),
              const SizedBox(
                height: 15,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "If you already have an account?",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      locator<NavigationService>()
                          .globalNavigateTo(LonginRoute, context);
                    },
                    child: const Text(
                      "Login",
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
      width: MediaQuery.of(context).size.width / 3,
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

  Widget colorButton() {
    return InkWell(
      onTap: () async {
        setState(() {
          circular = true;
        });
        try {
          authClass.signUpWithEmailPass(_name.text, _emailController.text,
              _passwordController.text, context);

          setState(() {
            circular = false;
          });
        } catch (e) {
          final snackbar = SnackBar(content: Text(e.toString()));
          ScaffoldMessenger.of(context).showSnackBar(snackbar);
          setState(() {
            circular = false;
          });
        }
      },
      child: Container(
        width: MediaQuery.of(context).size.width / 3,
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
                  "Sign Up",
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
        width: MediaQuery.of(context).size.width / 3,
        height: 60,
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
