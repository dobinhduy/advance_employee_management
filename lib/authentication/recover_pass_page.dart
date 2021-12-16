import 'package:advance_employee_management/service/auth_services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

class RecoverPassword extends StatefulWidget {
  const RecoverPassword({Key? key}) : super(key: key);

  @override
  _RecoverPasswordState createState() => _RecoverPasswordState();
}

class _RecoverPasswordState extends State<RecoverPassword> {
  TextEditingController email = TextEditingController();
  AuthClass authClass = AuthClass();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
            gradient: LinearGradient(
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
          colors: [
            Colors.blue,
            Colors.green,
          ],
        )),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                "Forgot your password ?",
                style: TextStyle(
                    fontSize: 30,
                    color: Colors.white,
                    fontWeight: FontWeight.bold),
              ),
              const SizedBox(
                height: 15,
              ),
              const Text(
                "No worries! Enter your email and we will send you a reset.",
                style: TextStyle(
                    fontSize: 18,
                    color: Colors.white60,
                    fontWeight: FontWeight.normal),
              ),
              const SizedBox(
                height: 70,
              ),
              textItem("Input your email here....", email, false),
              const SizedBox(
                height: 30,
              ),
              sendButton(),
              const SizedBox(
                height: 15,
              ),
              goBackButton(),
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
          style: const TextStyle(color: Colors.white),
          decoration: InputDecoration(
            prefixIcon: const Icon(
              Icons.email_outlined,
              color: Colors.white,
            ),
            labelText: text,
            labelStyle: const TextStyle(fontSize: 15, color: Colors.white70),
            focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
                borderSide: const BorderSide(width: 1, color: Colors.amber)),
            enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
                borderSide: const BorderSide(width: 1, color: Colors.grey)),
          )),
    );
  }

  Widget sendButton() {
    return InkWell(
      onTap: () async {
        if (email.text.isEmpty) {
          EasyLoading.showInfo('Input your email...');
        } else {
          try {
            await FirebaseAuth.instance
                .sendPasswordResetEmail(email: email.text);
            EasyLoading.showInfo('Email was sended...');
            Navigator.pop(context);
          } catch (e) {
            authClass.showSnackBar(context, e.toString());
          }
        }
      },
      child: Container(
        width: MediaQuery.of(context).size.width / 4.5,
        height: 50,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(17),
            color: Colors.tealAccent[700]),
        child: const Center(
          child: Text(
            "Send Request",
            style: TextStyle(fontSize: 17, color: Colors.white),
          ),
        ),
      ),
    );
  }

  Widget goBackButton() {
    return InkWell(
      onTap: () async {
        Navigator.pop(context);
      },
      child: Container(
        width: MediaQuery.of(context).size.width / 4.5,
        height: 50,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(17),
            color: Colors.tealAccent[700]),
        child: const Center(
          child: Text(
            "Go Back",
            style: TextStyle(fontSize: 17, color: Colors.white),
          ),
        ),
      ),
    );
  }
}
