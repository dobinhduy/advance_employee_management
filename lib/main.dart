import 'package:advance_employee_management/locator.dart';

import 'package:advance_employee_management/provider/app_provider.dart';
import 'package:advance_employee_management/provider/table_provider.dart';
import 'package:advance_employee_management/provider/theme_provider.dart';
import 'package:advance_employee_management/rounting/route.dart';
import 'package:advance_employee_management/rounting/route_names.dart';
import 'package:advance_employee_management/service/auth_services.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:provider/provider.dart';

// flutter run -d edge --web-hostname localhost --web-port 5000 --no-sound-null-safety --web-renderer canvaskit

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  setupLocator();
  configLoading();
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider.value(value: AppProvider.init()),
      ChangeNotifierProvider.value(value: TableProvider.init()),
    ],
    child: MyApp(),
  ));
}

void configLoading() {
  EasyLoading.instance
    ..displayDuration = const Duration(milliseconds: 2000)
    ..indicatorType = EasyLoadingIndicatorType.fadingCircle
    ..loadingStyle = EasyLoadingStyle.dark
    ..indicatorSize = 45.0
    ..radius = 10.0
    ..progressColor = Colors.yellow
    ..backgroundColor = Colors.green
    ..indicatorColor = Colors.yellow
    ..textColor = Colors.yellow
    ..maskColor = Colors.blue.withOpacity(0.5)
    ..userInteractions = true
    ..dismissOnTap = false;
}

// ignore: must_be_immutable
class MyApp extends StatelessWidget {
  AuthClass authClass = AuthClass();

  MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => ChangeNotifierProvider(
      create: (context) => ThemeProvider(),
      builder: (context, _) {
        final themeProvider = Provider.of<ThemeProvider>(context);
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Advance Employee Management',
          // theme: ThemeData(primarySwatch: Colors.green),
          // theme: FlexColorScheme.light(scheme: FlexScheme.gold).toTheme,
          theme: MyThemes.lightTheme,
          themeMode: themeProvider.themeMode,
          darkTheme: MyThemes.darkTheme,
          // FlexColorScheme.dark(scheme: FlexScheme.deepPurple).toTheme,
          onGenerateRoute: generateRoute,
          initialRoute: LonginRoute,
          builder: EasyLoading.init(),
        );
      });
}
