import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:provider/provider.dart';

import '../model/store.dart';

class RadarGraph extends StatefulWidget {
  final Map<String, int> activities;

  const RadarGraph({super.key, required this.activities});

  @override
  State<RadarGraph> createState() => _RadarGraphState();
}

class _RadarGraphState extends State<RadarGraph> {
  late ActivityStore activityStore;
  Map<String, int> activities = {};

  @override
  void initState() {
    super.initState();
    activityStore = Provider.of<ActivityStore>(context, listen: false);
    activities = widget.activities;
    print(activities);
  }
  
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
              RadarEntry(value: 9),
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
