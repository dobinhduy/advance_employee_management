import 'package:flutter/material.dart';

class TodoCard extends StatelessWidget {
  const TodoCard(
      {Key? key,
      required this.title,
      required this.iconColor,
      required this.iconData,
      required this.time,
      required this.check,
      required this.iconBgColor})
      : super(key: key);

  final String title;
  final IconData iconData;
  final Color iconColor;
  final String time;
  final bool check;
  final Color iconBgColor;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      child: Row(
        children: [
          Theme(
            data: ThemeData(
              primarySwatch: Colors.blue,
              unselectedWidgetColor: const Color(0xff5e616a),
            ),
            child: Transform.scale(
              scale: 1.5,
              child: Checkbox(
                value: check,
                onChanged: (bool? value) {},
              ),
            ),
          ),
          Expanded(
            child: SizedBox(
              height: 75,
              child: Card(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
                color: const Color(0xff2a2e3d),
                child: Row(
                  children: [
                    const SizedBox(
                      width: 15,
                    ),
                    Container(
                      height: 33,
                      width: 36,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: iconBgColor,
                      ),
                      child: Icon(
                        iconData,
                        color: iconColor,
                      ),
                    ),
                    const SizedBox(
                      width: 20,
                    ),
                    Expanded(
                      child: Text(
                        title,
                        style: const TextStyle(
                          fontSize: 17,
                          letterSpacing: 1,
                          fontWeight: FontWeight.w500,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    Text(
                      time,
                      style: const TextStyle(
                        fontSize: 17,
                        letterSpacing: 1,
                        fontWeight: FontWeight.w500,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(
                      width: 15,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
