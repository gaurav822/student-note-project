import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:student_notes/Api/authhelper.dart';
import 'package:student_notes/Screens/loginUI.dart';
import 'package:student_notes/Screens/splashscreen.dart';
import 'package:student_notes/Utils/colors.dart';
import 'package:workmanager/workmanager.dart';

void callbackDispatcher() async {
  Workmanager().executeTask((task, inputData) async {
    String rescode = await AuthHelper.updateAccessToken();
    return Future.value(true);
  });
}

void main() async {
  SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(statusBarColor: Colors.grey));

  WidgetsFlutterBinding.ensureInitialized();

  await dotenv.load(fileName: ".env");

  if (Platform.isAndroid) {
    Workmanager().initialize(
      callbackDispatcher,
    );
    Workmanager().registerPeriodicTask(
        "checkaccesstoken", "Refresh access token",
        frequency: Duration(minutes: 20));
  }
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return OverlaySupport(
      child: GetMaterialApp(
        routes: {
          "/login": (context) => LoginScreen(),
        },
        debugShowCheckedModeBanner: false,
        title: 'student notes app',
        theme: ThemeData(
          dividerColor: Colors.black,
          primarySwatch: Colors.blue,
          primaryColor: primaryColor,
        ),
        home: SplashScreen(),
      ),
    );
  }
}
