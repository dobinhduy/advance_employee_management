import 'dart:js';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class UserInforPage extends StatefulWidget {
  const UserInforPage(
      {Key? key, required this.name, required this.email, required this.id})
      : super(key: key);
  final String name;
  final String email;
  final String id;

  @override
  State<UserInforPage> createState() => _UserInforPageState();
}

class _UserInforPageState extends State<UserInforPage> {
  late TextEditingController emailController;
  late TextEditingController nameController;
  late TextEditingController idController;
  late TextEditingController addressController;
  late TextEditingController nationController;
  bool edit = false;
  bool male = false;
  bool female = false;
  @override
  void initState() {
    super.initState();
    idController = TextEditingController(text: widget.id);
    emailController = TextEditingController(text: widget.email);
    nameController = TextEditingController(text: widget.name);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Flutter Row Example"),
      ),
      body: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width / 3,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 50, vertical: 50),
                child: Column(
                  children: [
                    Image.asset("images/dog.jpg"),
                  ],
                ),
              ),
            ),
            Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width / 2,
              decoration: const BoxDecoration(
                  gradient: LinearGradient(colors: [
                Colors.white,
                Colors.blue,
              ])),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(
                      height: 30,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 25, vertical: 25),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              titlebox("Name"),
                              const SizedBox(
                                width: 40,
                              ),
                              inputBox(nameController),
                            ],
                          ),
                          const SizedBox(height: 25),
                          Row(
                            children: [
                              gender(),
                            ],
                          ),
                          const SizedBox(height: 35),
                          Row(
                            children: [
                              titlebox("Birthday"),
                            ],
                          ),
                          const SizedBox(height: 25),
                          Row(
                            children: [
                              titlebox("Address"),
                              SizedBox(
                                width: 15,
                              ),
                              inputBox(idController),
                            ],
                          ),
                          const SizedBox(height: 25),
                          Row(
                            children: [
                              titlebox("Position"),
                            ],
                          ),
                          const SizedBox(height: 25),
                          Row(
                            children: [
                              titlebox("Email"),
                              const SizedBox(
                                width: 40,
                              ),
                              inputBox(emailController),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ]),
    );
  }

  Widget titlebox(String title) {
    return Text(
      title,
      style: const TextStyle(
        color: Colors.black,
        fontSize: 17,
        letterSpacing: 2,
      ),
    );
  }

  Widget inputBox(TextEditingController controller) {
    return Container(
      height: 45,
      width: 200,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: Colors.white10,
      ),
      child: TextFormField(
        controller: controller,
        maxLines: 1,
        style: const TextStyle(color: Colors.grey, fontSize: 17),
        decoration: const InputDecoration(
          border: InputBorder.none,
        ),
      ),
    );
  }

  Widget gender() {
    return Container(
      child: Row(
        children: [
          titlebox("Gender"),
          SizedBox(
            width: 80,
          ),
          titlebox("Male "),
          SizedBox(
            width: 10,
          ),
          Checkbox(
            checkColor: Colors.black,
            activeColor: Colors.red,
            value: female,
            onChanged: (bool? value) {
              setState(() {
                female = true;
                male = false;
              });
            },
          ),
          SizedBox(
            width: 30,
          ),
          titlebox("Female "),
          SizedBox(
            width: 10,
          ),
          Checkbox(
            checkColor: Colors.black,
            activeColor: Colors.red,
            value: male,
            onChanged: (bool? value) {
              setState(() {
                male = true;
                female = false;
              });
            },
          ),
        ],
      ),
    );
  }
}
