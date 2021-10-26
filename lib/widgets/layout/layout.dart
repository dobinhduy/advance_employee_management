import 'package:advance_employee_management/widgets/slide_menu/side_menu.dart';
import 'package:flutter/material.dart';

class LayoutRoute extends StatelessWidget {
  final GlobalKey<ScaffoldState> _key = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _key,
      backgroundColor: Colors.white,
      body: Row(
        children: [
          SideMenu(),
          Expanded(
            child: Column(),
          )
        ],
      ),
    );
  }
}
