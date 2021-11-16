import 'package:advance_employee_management/Custom/custom_text_project.dart';
import 'package:flutter/material.dart';
import 'package:responsive_builder/responsive_builder.dart';

class CardItem extends StatelessWidget {
  CardItem(
      {required this.projectname,
      required this.projectid,
      required this.color1,
      required this.color2,
      required this.icon,
      required this.startday,
      required this.manager,
      required this.endday});
  final String projectname;
  final String projectid;
  final String manager;
  final String startday;
  final String endday;
  final Color color1;
  final Color color2;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {},
      child: ResponsiveBuilder(
        builder: (context, sizingInformation) {
          // double titleSize =
          //     sizingInformation.screenSize.width <= 600 ? 12 : 16;
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              height: 140,
              width: 300,
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  gradient: LinearGradient(
                      colors: [color1, color2],
                      begin: Alignment.bottomLeft,
                      end: Alignment.topRight),
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
                        const Text("Project Name"),
                        SizedBox(
                          width: 30,
                        ),
                        CustomTextProject(
                            text: projectname,
                            size: 16,
                            color: Colors.black,
                            weight: FontWeight.bold)
                      ],
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Row(
                      children: [
                        const Text("Project ID"),
                        SizedBox(
                          width: 30,
                        ),
                        CustomTextProject(
                            text: projectid,
                            size: 16,
                            color: Colors.black,
                            weight: FontWeight.bold)
                      ],
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Row(
                      children: [
                        const Text("Manager"),
                        SizedBox(
                          width: 30,
                        ),
                        CustomTextProject(
                            text: manager,
                            size: 16,
                            color: Colors.black,
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
    );
  }
}
