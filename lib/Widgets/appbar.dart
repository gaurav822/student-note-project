import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:student_notes/Screens/provider/theme_provider.dart';
import 'package:student_notes/SecuredStorage/securedstorage.dart';

import 'package:student_notes/Utils/colors.dart';
import 'package:student_notes/Utils/internetutils.dart';

Widget customAppBar(BuildContext context, String username, int _currentIndex,
    ThemeModel themeNotifier) {
  return AppBar(
    backgroundColor: primaryColor,
    actions: [
      IconButton(
          onPressed: () async {
            final result = await Connectivity().checkConnectivity();

            showConnectivitySnackBar(context, result);
            final access = await SecuredStorage.getAccess();
            print("The access token is" + access);
          },
          icon: Icon(Icons.refresh)),
      IconButton(
          icon: Icon(
              themeNotifier.isDark ? Icons.wb_sunny : Icons.nightlight_round),
          onPressed: () {
            themeNotifier.isDark
                ? themeNotifier.isDark = false
                : themeNotifier.isDark = true;
          })
    ],
    title: Row(children: [
      Text(
        "Welcome",
        style: GoogleFonts.lato(
          textStyle: TextStyle(
              color: Colors.white,
              letterSpacing: .5,
              fontWeight: FontWeight.bold),
        ),
      ),
      username != null
          ? Text(
              ", " + username,
              style: GoogleFonts.lato(
                textStyle: TextStyle(color: Colors.white, letterSpacing: .5),
              ),
            )
          : CircularProgressIndicator()
    ]),
  );
}

void showConnectivitySnackBar(BuildContext context, ConnectivityResult result) {
  final hasInternet = result != ConnectivityResult.none;

  final message = hasInternet
      ? 'Internet Connection Restored'
      : 'Please check your internet connection';
  final color = hasInternet ? Colors.green : Colors.red;

  Utils.showTopSnackBar(context, message, color);
}
