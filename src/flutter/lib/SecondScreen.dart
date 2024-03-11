import 'package:flutter/material.dart';

class SecondScreen extends StatelessWidget {
  const SecondScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.green[100], // Change the color to mint or any desired color
        child: const Center(
          child: Text(
            'Second Screen',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 32,
            ),
          ),
        ),
      ),
    );
  }
}

class SecondScreen_Previews extends StatelessWidget {
  const SecondScreen_Previews({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: Scaffold(
        body: SecondScreen(),
      ),
    );
  }
}
