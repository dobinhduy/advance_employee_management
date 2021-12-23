import 'package:flutter/material.dart';

class NavBarLogoAdmin extends StatefulWidget {
  const NavBarLogoAdmin({Key? key}) : super(key: key);

  @override
  State<NavBarLogoAdmin> createState() => _NavBarLogoAdminState();
}

class _NavBarLogoAdminState extends State<NavBarLogoAdmin> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: const [
          SizedBox(
            height: 100,
            width: 100,
            child: Icon(
              Icons.home,
              size: 100,
            ),
          ),
          SizedBox(
            height: 8,
          ),
        ],
      ),
    );
  }
}
