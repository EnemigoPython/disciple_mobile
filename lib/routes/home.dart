import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../model/db.dart';
import '../model/store.dart';
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
  late ActivityStore activityStore;
  int? currentStreakValue;
  int? bestStreakValue;
  String selectedDate = ActivityStore.dateKey(DateTime.now());

  @override
  void initState() {
    super.initState();
    databaseService = Provider.of<DatabaseService>(context, listen: false);
    activityStore = Provider.of<ActivityStore>(context, listen: false);
    getStreaks();
    getManifest();
  }

  Future<void> updateSelectedDate(DateTime newDate) async {
    selectedDate = ActivityStore.dateKey(newDate);
    await getActivityData();
    print('$selectedDate, ${activityStore.activities}');
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
    activityStore.addManifest(rows.cast<Manifest>());
    getActivityData();
  }

  Future<void> getActivityData() async {
    Map<String, int>? activitiesForDate = activityStore.getActivitiesForDate(
      selectedDate
    );
    if (activitiesForDate != null) {
      return;
    }
    for (Manifest activity in activityStore.manifest) {
      List<DatabaseRow> rows = await databaseService.select(
        DatabaseQuery(
          tableName: 'activity_log', 
          whereStatement: 'activity_id = ? AND date_logged LIKE ?',
          whereArgs: [
            activity.activityId, 
            '$selectedDate%'
          ]
        )
      );
      List<ActivityLog> activityLogs = rows.cast<ActivityLog>();
      int totalMinutes = activityLogs.fold<int>(
        0, 
        (previousValue, activityLog) => previousValue + activityLog.minutes
      );
      activityStore.addActivity(
        selectedDate, 
        activity.activityName, 
        totalMinutes
      );
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
                  child: RadarGraph(onUpdateGraph: () {}), 
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
