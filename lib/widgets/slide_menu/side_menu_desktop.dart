import 'package:advance_employee_management/provider/app_provider.dart';
import 'package:advance_employee_management/widgets/navbar/navbar_logo.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SildeMenuTabletDesktop extends StatelessWidget {
  const SildeMenuTabletDesktop({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final AppProvider appProvider = Provider.of<AppProvider>(context);
    return Container(
      decoration: BoxDecoration(
          color: Colors.indigo,
          gradient: LinearGradient(
            colors: [Colors.indigo, Colors.indigo.shade600],
          ),
          boxShadow: [
            BoxShadow(
                color: Colors.white, offset: const Offset(3, 5), blurRadius: 17)
          ]),
      width: 250,
      child: Container(
        child: Column(
          children: [
            NavBarLogo(),
          ],
        ),
      ),
    );
  }
}
