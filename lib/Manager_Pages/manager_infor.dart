import 'package:advance_employee_management/models/manager.dart';
import 'package:advance_employee_management/service/auth_services.dart';
import 'package:advance_employee_management/service/manager_service.dart';
import 'package:flutter/material.dart';

class ManagerInformation extends StatefulWidget {
  const ManagerInformation({Key? key}) : super(key: key);

  @override
  _ManagerInformationState createState() => _ManagerInformationState();
}

class _ManagerInformationState extends State<ManagerInformation> {
  ManagerServices managerServices = ManagerServices();
  ManagerModel? managerInfor;
  String email = AuthClass().user()!;
  bool loading = true;

  getManagerInf() async {
    managerInfor = await managerServices.getManagerByEmail(email);

    if (!mounted) {
      setState(() {});
    }
  }

  isLoading() {
    Future.delayed(const Duration(seconds: 2), () {
      setState(() {
        loading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    getManagerInf();
    isLoading();
    return loading == true
        ? Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: const <Widget>[
                SizedBox(
                  child: CircularProgressIndicator(),
                  height: 50.0,
                  width: 50.0,
                ),
              ],
            ),
          )
        : Scaffold(
            backgroundColor: Colors.deepPurple[200],
            appBar: AppBar(
              backgroundColor: Colors.blueAccent,
              title: const Text("Manager Information"),
            ),
            body: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  const SizedBox(
                    width: 20,
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height,
                    width: MediaQuery.of(context).size.width / 4.4,
                    child: Column(
                      children: [
                        const SizedBox(
                          height: 140,
                        ),
                        Image.network(managerInfor!.photourl,
                            width: 300, height: 300, fit: BoxFit.fill)
                      ],
                    ),
                  ),
                  const SizedBox(
                    width: 100,
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height,
                    width: 100,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(
                          height: 100,
                        ),
                        titlebox("Name"),
                        titlebox("ID"),
                        titlebox("Gender"),
                        titlebox("Birthday"),
                        titlebox("Address"),
                        titlebox("Phone"),
                        titlebox("Email"),
                        titlebox("Position"),
                      ],
                    ),
                  ),
                  const SizedBox(
                    width: 90,
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height,
                    width: MediaQuery.of(context).size.width / 5,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(
                          height: 100,
                        ),
                        titlebox(managerInfor!.name),
                        titlebox(managerInfor!.id),
                        titlebox(managerInfor!.gender),
                        titlebox(managerInfor!.birthday),
                        titlebox(managerInfor!.address),
                        titlebox(managerInfor!.phone),
                        titlebox(managerInfor!.email),
                        titlebox(managerInfor!.position),
                      ],
                    ),
                  ),
                  Column(
                    children: [
                      const SizedBox(
                        height: 50,
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height / 5,
                        width: MediaQuery.of(context).size.width / 5,
                        child: Column(
                          children: [
                            IconButton(
                                onPressed: () {},
                                icon: const Icon(Icons.backspace,
                                    color: Colors.blue, size: 28)),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 350,
                      ),
                    ],
                  )
                ]),
          );
  }

  Widget titlebox(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 22),
      child: Text(
        title,
        style: const TextStyle(
          color: Colors.black,
          fontSize: 17,
          letterSpacing: 2,
        ),
      ),
    );
  }
}
