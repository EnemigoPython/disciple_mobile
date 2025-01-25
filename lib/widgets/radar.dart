import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class RadarGraph extends StatelessWidget {
  const RadarGraph({super.key});

  @override 
  Widget build(BuildContext context) {
    return RadarChart(
      RadarChartData(
        dataSets: [
          RadarDataSet(
            dataEntries: [
              RadarEntry(value: 1),
              RadarEntry(value: 2),
              RadarEntry(value: 3),
              RadarEntry(value: 4),
              RadarEntry(value: 5),
              RadarEntry(value: 6),
            ],
            borderColor: Theme.of(context).colorScheme.inversePrimary,
            // fillColor: Theme.of(context).colorScheme.secondary,
        )]
      ),
      duration: Duration(milliseconds: 150),
      curve: Curves.linear,
  );
  }
}
