import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:provider/provider.dart';
import 'package:student_notes/Api/authhelper.dart';
import 'package:student_notes/Screens/Authscreens/loginUI.dart';
import 'package:student_notes/Screens/splashscreen.dart';
import 'package:student_notes/provider/enrolledcoursesprovider.dart';
import 'package:student_notes/provider/profileprovider.dart';
import 'package:student_notes/provider/theme_provider.dart';
import 'package:workmanager/workmanager.dart';

void callbackDispatcher() async {
  Workmanager().executeTask((task, inputData) async {
    await AuthHelper.updateAccessToken();

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
        child: MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ProfileProvider()),
        ChangeNotifierProvider(create: (_) => EnrolledCourseProvider()),
      ],
      child: ChangeNotifierProvider(
          create: (context) => ThemeModel(),
          child: Consumer<ThemeModel>(
              builder: (context, ThemeModel themeNotifier, child) {
            return GetMaterialApp(
              routes: {
                "/login": (context) => LoginScreen(),
              },
              theme: themeNotifier.isDark
                  ? MyThemes.lightTheme
                  : MyThemes.darkTheme,
              debugShowCheckedModeBanner: false,
              title: 'student notes app',
              home: SplashScreen(),
              builder: EasyLoading.init(),
            );
          })),
    ));
  }
}
