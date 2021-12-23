import 'package:flutter/material.dart';

class CustomTextProject extends StatelessWidget {
  final String text;
  final double size;
  // final Color color;
  final FontWeight weight;

  const CustomTextProject(
      {Key? key,
      required this.text,
      required this.size,
      // required this.color,
      required this.weight})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(fontSize: size, fontWeight: weight),
    );
  }
}
