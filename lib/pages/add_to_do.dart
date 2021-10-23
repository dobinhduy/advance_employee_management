import 'package:advance_employee_management/service/auth_services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AddToDoPage extends StatefulWidget {
  const AddToDoPage({Key? key}) : super(key: key);

  @override
  _AddToDoPageState createState() => _AddToDoPageState();
}

class _AddToDoPageState extends State<AddToDoPage> {
  AuthClass auth = AuthClass();
  TextEditingController titleController = TextEditingController();
  TextEditingController desController = TextEditingController();
  String tasktype = "";
  String category = "";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        decoration: const BoxDecoration(
            gradient: LinearGradient(colors: [
          Color(0xff1d1e26),
          Color(0xff252041),
        ])),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 30,
              ),
              IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: const Icon(CupertinoIcons.arrow_left,
                      color: Colors.white, size: 28)),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 25, vertical: 5),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Create",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 33,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 4),
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    const Text(
                      "New to do",
                      style: TextStyle(
                        fontSize: 33,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 2,
                      ),
                    ),
                    const SizedBox(
                      height: 25,
                    ),
                    lable("Task title"),
                    const SizedBox(
                      height: 12,
                    ),
                    title(),
                    const SizedBox(
                      height: 30,
                    ),
                    lable("Task Type"),
                    const SizedBox(
                      height: 12,
                    ),
                    Row(
                      children: [
                        taskSelect("Important", 0xff2664fa),
                        const SizedBox(
                          width: 20,
                        ),
                        taskSelect("Planned", 0xff2bc8d9),
                      ],
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    lable("Description"),
                    const SizedBox(
                      height: 20,
                    ),
                    description(),
                    const SizedBox(height: 20),
                    lable("Catelogy"),
                    const SizedBox(
                      height: 20,
                    ),
                    Wrap(
                      children: [
                        cateselect("Food", 0xffff6d6e),
                        const SizedBox(
                          width: 10,
                        ),
                        cateselect("Work Out", 0xfff29732),
                        const SizedBox(
                          width: 10,
                        ),
                        cateselect("Work", 0xff6557ff),
                        const SizedBox(
                          width: 10,
                        ),
                        cateselect("Design", 0xff234ebd),
                        const SizedBox(
                          width: 10,
                        ),
                        cateselect("Run", 0xff2bc8d9),
                      ],
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    button(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget button() {
    return InkWell(
      onTap: () {
        String uid = auth.user();
        FirebaseFirestore.instance.collection("ToDo").add({
          "uid": uid,
          "title": titleController.text,
          "task": tasktype,
          "discription": desController.text,
          "Category": category,
        });
        Navigator.pop(context);
      },
      child: Container(
        height: 56,
        width: MediaQuery.of(context).size.width - 20,
        margin: const EdgeInsets.symmetric(horizontal: 20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: const LinearGradient(colors: [
            Color(0xff8a32f1),
            Color(0xffad32f9),
          ]),
        ),
        child: const Center(
          child: Text(
            "Add To Do",
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }

  Widget taskSelect(String lable, int color) {
    return InkWell(
      onTap: () {
        setState(() {
          tasktype = lable;
        });
      },
      child: Chip(
        backgroundColor: tasktype == lable ? Colors.red : Color(color),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        label: Text(
          lable,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 15,
            fontWeight: FontWeight.w600,
          ),
        ),
        labelPadding: const EdgeInsets.symmetric(horizontal: 17, vertical: 3.8),
      ),
    );
  }

  Widget cateselect(String lable, int color) {
    return InkWell(
      onTap: () {
        setState(() {
          category = lable;
        });
      },
      child: Chip(
        backgroundColor: category == lable ? Colors.red : Color(color),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        label: Text(
          lable,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 15,
            fontWeight: FontWeight.w600,
          ),
        ),
        labelPadding: const EdgeInsets.symmetric(horizontal: 17, vertical: 3.8),
      ),
    );
  }

  Widget title() {
    return Container(
      height: 55,
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        color: const Color(0xff2a2e3d),
        borderRadius: BorderRadius.circular(15),
      ),
      child: TextFormField(
        controller: titleController,
        style: const TextStyle(color: Colors.grey, fontSize: 17),
        decoration: const InputDecoration(
          border: InputBorder.none,
          hintText: "Task Title",
          hintStyle: TextStyle(
            color: Colors.grey,
            fontSize: 17,
          ),
          contentPadding: EdgeInsets.only(left: 20, right: 20),
        ),
      ),
    );
  }

  Widget description() {
    return Container(
      height: 150,
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        color: const Color(0xff2a2e3d),
        borderRadius: BorderRadius.circular(15),
      ),
      child: TextFormField(
        controller: desController,
        maxLines: null,
        style: const TextStyle(color: Colors.grey, fontSize: 17),
        decoration: const InputDecoration(
          border: InputBorder.none,
          hintText: "Discription",
          hintStyle: TextStyle(
            color: Colors.grey,
            fontSize: 17,
          ),
          contentPadding: EdgeInsets.only(left: 20, right: 20),
        ),
      ),
    );
  }

  Widget lable(String lable) {
    return Text(
      lable,
      style: const TextStyle(
        color: Colors.white,
        fontWeight: FontWeight.w600,
        letterSpacing: 2,
      ),
    );
  }
}
