import 'package:advance_employee_management/pages/home_page.dart';
import 'package:advance_employee_management/pages/phone_auth.dart';
import 'package:advance_employee_management/pages/sign_in_page.dart';
import 'package:advance_employee_management/pages/sign_up_page.dart';
import 'package:advance_employee_management/rounting/route_names.dart';
import 'package:advance_employee_management/widgets/layout/layout.dart';
import 'package:flutter/material.dart';

PageRoute generateRoute(RouteSettings settings) {
  print("generateRoute: ${settings.name}");
  switch (settings.name) {
    case LonginRoute:
      return _getPageRoute(const SignInPage());
    case SignupRoute:
      return _getPageRoute(const SignUpPage());
    case PhoneAuthLog:
      return _getPageRoute(const PhoneAuth());
    case MainHomeP:
      return _getPageRoute(const HomePage());
    case LayOutRoute:
      return _getPageRoute(LayoutRoute());

    default:
      return _getPageRoute(const SignInPage());
  }
  ;
}

PageRoute _getPageRoute(Widget child) {
  return MaterialPageRoute(builder: (context) => child);
}
