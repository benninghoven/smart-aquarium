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
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      themeMode: ThemeMode.system, // Match the system theme by default
      darkTheme: ThemeData.dark(),
      home: const ContentView(),
    );
  }
}
