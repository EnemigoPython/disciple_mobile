import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:provider/provider.dart';

import '../model/store.dart';

class RadarGraph extends StatefulWidget {
  final Function() onUpdateGraph;

  const RadarGraph({super.key, required this.onUpdateGraph});

  @override
  State<RadarGraph> createState() => _RadarGraphState();
}

class _RadarGraphState extends State<RadarGraph> {
  late ActivityStore activityStore;

  @override
  void initState() {
    super.initState();
    activityStore = Provider.of<ActivityStore>(context, listen: false);
  }
  
  @override 
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: activityStore,
      builder: (BuildContext context, Widget? child) {
        return activityStore.manifest.length < 3 ? 
        Container() : 
        RadarChart(
          RadarChartData(
            dataSets: [
              RadarDataSet(
                dataEntries: activityStore.activities.entries.map((entry) {
                  print('draw');
                  return RadarEntry(value: entry.value.toDouble());
                }).toList(),
                borderColor: Theme.of(context).colorScheme.inversePrimary,
                // fillColor: Theme.of(context).colorScheme.secondary,
            )]
          ),
          duration: Duration(milliseconds: 300),
          curve: Curves.linear,
        );
      }
    );
  }
}
