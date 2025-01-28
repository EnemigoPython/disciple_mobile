import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../model/db.dart';
import '../model/store.dart';
import '../widgets/app_bar.dart';
import '../widgets/log_row.dart';

class LogRoute extends StatefulWidget {
  const LogRoute({super.key});

  @override
  State<LogRoute> createState() => _LogRouteState();
}

class _LogRouteState extends State<LogRoute> {
  late DatabaseService databaseService;
  late ActivityStore activityStore;
  final List<String> items = List.generate(20, (index) => "Row $index");

  @override
  void initState() {
    super.initState();
    databaseService = Provider.of<DatabaseService>(context, listen: false);
    activityStore = Provider.of<ActivityStore>(context, listen: false);
    activityStore.resetCache();
  }

  Future<void> insertActivityLogs(Map<String, int> activities) async {
    for (MapEntry<String, int> entry in activities.entries) {
      String activityName = entry.key;
      int activityId = activityStore.manifest.firstWhere(
        (manifest) => manifest.activityName == activityName
      ).activityId!;
      int minutes = entry.value;
      int previousMinutes = activityStore.activities[activityName]!;
      if (minutes == previousMinutes) {
        continue;
      }
      int newMinutes = minutes - previousMinutes;
      ActivityLog activityLog = ActivityLog.fromMap({
        'activity_id': activityId,
        'date_logged': DateTime.now().toString(),
        'minutes': newMinutes,
      });
      await databaseService.insert(activityLog);
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.surface,
        appBar: customAppBar(context),
        body: ListView.separated(
          itemCount: activityStore.manifest.length,
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 8.0),
              child: LogRow(
                activityName: activityStore.manifest[index].activityName,
                activityMinutes: activityStore.activities[
                  activityStore.manifest[index].activityName
                ] ?? 0,
              ),
            );
          },
          separatorBuilder: (context, index) => Divider(
            thickness: 1,
            color: Colors.grey[300],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Map<String, int> updatedActivities = activityStore.saveCache();
            insertActivityLogs(updatedActivities);
            Navigator.pop(context);
          },
          tooltip: 'Return to Home',
          child: Icon(Icons.arrow_back_rounded),
        ),
      ),
    );
  }
}