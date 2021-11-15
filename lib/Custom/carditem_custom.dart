import 'package:advance_employee_management/Custom/custom_text_project.dart';
import 'package:flutter/material.dart';
import 'package:responsive_builder/responsive_builder.dart';

class CardItem extends StatelessWidget {
  CardItem(
      {required this.title,
      required this.value,
      required this.color1,
      required this.color2,
      required this.icon,
      required this.subtitle});
  final String subtitle;
  final String title;
  final String value;
  final Color color1;
  final Color color2;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return ResponsiveBuilder(
      builder: (context, sizingInformation) {
        double titleSize = sizingInformation.screenSize.width <= 600 ? 12 : 16;
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            height: 80,
            width: MediaQuery.of(context).size.width / 4,
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                gradient: LinearGradient(
                    colors: [color1, color2],
                    begin: Alignment.bottomLeft,
                    end: Alignment.topRight),
                boxShadow: const [
                  BoxShadow(
                      color: Colors.grey, offset: Offset(0, 3), blurRadius: 16)
                ]),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: ListTile(
                    title: CustomTextProject(
                      text: title,
                      size: titleSize,
                      weight: FontWeight.bold,
                      color: Colors.white,
                    ),
                    subtitle: CustomTextProject(
                      text: subtitle,
                      size: titleSize,
                      weight: FontWeight.w400,
                      color: Colors.white,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 14),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CustomTextProject(
                        text: value,
                        size: titleSize + 18,
                        weight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
