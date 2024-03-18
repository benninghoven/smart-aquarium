import 'package:flutter/material.dart';
import 'SecondScreen.dart';

class FirstScreen extends StatelessWidget {
  const FirstScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true, 
        title: const Text('First Screeen'),
      ),
      body: Stack(
        children: [
          Positioned.fill(
            child: Center(
            ),
          ),
          Positioned.fill(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      CircleButton(
                        label: 'Water Hardness',
                        number: '1',
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => SecondScreen()),
                          );
                        },
                      ),
                      CircleButton(
                        label: 'PH',
                        number: '2',
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => SecondScreen()),
                          );
                        },
                      ),
                      CircleButton(
                        label: 'Temperature',
                        number: '3',
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => SecondScreen()),
                          );
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class CircleButton extends StatelessWidget {
  final String label;
  final String number;
  final VoidCallback onTap;

  const CircleButton({
    required this.label,
    required this.number,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final circleSize = screenWidth * 0.25; // Adjust size as needed

    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            width: circleSize,
            height: circleSize,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.blue.withOpacity(0.5),
            ),
            child: Center(
              child: Text(
                number,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
            ),
          ),
          SizedBox(height: 8), // Adjust spacing as needed
          Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }
}
