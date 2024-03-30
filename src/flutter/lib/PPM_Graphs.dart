import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

// Define a model class for your data points
class WaterData {
  final int timestamp;
  final double waterHardness;

  WaterData(this.timestamp, this.waterHardness);
}

class SecondScreen extends StatelessWidget {
  final List<Color> gradientColors = [Colors.blue, Colors.green];

  // Pass a list of WaterData objects to getChartData
  List<FlSpot> getChartData(List<WaterData> dataPoints) {
    // Convert WaterData objects to FlSpot objects
    List<FlSpot> chartData = dataPoints
        .map((data) => FlSpot(data.timestamp.toDouble(), data.waterHardness))
        .toList();
    return chartData;
  }

  @override
  Widget build(BuildContext context) {
    // Example data points
    List<WaterData> dataPoints = [
      WaterData(1, 10.0),
      WaterData(2, 15.0),
      WaterData(3, 10.0),
      WaterData(4, 20.0),
      WaterData(5, 30.0),
      WaterData(6, 30.0),
      WaterData(7, 30.0),
    ];

    

    List<FlSpot> data = getChartData(dataPoints);

    return Scaffold(
      appBar: AppBar(
        title: Text('Water Hardness Chart'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Container(
            width: MediaQuery.of(context).size.width * 0.8, // Adjust the width here
            child: LineChart(
              LineChartData(
                gridData: FlGridData(show: false),
                titlesData: FlTitlesData(
                  show: true,
                  bottomTitles: SideTitles(
                    showTitles: true,
                    getTitles: (value) {
                      // Customize the bottom axis labels based on timestamp
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
                        case 6:
                          return 'Day 6';
                        case 7:
                          return 'Day 7';
                        default:
                          return '';
                      }
                    },
                  ),
                  leftTitles: SideTitles(
                    showTitles: true,
                    getTitles: (value) {
                      // Customize the left axis labels based on water hardness values
                      if (value % 10 == 0) {
                        return value.toInt().toString();
                      } else {
                        return '';
                      }
                    },
                  ),
                ),
                borderData: FlBorderData(show: true),
                minX: 1,
                maxX: 7,
                minY: 0,
                maxY: 40, // Adjust maxY as needed based on your data
                lineBarsData: [
                  LineChartBarData(
                    spots: data,
                    isCurved: true,
                    colors: gradientColors,
                    barWidth: 5,
                    isStrokeCapRound: true,
                    belowBarData: BarAreaData(show: true),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

