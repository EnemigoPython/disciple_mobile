import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../db.dart';
import '../routes/log.dart';
import '../widgets/app_bar.dart';
import '../widgets/date_picker.dart';
import '../widgets/radar.dart';
import '../widgets/streak_indicator.dart';

class HomeRoute extends StatefulWidget {
  const HomeRoute({super.key});

  @override
  State<HomeRoute> createState() => _HomeRouteState();
}

class _HomeRouteState extends State<HomeRoute> {
  late DatabaseService databaseService;
  int? currentStreakValue;
  int? bestStreakValue;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    databaseService = Provider.of<DatabaseService>(context, listen: false);
    getStreaks();
  }

  //  @override
  // void initState() {
  //   super.initState();
  //   getStreaks();
  // }

  Future<List<DatabaseRow>> getStreaks() async {
    return await databaseService.select(DatabaseQuery(tableName: 'streak'));
  }

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
                      StreakIndicator(
                        flameColor: Colors.red, 
                        streakText: 'Current streak', 
                        streakValue: currentStreakValue
                      ),
                      StreakIndicator(
                        flameColor: Colors.cyan, 
                        streakText: 'Best streak', 
                        streakValue: bestStreakValue
                      ),
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
