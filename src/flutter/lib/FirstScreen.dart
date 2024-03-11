import 'package:flutter/material.dart';

class FirstScreen extends StatelessWidget {
  const FirstScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          const Positioned.fill(
            child: Center(
              child: Text(
                'First Screen',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 32,
                ),
              ),
            ),
          ),
          Positioned.fill(
            child: Image.asset(
              'assets/ocean.jpg', // Replace 'ocean.jpg' with your actual image asset path
              fit: BoxFit.cover,
            ),
          ),
        ],
      ),
    );
  }
}

class FirstScreen_Previews extends StatelessWidget {
  const FirstScreen_Previews({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: Scaffold(
        body: FirstScreen(),
      ),
    );
  }
}
