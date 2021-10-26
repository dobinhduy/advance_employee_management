import 'package:flutter/material.dart';

class NavBarLogo extends StatelessWidget {
  const NavBarLogo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 0.8),
      child: SizedBox(
        height: 50,
        width: 100,
        child: Image.asset("images/dog.jpg"),
      ),
    );
  }
}
