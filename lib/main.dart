import 'dart:io';

import 'package:advance_employee_management/locator.dart';
import 'package:advance_employee_management/pages/sign_up_page.dart';
import 'package:advance_employee_management/provider/app_provider.dart';
import 'package:advance_employee_management/rounting/route.dart';
import 'package:advance_employee_management/rounting/route_names.dart';
import 'package:advance_employee_management/service/auth_services.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:provider/provider.dart';

//  flutter run -d chrome --web-hostname localhost --web-port 5000

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  setupLocator();
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider.value(value: AppProvider.init()),
    ],
    child: MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  Widget currentPage = const SignUpPage();
  AuthClass authClass = AuthClass();

  void checkLogin() async {
    String token = await authClass.getToken() as String;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Advance Employee Management',
      theme: ThemeData(primarySwatch: Colors.green),
      onGenerateRoute: generateRoute,
      initialRoute: LonginRoute,
    );
  }
}
