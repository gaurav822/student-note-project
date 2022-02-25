import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import 'package:student_notes/Utils/colors.dart';
import 'package:student_notes/Utils/internetutils.dart';
import 'package:student_notes/provider/profileprovider.dart';
import 'package:student_notes/provider/theme_provider.dart';

Widget customAppBar(
    BuildContext context, int _currentIndex, ThemeModel themeNotifier) {
  return AppBar(
    backgroundColor: primaryColor,
    actions: [
      // IconButton(
      //     onPressed: () async {
      //       final result = await Connectivity().checkConnectivity();
      //       showConnectivitySnackBar(context, result);
      //       print("The access token is " +
      //           Provider.of<ProfileProvider>(context, listen: false)
      //               .getAccessToken());
      //     },
      //     icon: Icon(Icons.refresh)),
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
      Text(
        ", " + Provider.of<ProfileProvider>(context, listen: false).getUname(),
        style: GoogleFonts.lato(
          textStyle: TextStyle(color: Colors.white, letterSpacing: .5),
        ),
      )
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
