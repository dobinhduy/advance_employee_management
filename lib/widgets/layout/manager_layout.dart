import 'package:advance_employee_management/rounting/route.dart';
import 'package:advance_employee_management/rounting/route_names.dart';
import 'package:advance_employee_management/service/navigation_service.dart';
import 'package:advance_employee_management/widgets/Manager_slide_menu/slide_menu_manager.dart';
import 'package:advance_employee_management/widgets/slide_menu/side_menu_admin.dart';
import 'package:flutter/material.dart';

import '../../locator.dart';

class ManagerLayoutRoute extends StatelessWidget {
  final GlobalKey<ScaffoldState> _key = GlobalKey<ScaffoldState>();
  ManagerLayoutRoute({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _key,
      backgroundColor: Colors.white,
      body: Row(
        children: [
          const SideMenuManager(),
          Expanded(
            child: Column(
              children: [
                Expanded(
                    child: Navigator(
                  key: locator<NavigationService>().navigatorKey,
                  onGenerateRoute: generateRoute,
                  initialRoute: MainHomeP,
                ))
              ],
            ),
          )
        ],
      ),
    );
  }
}
