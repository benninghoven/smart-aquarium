import 'package:flutter/material.dart';
import 'package:flutter_application_1/ContentView.dart';

void main() {
  runApp(const SmartAquariumApp());
}

class SmartAquariumApp extends StatelessWidget {
  const SmartAquariumApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: ContentView(),
    );
  }
}
