import 'package:flutter/material.dart';
import 'package:flutter_application_1/ContentView.dart';

void main() {
  runApp(const SmartAquariumApp());
}

class SmartAquariumApp extends StatefulWidget {
  const SmartAquariumApp({Key? key}) : super(key: key);

  @override
  _SmartAquariumAppState createState() => _SmartAquariumAppState();
}

class _SmartAquariumAppState extends State<SmartAquariumApp> {
  bool _isDarkMode = true;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: _isDarkMode ? ThemeData.dark() : ThemeData.light(),
      home: const ContentView(),
    );
  }
}
