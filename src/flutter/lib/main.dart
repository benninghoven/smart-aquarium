import 'package:flutter/material.dart';
import 'Login.dart'; // Importing the ContentView widget from ContentView.dart

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool useSystemTheme = true;
  bool isDarkTheme = false;

  void toggleTheme() {
    setState(() {
      if (useSystemTheme == isDarkTheme) {
        useSystemTheme = false;
        isDarkTheme = !isDarkTheme;
      } else if (useSystemTheme != isDarkTheme) {
        useSystemTheme = false;
        isDarkTheme = !isDarkTheme;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final Brightness platformBrightness = MediaQuery.of(context).platformBrightness;
    final bool systemIsDark = platformBrightness == Brightness.dark;
    final ThemeData themeData = useSystemTheme ? (systemIsDark ? ThemeData.dark() : ThemeData.light()) : (isDarkTheme ? ThemeData.dark() : ThemeData.light());

    return MaterialApp(
      theme: themeData,
      home: Login(toggleTheme: toggleTheme), // Providing toggleTheme parameter
    );
  }
}
