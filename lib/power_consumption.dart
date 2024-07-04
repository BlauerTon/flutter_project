import 'dart:math';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class StatCard extends StatelessWidget {
  final String title;
  final String value;

  const StatCard({required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0), // Reduced padding
        child: Column(
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 14.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 4.0), // Reduced space
            Text(
              value,
              style: TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class PowerConsumptionPage extends StatelessWidget {
  List<FlSpot> generateDetailedValues(int count) {
    List<FlSpot> values = [];
    Random random = Random();
    for (int i = 0; i < count; i++) {
      values.add(FlSpot(i.toDouble(), random.nextDouble() * 30 + 10));
    }
    return values;
  }

  @override
  Widget build(BuildContext context) {
    List<FlSpot> detailedValues = generateDetailedValues(20); // Generate 20 detailed values

    return Scaffold(
      appBar: AppBar(
        title: Text('Power Consumption'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: Card(
                elevation: 4.0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.0),
                ),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 8.0), // Adjusted padding
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Power Consumption: Last hour',
                        style: TextStyle(
                          fontSize: 16.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 8.0),
                      AspectRatio(
                        aspectRatio: 1.6, // Adjust the aspect ratio
                        child: LineChart(
                          LineChartData(
                            lineBarsData: [
                              LineChartBarData(
                                spots: detailedValues,
                                isCurved: true,
                                color: Colors.blue, // Use a single Color
                                barWidth: 4,
                                belowBarData: BarAreaData(show: false),
                              ),
                            ],
                            titlesData: FlTitlesData(
                              leftTitles: AxisTitles(
                                sideTitles: SideTitles(
                                  showTitles: true,
                                  interval: 5, // Set interval for y-axis
                                  getTitlesWidget: (value, meta) {
                                    return Text(
                                      value.toStringAsFixed(0),
                                      style: TextStyle(
                                        fontSize: 10,
                                      ),
                                    );
                                  },
                                ),
                              ),
                              bottomTitles: AxisTitles(
                                sideTitles: SideTitles(
                                  showTitles: true,
                                  interval: 1, // Set interval for x-axis
                                  getTitlesWidget: (value, meta) {
                                    return Text(
                                      value.toStringAsFixed(0),
                                      style: TextStyle(
                                        fontSize: 10,
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ),
                            gridData: FlGridData(show: true),
                            borderData: FlBorderData(show: true),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(height: 8.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                StatCard(
                  title: 'Maximum',
                  value: '${detailedValues.map((e) => e.y).reduce(max).toStringAsFixed(1)} W',
                ),
                StatCard(
                  title: 'Minimum',
                  value: '${detailedValues.map((e) => e.y).reduce(min).toStringAsFixed(1)} W',
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

void main() => runApp(MaterialApp(home: PowerConsumptionPage()));
