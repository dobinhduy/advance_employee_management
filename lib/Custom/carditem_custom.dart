import 'package:advance_employee_management/Custom/custom_text_project.dart';
import 'package:advance_employee_management/Employee__Pages/view_project.dart';
import 'package:advance_employee_management/models/project.dart';
import 'package:flutter/material.dart';
import 'package:responsive_builder/responsive_builder.dart';

class CardItem extends StatelessWidget {
  const CardItem(
      {Key? key,
      required this.projectname,
      required this.projectid,
      required this.color1,
      required this.color2,
      required this.icon,
      required this.startday,
      required this.manager,
      required this.endday,
      required this.project})
      : super(key: key);
  final String projectname;
  final String projectid;
  final String manager;
  final String startday;
  final String endday;
  final Color color1;
  final Color color2;
  final IconData icon;
  final ProjectModel project;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        splashColor: Theme.of(context).primaryColorLight,
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (builder) => ViewProject(
                      projectName: project.name,
                      projectid: project.id,
                      startDay: project.start,
                      endDay: project.end,
                      status: project.status,
                      complete: project.complete.toString(),
                      description: project.desciption,
                      managerid: project.manager,
                      member: project.members,
                      department: project.department)));
        },
        child: ResponsiveBuilder(
          builder: (context, sizingInformation) {
            // double titleSize =
            //     sizingInformation.screenSize.width <= 600 ? 12 : 16;
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                height: 120,
                width: 360,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    gradient: LinearGradient(
                        colors: [color1, color2],
                        begin: Alignment.bottomRight,
                        end: Alignment.topLeft),
                    boxShadow: const [
                      BoxShadow(
                          color: Colors.grey,
                          offset: Offset(0, 3),
                          blurRadius: 16)
                    ]),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          const Text("Project Name:"),
                          const SizedBox(
                            width: 15,
                          ),
                          CustomTextProject(
                              text: projectname,
                              size: 16,
                              // color: Colors.black,
                              weight: FontWeight.bold)
                        ],
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Row(
                        children: [
                          const Text("Project ID: "),
                          const SizedBox(
                            width: 35,
                          ),
                          CustomTextProject(
                              text: projectid,
                              size: 16,
                              // color: Colors.black,
                              weight: FontWeight.bold)
                        ],
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Row(
                        children: [
                          const Text("Manager ID:"),
                          const SizedBox(
                            width: 35,
                          ),
                          CustomTextProject(
                              text: manager,
                              size: 16,
                              // color: Colors.black,
                              weight: FontWeight.bold)
                        ],
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Row(
                        children: [
                          const Text("DeadLine:"),
                          const SizedBox(
                            width: 35,
                          ),
                          CustomTextProject(
                              text: endday.replaceAll("-", "/"),
                              size: 16,
                              // color: Colors.black,
                              weight: FontWeight.bold)
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
