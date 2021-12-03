import 'package:advance_employee_management/locator.dart';
import 'package:advance_employee_management/rounting/route.dart';
import 'package:advance_employee_management/rounting/route_names.dart';
import 'package:advance_employee_management/service/navigation_service.dart';
import 'package:advance_employee_management/widgets/slide_menu_admin/side_menu_admin.dart';
import 'package:flutter/material.dart';

class AdminLayoutRoute extends StatelessWidget {
  final GlobalKey<ScaffoldState> _key = GlobalKey<ScaffoldState>();

  AdminLayoutRoute({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _key,
      backgroundColor: Colors.white,
      body: Row(
        children: [
          const SideMenuAdmin(),
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
