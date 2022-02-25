import 'package:flutter/material.dart';
import 'package:student_notes/provider/theme_preferences.dart';

class ThemeModel extends ChangeNotifier {
  bool _isDark = true;
  ThemePreferences _preferences;
  bool get isDark => _isDark;

  ThemeModel() {
    _isDark = false;
    _preferences = ThemePreferences();
    getPreferences();
  }

  set isDark(bool value) {
    _isDark = value;
    _preferences.setTheme(value);
    notifyListeners();
  }

  getPreferences() async {
    _isDark = await _preferences.getTheme();
    notifyListeners();
  }
}

class MyThemes {
  static final backColor = const Color(0xfff191720);
  static final primary = Color.fromARGB(255, 41, 41, 41);

  static final darkTheme = ThemeData(
    primaryColor: Colors.white,
    colorScheme: ColorScheme.dark(primary: Colors.white), // for focus icons
    scaffoldBackgroundColor: backColor,
    textSelectionTheme: TextSelectionThemeData(
      cursorColor: Colors.white,
    ),
    progressIndicatorTheme: ProgressIndicatorThemeData(color: Colors.white),
    iconTheme: IconThemeData(
      color: Colors.white,
    ),
    focusColor: Colors.white,
    dividerColor: Colors.white,
  );

  static final lightTheme = ThemeData(
      scaffoldBackgroundColor: Colors.white,
      primaryColorDark: Colors.black,
      primaryColor: Colors.grey.shade400,
      dividerColor: Colors.black,
      textSelectionTheme: TextSelectionThemeData(
        cursorColor: Colors.black,
      ),
      colorScheme: ColorScheme.light(primary: primary),
      textTheme: TextTheme());
}
