import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class TemperatureData {
  final int timestamp;
  final double temperatureValue;

  TemperatureData(this.timestamp, this.temperatureValue);
}

class FourthScreen extends StatelessWidget {
  final List<Color> gradientColors = [Colors.purple, Colors.deepPurple];

  List<FlSpot> getChartData(List<TemperatureData> dataPoints) {
    List<FlSpot> chartData = dataPoints
        .map((data) => FlSpot(data.timestamp.toDouble(), data.temperatureValue))
        .toList();
    return chartData;
  }

  @override
  Widget build(BuildContext context) {
    List<TemperatureData> dataPoints = [
      TemperatureData(1, 25.0),
      TemperatureData(2, 26.0),
      TemperatureData(3, 27.0),
      TemperatureData(4, 28.0),
      TemperatureData(5, 29.0),
    ];

    List<FlSpot> data = getChartData(dataPoints);

    return Scaffold(
      appBar: AppBar(
        title: Text('Temperature Chart'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: LineChart(
            LineChartData(
              gridData: FlGridData(show: false),
              titlesData: FlTitlesData(
                show: true,
                bottomTitles: SideTitles(
                  showTitles: true,
                  getTitles: (value) {
                    switch (value.toInt()) {
                      case 1:
                        return 'Day 1';
                      case 2:
                        return 'Day 2';
                      case 3:
                        return 'Day 3';
                      case 4:
                        return 'Day 4';
                      case 5:
                        return 'Day 5';
                      default:
                        return '';
                    }
                  },
                ),
                leftTitles: SideTitles(
                  showTitles: true,
                  getTitles: (value) {
                    if (value % 1 == 0) {
                      return value.toString();
                    } else {
                      return '';
                    }
                  },
                ),
              ),
              borderData: FlBorderData(show: false),
              minX: 0,
              maxX: 6,
              minY: 0,
              maxY: 30, // Adjust maxY as needed based on your data
              lineBarsData: [
                LineChartBarData(
                  spots: data,
                  isCurved: true,
                  colors: gradientColors,
                  barWidth: 5,
                  isStrokeCapRound: true,
                  belowBarData: BarAreaData(show: false),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
