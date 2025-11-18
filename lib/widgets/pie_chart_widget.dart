import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class PieChartWidget extends StatelessWidget {
  final Map<String, double> dataMap;
  final String title;

  const PieChartWidget({super.key, required this.dataMap, required this.title});

  @override
  Widget build(BuildContext context) {
    if (dataMap.isEmpty) {
      return const Padding(
        padding: EdgeInsets.all(16),
        child: Text("No data to display."),
      );
    }

    final List<PieChartSectionData> sections = dataMap.entries.map((entry) {
      final color =
          Colors.primaries[dataMap.keys.toList().indexOf(entry.key) %
              Colors.primaries.length];

      return PieChartSectionData(
        title: '${entry.key}\n₹${entry.value.toStringAsFixed(0)}',
        value: entry.value,
        color: color,
        radius: 60,
        titleStyle: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      );
    }).toList();

    return Card(
      margin: const EdgeInsets.all(12),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Text(
              title,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            SizedBox(
              height: 220,
              child: PieChart(PieChartData(sections: sections)),
            ),
          ],
        ),
      ),
    );
  }
}
