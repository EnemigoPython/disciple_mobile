import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:provider/provider.dart';

import '../model/store.dart';

class RadarGraph extends StatefulWidget {
  const RadarGraph({super.key});

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
        return Container(
          margin: EdgeInsets.only(top: 20),
          child: activityStore.manifest.length < 3 ? null :
          RadarChart(
            RadarChartData(
              getTitle: (index, angle) {
                return RadarChartTitle(
                  text: activityStore.activities.keys.toList()[index],
                  angle: angle,
                );
              },
              dataSets: [
                RadarDataSet(
                  dataEntries: activityStore.activities.values.map((value) {
                    return RadarEntry(value: value.toDouble());
                  }).toList(),
                  borderColor: Theme.of(context).colorScheme.inversePrimary,
                  // fillColor: Theme.of(context).colorScheme.secondary,
              )]
            ),
            duration: Duration(milliseconds: 0),
            curve: Curves.linear,
          ),
        );
      }
    );
  }
}
