import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ViewData extends StatefulWidget {
  const ViewData({Key? key, required this.document, required this.id})
      : super(key: key);
  final Map<String, dynamic> document;
  final String? id;

  @override
  _ViewDataState createState() => _ViewDataState();
}

class _ViewDataState extends State<ViewData> {
  late TextEditingController titleController;
  late TextEditingController desController;
  late String tasktype;
  late String category;
  bool edit = false;
  @override
  void initState() {
    super.initState();
    String title = widget.document["title"] ?? "No Title";
    String description = widget.document["discription"] ?? "No Description";
    titleController = TextEditingController(text: title);
    desController = TextEditingController(text: description);
    tasktype = widget.document["task"];
    category = widget.document["Category"];
  }

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
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: const Icon(CupertinoIcons.arrow_left,
                          color: Colors.white, size: 28)),
                  IconButton(
                      onPressed: () {
                        setState(() {
                          edit = !edit;
                        });
                      },
                      icon: Icon(Icons.edit,
                          color: edit ? Colors.red : Colors.white, size: 28)),
                ],
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 25, vertical: 5),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      edit ? "Edit" : "View",
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 33,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 4),
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    const Text(
                      "Your to do",
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
                    edit ? button() : Container(),
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
        FirebaseFirestore.instance.collection("ToDo").doc(widget.id).update({
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
        child: Center(
          child: Text(
            edit ? "UpDate Data" : "Add To Do",
            style: const TextStyle(
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
      onTap: edit
          ? () {
              setState(() {
                tasktype = lable;
              });
            }
          : null,
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
      onTap: edit
          ? () {
              setState(() {
                category = lable;
              });
            }
          : null,
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
        enabled: edit,
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
        enabled: edit,
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
