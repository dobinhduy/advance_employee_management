import 'package:advance_employee_management/provider/app_provider.dart';
import 'package:advance_employee_management/rounting/route.dart';
import 'package:advance_employee_management/rounting/route_names.dart';
import 'package:advance_employee_management/service/navigation_service.dart';
import 'package:advance_employee_management/widgets/Side_menu_employee/side_menu_employee.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../locator.dart';

class EmployeeLayoutRoute extends StatelessWidget {
  final GlobalKey<ScaffoldState> _key = GlobalKey<ScaffoldState>();
  EmployeeLayoutRoute({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _key,
      backgroundColor: Colors.white,
      body: Row(
        children: [
          const SideMenuEmployee(),
          Expanded(
            child: Column(
              children: [
                Expanded(
                    child: Navigator(
                  key: locator<NavigationService>().navigatorKey,
                  onGenerateRoute: generateRoute,
                  initialRoute: EmployeeInformationRoute,
                ))
              ],
            ),
          )
        ],
      ),
    );
  }
}
