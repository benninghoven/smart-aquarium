import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'PPM_Graphs.dart';
import 'PH.dart';
import 'Temperature.dart';


class Reading {
  final String timestp;
  final double water_temp;
  final int PPM;
  final double pH;

  const Reading({
    required this.timestp,
    required this.water_temp,
    required this.PPM,
    required this.pH,
  });

  factory Reading.fromJson(Map<String, dynamic> json) {
    return Reading(
      timestp: json['timestp'],
      water_temp: json['water_temp'].toDouble(),
      PPM: json['PPM'],
      pH: json['pH'].toDouble(),
    );
  }
}

Future<Reading> fetchReading() async {
  final response = await http.get(Uri.parse('http://localhost:5000/get_latest_reading'));
  if (response.statusCode == 200) {
    return Reading.fromJson(jsonDecode(response.body));
  } else {
    throw Exception('Failed to load reading');
  }
}

class FirstScreen extends StatefulWidget {
  const FirstScreen({Key? key}) : super(key: key);

  @override
  _FirstScreenState createState() => _FirstScreenState();
}

class _FirstScreenState extends State<FirstScreen> {
  late Future<Reading> futureReading;

  @override
  void initState() {
    super.initState();
    futureReading = fetchReading();
  }

  @override
  Widget build(BuildContext context) {
    final bool isDarkTheme = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        title: null,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: isDarkTheme
                ? [Colors.blueGrey.shade900, Colors.blueGrey.shade700]
                : [Colors.blue.shade200, Colors.blue.shade400],
          ),
        ),
        child: Stack(
          children: [
            Positioned(
              top: 20.0,
              left: 0,
              right: 0,
              child: Center(
                child: Text(
                  'Welcome To Your Smart Aquarium!',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: isDarkTheme ? Colors.white : Colors.black,
                  ),
                ),
              ),
            ),
            Positioned.fill(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    FutureBuilder<Reading>(
                      future: futureReading,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return CircularProgressIndicator();
                        } else if (snapshot.hasError) {
                          return Text('Error: ${snapshot.error}');
                        } else {
                          final reading = snapshot.data!;
                          return Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              CircleButton(
                                label: 'Water Hardness',
                                number: reading.PPM.toString(),
                                icon: Icons.opacity,
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (context) => SecondScreen()),
                                  );
                                },
                              ),
                              CircleButton(
                                label: 'PH',
                                number: reading.pH.toString(),
                                icon: Icons.category,
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (context) => ThirdScreen()),
                                  );
                                },
                              ),
                              CircleButton(
                                label: 'Temperature',
                                number: reading.water_temp.toString(),
                                icon: Icons.thermostat,
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (context) => FourthScreen()),
                                  );
                                },
                              ),
                            ],
                          );
                        }
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CircleButton extends StatefulWidget {
  final String label;
  final String number;
  final IconData icon;
  final VoidCallback onTap;

  const CircleButton({
    required this.label,
    required this.number,
    required this.icon,
    required this.onTap,
  });

  @override
  _CircleButtonState createState() => _CircleButtonState();
}

class _CircleButtonState extends State<CircleButton> {
  bool isPressed = false;
  bool isHovered = false;

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final circleSize = screenWidth * 0.25;

    return MouseRegion(
      onEnter: (_) {
        setState(() {
          isHovered = true;
        });
      },
      onExit: (_) {
        setState(() {
          isHovered = false;
        });
      },
      child: GestureDetector(
        onTapDown: (_) {
          setState(() {
            isPressed = true;
          });
        },
        onTapUp: (_) {
          setState(() {
            isPressed = false;
          });
          widget.onTap();
        },
        onTapCancel: () {
          setState(() {
            isPressed = false;
          });
        },
        child: Column(
          children: [
            AnimatedContainer(
              duration: Duration(milliseconds: 140),
              width: circleSize,
              height: circleSize,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isPressed ? Colors.blue.withOpacity(0.7) : Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: isHovered
                        ? (Theme.of(context).brightness == Brightness.dark
                            ? Colors.white.withOpacity(0.5)
                            : Colors.black.withOpacity(0.5))
                        : Colors.transparent,
                    spreadRadius: isHovered ? 4 : 0,
                    blurRadius: isHovered ? 10 : 0,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              child: Center(
                child: Icon(
                  widget.icon,
                  size: 40,
                  color: isPressed ? Colors.white : Colors.blue,
                ),
              ),
            ),
            SizedBox(height: 8), // Adjust spacing as needed
            Text(
              widget.label,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: Colors.white,
              ),
            ),
            Text(
              widget.number,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
