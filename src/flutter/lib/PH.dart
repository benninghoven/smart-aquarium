import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'package:flutter/foundation.dart';
import 'dart:io' show Platform;

import 'package:intl/intl.dart';

class WaterData {
  final int timestamp;

  final double perHydro;
  final double pH;

  WaterData(this.timestamp, this.perHydro, this.pH);
}

class ThirdScreen extends StatefulWidget {
  @override
  _ThirdScreenState createState() => _ThirdScreenState();
}

class _ThirdScreenState extends State<ThirdScreen> {
  final List<Color> gradientColors = [Colors.blue, Colors.green];
  List<WaterData> dataPoints = [];
  Timer? _timer;
  double latestpH = 0; // Default latest ph
  bool isDaily = false;


  @override
  void initState() {
    super.initState();
    fetchData(); // Initial data fetch
    // Start auto-update timer
    _timer = Timer.periodic(Duration(seconds: 30), (Timer timer) {
      fetchData(); // Fetch data every 30 seconds
    });
  }

  @override
  void dispose() {
    _timer?.cancel(); // Cancel the timer to avoid memory leaks
    super.dispose();
  }

  Future<void> fetchData() async {
  if (isDaily == true){
    try {
    String apiUrl = kIsWeb
        ? 'http://localhost:5000/get_daily_readings'
        : Platform.isAndroid
            ? 'http://10.0.2.2:5000/get_daily_readings'
            : 'http://localhost:5000/get_daily_readings';

    final response = await http.get(Uri.parse(apiUrl));

    String latestApiUrl = kIsWeb
        ? 'http://localhost:5000/get_latest_reading'
        : Platform.isAndroid
            ? 'http://10.0.2.2:5000/get_latest_reading'
            : 'http://localhost:5000/get_latest_reading';

    final latestResponse = await http.get(Uri.parse(latestApiUrl));

    if (latestResponse.statusCode == 200) {
      Map<String, dynamic> latestJsonResponse = jsonDecode(latestResponse.body);
      double latestpHValue = latestJsonResponse['pH'].toDouble();
      print('Latest pH Response: $latestJsonResponse'); // Debug statement
      setState(() {
        latestpH = latestpHValue;
      });
    } else {
      throw Exception('Failed to load latest pH data: ${latestResponse.statusCode}');
    }
    if (response.statusCode == 200) {
      List<dynamic> jsonResponse = jsonDecode(response.body);
      List<WaterData> fetchedData = jsonResponse.map((data) {
        // Parse the date string manually
        DateTime dateTime = _parseDateString(data['timestp']);
        return WaterData(
          dateTime.millisecondsSinceEpoch,
          data['pH'].toDouble(),
          data['pH'].toDouble(), // Assuming pH is initially the latest value
        );
      }).toList();
      setState(() {
        dataPoints = fetchedData;
      });
    } else {
      throw Exception('Failed to load data: ${response.statusCode}');
    }
  } catch (e) {
    print('Error fetching data: $e');
  }
  }
  else{
    try {
    String apiUrl = kIsWeb
        ? 'http://localhost:5000/get_all_readings'
        : Platform.isAndroid
            ? 'http://10.0.2.2:5000/get_all_readings'
            : 'http://localhost:5000/get_all_readings';

    final response = await http.get(Uri.parse(apiUrl));

    String latestApiUrl = kIsWeb
        ? 'http://localhost:5000/get_latest_reading'
        : Platform.isAndroid
            ? 'http://10.0.2.2:5000/get_latest_reading'
            : 'http://localhost:5000/get_latest_reading';

    final latestResponse = await http.get(Uri.parse(latestApiUrl));

    if (latestResponse.statusCode == 200) {
      Map<String, dynamic> latestJsonResponse = jsonDecode(latestResponse.body);
      double latestpHValue = latestJsonResponse['pH'].toDouble();
      print('Latest pH Response: $latestJsonResponse'); // Debug statement
      setState(() {
        latestpH = latestpHValue;
      });
    } else {
      throw Exception('Failed to load latest pH data: ${latestResponse.statusCode}');
    }
    if (response.statusCode == 200) {
      List<dynamic> jsonResponse = jsonDecode(response.body);
      List<WaterData> fetchedData = jsonResponse.map((data) {
        // Parse the date string manually
        DateTime dateTime = _parseDateString(data['timestp']);
        return WaterData(
          dateTime.millisecondsSinceEpoch,
          data['pH'].toDouble(),
          data['pH'].toDouble(), // Assuming pH is initially the latest value
        );
      }).toList();
      setState(() {
        dataPoints = fetchedData;
      });
    } else {
      throw Exception('Failed to load data: ${response.statusCode}');
    }
  } catch (e) {
    print('Error fetching data: $e');
  }
  }
}


  DateTime _parseDateString(String dateString) {
  // Sample date format: "Tue, 26 Mar 2024 20:33:03 GMT"
  List<String> parts = dateString.split(' ');
  int day = int.parse(parts[1]);
  int month = _getMonthNumber(parts[2]);
  int year = int.parse(parts[3]);
  List<String> timeParts = parts[4].split(':');
  int hour = int.parse(timeParts[0]);
  int minute = int.parse(timeParts[1]);
  int second = int.parse(timeParts[2]);

  // Create a DateTime object in GMT time zone
  DateTime dateTimeGMT = DateTime.utc(year, month, day, hour, minute, second);

  // Convert the DateTime from GMT to PST
  String pstTimeZone = 'America/Los_Angeles'; // PST time zone
  String formattedDateTimePST =
      DateFormat.yMd().add_jms().format(dateTimeGMT.toLocal());

  // Parse the formatted DateTime string back to DateTime object in PST
  return DateFormat.yMd().add_jms().parse(formattedDateTimePST);
}

