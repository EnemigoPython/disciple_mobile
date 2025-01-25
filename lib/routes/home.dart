import 'package:flutter/material.dart';

import '../routes/log.dart';
import '../widgets/app_bar.dart';
import '../widgets/date_picker.dart';
import '../widgets/radar.dart';
import '../widgets/streak_indicator.dart';

class HomeRoute extends StatelessWidget {
  const HomeRoute({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.surface,
        appBar: customAppBar(context),
        body: Center(
          child: Padding(
            padding: EdgeInsets.only(top: 16, bottom: 16, left: 8, right: 8),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget> [
                SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: Row(
                    spacing: 10,
                    children: <Widget> [
                      StreakIndicator(flameColor: Colors.red, streakText: 'Current streak'),
                      StreakIndicator(flameColor: Colors.cyan, streakText: 'Best streak'),
                    ]
                  ),
                ),
                AspectRatio(
                  aspectRatio: 16 / 9,
                  child: RadarGraph(), 
                ),
                Flexible(
                  fit: FlexFit.tight,
                  child: DatePicker(),
                )
              ],
            ),
          ),
        ),
        floatingActionButton: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget> [
            FloatingActionButton(
              onPressed: () {},
              tooltip: 'Go to Settings',
              heroTag: 'settings',
              child: Icon(Icons.settings),
            ),
            SizedBox(width: 16), // Add some space between the FABs
            FloatingActionButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => LogRoute()),
                );
              },
              tooltip: 'Add Log',
              heroTag: 'log',
              child: Icon(Icons.add),
            ),
          ],
        ),
      ),
    );
  }
}
