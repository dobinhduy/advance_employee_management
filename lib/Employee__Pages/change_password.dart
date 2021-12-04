import 'package:advance_employee_management/authentication/sign_in_page.dart';
import 'package:advance_employee_management/locator.dart';
import 'package:advance_employee_management/rounting/route_names.dart';
import 'package:advance_employee_management/service/auth_services.dart';
import 'package:advance_employee_management/service/navigation_service.dart';
import 'package:flutter/material.dart';

class ChangePasswordPage extends StatefulWidget {
  const ChangePasswordPage({Key? key}) : super(key: key);

  @override
  _ChangePasswordPageState createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends State<ChangePasswordPage> {
  TextEditingController currentPassword = TextEditingController();
  TextEditingController newPassword = TextEditingController();
  TextEditingController confirmNewPassword = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.purpleAccent,
          automaticallyImplyLeading: false,
          title: const Text("Change Password"),
        ),
        body: Container(
          color: Colors.blue[200],
          child: Center(
            child: Container(
              color: Colors.white,
              width: 800,
              height: 400,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    width: 300,
                    height: 400,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(
                          height: 20,
                        ),
                        const Text("Change Password",
                            style: TextStyle(
                                fontSize: 25, fontWeight: FontWeight.bold)),
                        const SizedBox(
                          height: 10,
                        ),
                        const Text("Password must contains:"),
                        const SizedBox(
                          height: 25,
                        ),
                        TextFormField(
                          decoration: const InputDecoration(
                            prefixIcon: Icon(Icons.check),
                          ),
                          initialValue: 'At Least 6 characters',
                          readOnly: true,
                        ),
                        TextFormField(
                          decoration: const InputDecoration(
                            prefixIcon: Icon(Icons.check),
                          ),
                          initialValue: 'At least 1 upper case letter(A-Z)',
                          readOnly: true,
                        ),
                        TextFormField(
                          decoration: const InputDecoration(
                            prefixIcon: Icon(Icons.check),
                          ),
                          initialValue: 'At Least 1 lower case letter(A-Z)',
                          readOnly: true,
                        ),
                        TextFormField(
                          decoration: const InputDecoration(
                            prefixIcon: Icon(Icons.check),
                          ),
                          initialValue: 'At Least 1 number(0-9)',
                          readOnly: true,
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.only(left: 50, top: 70),
                    width: 300,
                    height: 400,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        inputBox("Current Password", currentPassword, true),
                        inputBox("New Password", newPassword, true),
                        inputBox(
                            "Re-type New Password", confirmNewPassword, true),
                        const SizedBox(
                          height: 20,
                        ),
                        saveButton(),
                        const SizedBox(
                          height: 10,
                        ),
                        cancleButton()
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ));
  }

  Widget inputBox(
      String text, TextEditingController controller, bool obscureText) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: SizedBox(
        width: 250,
        height: 38,
        child: TextFormField(
            controller: controller,
            obscureText: obscureText,
            style: const TextStyle(color: Colors.black),
            decoration: InputDecoration(
              hintText: text,
              labelStyle: const TextStyle(fontSize: 17, color: Colors.black),
              focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(width: 1, color: Colors.blue)),
              enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(width: 1, color: Colors.grey)),
            )),
      ),
    );
  }

  Widget saveButton() {
    return InkWell(
      onTap: () async {
        if (newPassword.text == confirmNewPassword.text) {
          if (validPassword(newPassword.text)) {
            bool result = await AuthClass().validateCurrentPassword(
                currentPassword.text, newPassword.text, context);
            if (!result) {
              AuthClass().showSnackBar(
                  context, "Change password success. Please login again!!");

              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (builder) => const SignInPage()),
                  (route) => false);
            } else {
              AuthClass().showSnackBar(context,
                  "Current Password is not correct. Please try again!!");
            }
          } else {
            AuthClass().showSnackBar(
                context, "Password is not safety. Please try another password");
          }
        } else {
          AuthClass().showSnackBar(context, "Password is not match");
        }
      },
      child: Container(
        width: MediaQuery.of(context).size.width / 4.5,
        height: 30,
        decoration: BoxDecoration(
          color: Colors.blueAccent[700],
        ),
        child: const Center(
          child: Text(
            "SAVE",
            style: TextStyle(fontSize: 18, color: Colors.white),
          ),
        ),
      ),
    );
  }

  bool validPassword(String value) {
    String pattern =
        r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$';
    RegExp regExp = RegExp(pattern);
    return regExp.hasMatch(value);
  }

  Widget cancleButton() {
    return InkWell(
      hoverColor: Colors.blueAccent[700],
      onTap: () async {
        Navigator.pop(context);
      },
      child: Container(
        width: MediaQuery.of(context).size.width / 4.5,
        height: 30,
        decoration: const BoxDecoration(
          color: Colors.white,
        ),
        child: const Center(
          child: Text(
            "CANCEL",
            style: TextStyle(fontSize: 18, color: Colors.black),
          ),
        ),
      ),
    );
  }
}
