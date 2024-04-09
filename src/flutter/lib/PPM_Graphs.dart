import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class WaterData {
  final int timestamp;
  final double waterHardness;

  WaterData(this.timestamp, this.waterHardness);
}

class SecondScreen extends StatefulWidget {
  @override
  _SecondScreenState createState() => _SecondScreenState();
}

class _SecondScreenState extends State<SecondScreen> {
  final List<Color> gradientColors = [Colors.blue, Colors.green];
  List<WaterData> dataPoints = [];

  // Fetch data from the API
 Future<void> fetchData() async {
  try {
    final response = await http.get(Uri.parse('http://localhost:5000/get_all_readings'));
    if (response.statusCode == 200) {
      List<dynamic> jsonResponse = jsonDecode(response.body);
      List<WaterData> fetchedData = jsonResponse.map((data) {
        // Parse the date string manually
        DateTime dateTime = _parseDateString(data['timestp']);
        return WaterData(
          dateTime.millisecondsSinceEpoch,
          data['PPM'].toDouble(),
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

  return DateTime(year, month, day, hour, minute, second);
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






  @override
  void initState() {
    super.initState();
    fetchData();
  }

  LineChartData _buildChartData() {
    List<FlSpot> spots = [];
    dataPoints.forEach((data) {
      spots.add(FlSpot(data.timestamp.toDouble(), data.waterHardness));
    });

    print('Data Points: $dataPoints');
    print('FlSpots: $spots');

    return LineChartData(
      gridData: FlGridData(show: false),
      titlesData: FlTitlesData(
        show: true,
        bottomTitles: SideTitles(
          showTitles: true,
          getTitles: (value) {
  DateTime date = DateTime.fromMillisecondsSinceEpoch((value * 1000).toInt());
  return '${date.hour}:${date.minute.toString().padLeft(2, '0')}';
        },

        ),
        leftTitles: SideTitles(
          showTitles: true,
          getTitles: (value) {
            if (value % 5 == 0) {
              return value.toInt().toString();
            } else {
              return '';
            }
          },
        ),
      ),
      borderData: FlBorderData(show: true),
      minX: dataPoints.isNotEmpty ? dataPoints.first.timestamp.toDouble() : 0,
      maxX: dataPoints.isNotEmpty ? dataPoints.last.timestamp.toDouble() : 1,
      minY: 0,
      maxY: dataPoints.isNotEmpty ? dataPoints.map((e) => e.waterHardness).reduce((a, b) => a > b ? a : b) + 10 : 10,
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
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Water Hardness Chart'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Container(
            width: MediaQuery.of(context).size.width * 0.8,
            child: LineChart(_buildChartData()),
          ),
        ),
      ),
    );
  }
}
