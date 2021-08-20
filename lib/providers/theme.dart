import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

class ThemeProvider extends ChangeNotifier {
  ThemeMode themeMode = ThemeMode.system;

  bool get isDarkMode {
    if (themeMode == ThemeMode.system) {
      final brightness = SchedulerBinding.instance!.window.platformBrightness;
      return brightness == Brightness.dark;
    } else {
      return themeMode == ThemeMode.dark;
    }
  }

  void toggleTheme(bool isOn) {
    themeMode = isOn ? ThemeMode.dark : ThemeMode.light;
    notifyListeners();
  }
}

class MyThemes {
  static final lightTheme = ThemeData(
    scaffoldBackgroundColor: Colors.white,
    primaryColor: Colors.white,
    appBarTheme: AppBarTheme(backgroundColor: Colors.white),
    colorScheme: ColorScheme.light(),
    iconTheme: IconThemeData(color: Colors.grey[850]),
    textTheme: TextTheme(
      headline6: TextStyle(color: Colors.black),
      headline1: TextStyle(color: Colors.grey[850]),
      headline2: TextStyle(
        color: Colors.grey[200],
      ),
    ),
    cardColor: Colors.white,
    buttonColor: Color(0xff040316),
    backgroundColor: Colors.black,
    accentColor: Colors.grey[200],
    primaryIconTheme: IconThemeData(color: Colors.blue),
  );

  static final darkTheme = ThemeData(
    scaffoldBackgroundColor: Colors.grey.shade900,
    primaryColor: Colors.black,
    accentColor: Colors.white24,
    cardColor: Colors.grey,
    backgroundColor: Colors.white,
    appBarTheme: AppBarTheme(
      backgroundColor: Colors.black,
      textTheme: TextTheme(
        headline6: TextStyle(color: Colors.white),
        headline1: TextStyle(color: Colors.grey[50]),
      ),
    ),
    buttonColor: Colors.white,
    colorScheme: ColorScheme.dark(),
    iconTheme: IconThemeData(color: Colors.white),
    primaryIconTheme: IconThemeData(color: Colors.green),
  );
}
