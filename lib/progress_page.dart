import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class ProgressPage extends StatelessWidget {
  final List<double> weeklyData = [5, 10, 7, 3, 8, 6, 4];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        children: [
          Text('Weekly Alone Time (in minutes)', style: TextStyle(fontSize: 20)),
          SizedBox(height: 24),
          SizedBox(
            height: 200,
            child: BarChart(
              BarChartData(
                borderData: FlBorderData(show: false),
                titlesData: FlTitlesData(
                  leftTitles: SideTitles(showTitles: true),
                  bottomTitles: SideTitles(
                    showTitles: true,
                    getTitles: (value) {
                      return ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'][value.toInt()];
                    },
                  ),
                ),
                barGroups: List.generate(7, (i) {
                  return BarChartGroupData(x: i, barRods: [
                    BarChartRodData(toY: weeklyData[i], width: 15),
                  ]);
                }),
              ),
            ),
          ),
          SizedBox(height: 24),
          Text('Total this week: ${weeklyData.reduce((a, b) => a + b)} minutes'),
        ],
      ),
    );
  }
}
