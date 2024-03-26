import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class PhData {
  final int timestamp;
  final double pHValue;

  PhData(this.timestamp, this.pHValue);
}

class ThirdScreen extends StatelessWidget {
  final List<Color> gradientColors = [Colors.orange, Colors.red];

  List<FlSpot> getChartData(List<PhData> dataPoints) {
    List<FlSpot> chartData = dataPoints
        .map((data) => FlSpot(data.timestamp.toDouble(), data.pHValue))
        .toList();
    return chartData;
  }

  @override
  Widget build(BuildContext context) {
    List<PhData> dataPoints = [
      PhData(1, 6.5),
      PhData(2, 6.0),
      PhData(3, 5.5),
      PhData(4, 5.0),
      PhData(5, 4.5),
    ];

    List<FlSpot> data = getChartData(dataPoints);

    return Scaffold(
      appBar: AppBar(
        title: Text('pH Value Chart'),
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
              maxY: 7, // Adjust maxY as needed based on your data
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