  int _getMonthNumber(String month) {
    switch (month) {
      case 'Jan':
        return DateTime.january;
      case 'Feb':
        return DateTime.february;
      case 'Mar':
        return DateTime.march;
      case 'Apr':
        return DateTime.april;
      case 'May':
        return DateTime.may;
      case 'Jun':
        return DateTime.june;
      case 'Jul':
        return DateTime.july;
      case 'Aug':
        return DateTime.august;
      case 'Sep':
        return DateTime.september;
      case 'Oct':
        return DateTime.october;
      case 'Nov':
        return DateTime.november;
      case 'Dec':
        return DateTime.december;
      default:
        throw FormatException('Invalid month: $month');
    }
  }

  String _formatTime(DateTime dateTime) {
    String month = _getMonthName(dateTime.month);
    String day = dateTime.day.toString();
    String hour = (dateTime.hour % 12).toString();
    if (hour == '0') {
      hour = '12';
    }
    String minute = dateTime.minute.toString().padLeft(2, '0');
    String amPm = dateTime.hour < 12 ? 'AM' : 'PM';
    return '$month $day, $hour:$minute $amPm';
  }

  String _getMonthName(int month) {
    switch (month) {
      case DateTime.january:
        return 'Jan';
      case DateTime.february:
        return 'Feb';
      case DateTime.march:
        return 'Mar';
      case DateTime.april:
        return 'Apr';
      case DateTime.may:
        return 'May';
      case DateTime.june:
        return 'Jun';
      case DateTime.july:
        return 'Jul';
      case DateTime.august:
        return 'Aug';
      case DateTime.september:
        return 'Sep';
      case DateTime.october:
        return 'Oct';
      case DateTime.november:
        return 'Nov';
      case DateTime.december:
        return 'Dec';
      default:
        throw FormatException('Invalid month number: $month');
    }
  }

  String _formatHourMinute(DateTime dateTime) {
    String hour = (dateTime.hour % 12).toString().padLeft(2, '0');
    String minute = dateTime.minute.toString().padLeft(2, '0');
    String amPm = dateTime.hour < 12 ? 'AM' : 'PM';
    return '$hour:$minute$amPm';
  }

  LineChartData _buildChartData() {
    List<FlSpot> spots = [];
    dataPoints.forEach((data) {
      spots.add(FlSpot(data.timestamp.toDouble(), data.perHydro));
    });

    return LineChartData(
      gridData: FlGridData(show: false),
      titlesData: FlTitlesData(
        show: true,
        bottomTitles: SideTitles(
          showTitles: false, // Disable bottom titles
        ),
        leftTitles: SideTitles(
          showTitles: true,
          getTitles: (value) {
            if (value % 1 == 0 && value < 11) {
              return value.toInt().toString();
            } else {
              return '';
            }
          },
        ),
      ),
      borderData: FlBorderData(show: true),
      minX: dataPoints.isNotEmpty ? dataPoints.first.timestamp.toDouble() : 0,
      maxX: dataPoints.isNotEmpty ? dataPoints.last.timestamp.toDouble() : dataPoints.isNotEmpty ? dataPoints.first.timestamp.toDouble() : 1,
      minY: 0,
      maxY: 10,
      lineBarsData: [
        LineChartBarData(
          spots: spots,
          isCurved: true,
          colors: gradientColors,
          barWidth: 5,
          isStrokeCapRound: true,
          belowBarData: BarAreaData(show: true),
        ),
      ],
      lineTouchData: LineTouchData(
        touchTooltipData: LineTouchTooltipData(
          tooltipBgColor: Colors.blueGrey.withOpacity(0.8),
          getTooltipItems: (List<LineBarSpot> touchedSpots) {
            return touchedSpots.map((LineBarSpot touchedSpot) {
              final DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(touchedSpot.x.toInt());
              final WaterData? selectedData = dataPoints.firstWhere((data) => data.timestamp == touchedSpot.x.toInt(), orElse: () => WaterData(0, 0, 0));
              if (selectedData != null) {
                latestpH = selectedData.pH; // Update latest pH on point hover
              }
              return LineTooltipItem(
                '${_formatTime(dateTime)}, ${touchedSpot.y}',
                TextStyle(color: Colors.white),
              );
            }).toList();
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Water pH Chart'),
      ),
      body: Stack(
        children: [
          Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Text(
                      'Latest pH: $latestpH',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(50.0),
                  child: Container(
                    width: MediaQuery.of(context).size.width * 0.8,
                    child: LineChart(_buildChartData()),
                  ),
                ),
              ),
            ],
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: GestureDetector(
              onTap: () {
                setState(() {
                  isDaily = !isDaily;
                });
                fetchData();
              },
              child: Container(
                alignment: Alignment.center,
                padding: EdgeInsets.symmetric(vertical: 8),
                color: Colors.white,
                child: Text(
                  isDaily? 'Daily Chart' : 'Last 7 Days',
                  style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            )
        ],
      ),
    );
  }
}
