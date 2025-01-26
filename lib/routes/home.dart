import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../model/db.dart';
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
  DateTime selectedDate = DateTime.now();
  List<Manifest> activities = [];
  List<ActivityLog> activityLogs = [];

   @override
  void initState() {
    super.initState();
    databaseService = Provider.of<DatabaseService>(context, listen: false);
    getStreaks();
    getManifest();
  }

  void updateSelectedDate(DateTime newDate) {
    setState(() => selectedDate = newDate);
  }

  Future<void> getStreaks() async {
    List<DatabaseRow> rows = await databaseService.select(DatabaseQuery(tableName: 'streak'));
    List<Streak> streaks = rows.cast<Streak>();
    setState(() {
      currentStreakValue = streaks.where(
        (streak) => streak.streakName == 'Current streak'
      ).first.streakValue;
      bestStreakValue = streaks.where(
        (streak) => streak.streakName == 'Best streak'
      ).first.streakValue;
    });
  }

  Future<void> getManifest() async {
    List<DatabaseRow> rows = await databaseService.select(DatabaseQuery(tableName: 'manifest'));
    setState(() {
      activities = rows.cast<Manifest>();
    });
    for (Manifest activity in activities) {
      List<DatabaseRow> logs = await databaseService.select(
        DatabaseQuery(
          tableName: 'activity_log', 
          whereStatement: 'activity_id = ?',
          whereArgs: [activity.activityId.toString()]
        )
      );
      List<ActivityLog> activityLogs = logs.cast<ActivityLog>();
      print(activityLogs);
    }
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
                  child: DatePicker(onUpdateDate: updateSelectedDate),
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
