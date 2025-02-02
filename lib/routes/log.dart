import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../model/db.dart';
import '../model/store.dart';
import '../widgets/add_log_modal.dart';
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

  Future<void> onAddActivity(String activityName, IconData icon, Color colour) async {
    Manifest newActivity = Manifest.fromMap({
      'activity_name': activityName,
      'date_added': DateTime.now().toString(),
      'colour': DatabaseRow.colorToHex(colour),
      'icon_code_point': icon.codePoint,
      'icon_font_family': icon.fontFamily
    });
    int activityId = await databaseService.insert(newActivity);
    newActivity.activityId = activityId;
    activityStore.addActivityToManifest(newActivity);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.surface,
        appBar: customAppBar(context),
        body: ListenableBuilder(
          listenable: activityStore,
          builder: (BuildContext context, Widget? child) { 
            return ListView.separated(
              itemCount: activityStore.manifest.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 8.0),
                  child: LogRow(
                    activityName: activityStore.manifest[index].activityName,
                    activityColour: activityStore.manifest[index].colour,
                    activityIcon: activityStore.manifest[index].icon,
                    activityMinutes: activityStore.activities[
                      activityStore.manifest[index].activityName
                    ]!,
                  ),
                );
              },
              separatorBuilder: (context, index) => Divider(
                thickness: 1,
                color: Colors.grey[300],
              ),
            ); 
          }
        ),
        floatingActionButton: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[  
            FloatingActionButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AddLogModal(onAddActivity: onAddActivity);
                  },
                );
              },
              tooltip: 'Add Activity',
              heroTag: 'add',
              child: Icon(Icons.add),
            ),
            SizedBox(width: 16),
            FloatingActionButton(
              onPressed: () async {
                Map<String, int> updatedActivities = activityStore.cache;
                insertActivityLogs(updatedActivities);
                activityStore.saveCache();
                Navigator.pop(context);
              },
              tooltip: 'Return to Home',
              heroTag: 'home',
              child: Icon(Icons.arrow_back_rounded),
            ),
          ]
        ),
      ),
    );
  }
}