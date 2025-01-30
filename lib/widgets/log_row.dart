import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../model/store.dart';

class LogRow extends StatefulWidget {
  final String activityName;
  final Color activityColour;
  final IconData activityIcon;
  final int activityMinutes;

  const LogRow({
    super.key, 
    required this.activityName,
    required this.activityColour,
    required this.activityIcon,
    required this.activityMinutes
  });

  @override
  State<LogRow> createState() => _LogRowState();
}

class _LogRowState extends State<LogRow> {
  late ActivityStore activityStore;
  late String activityName;
  late Color activityColour;
  late IconData activityIcon;
  late int activityMinutes;
  bool isRecording = false;

  @override
  void initState() {
    super.initState();
    activityStore = Provider.of<ActivityStore>(context, listen: false);
    activityName = widget.activityName;
    activityColour = widget.activityColour;
    activityIcon = widget.activityIcon;
    activityMinutes = widget.activityMinutes;
  }

  Row recordingRow() {
    return isRecording ? Row(
      spacing: 5,
      children: [
        Text('Stop'),
        IconButton(
          icon: Icon(Icons.stop), 
          onPressed: () {
            int recordedMinutes = activityStore.stopRecording(activityName);
            setState(() {
              isRecording = !isRecording;
              activityMinutes += recordedMinutes;
              activityStore.updateCache(activityName, activityMinutes);
            });
          }
        ),
      ],
    ) : Row(
      spacing: 5,
      children: [
        Text(
          'Record',
          style: TextStyle(color: Colors.red),
        ),
        IconButton(
          icon: Icon(Icons.fiber_manual_record, color: Colors.red), 
          onPressed: () {
            activityStore.startRecording(activityName);
            setState(() {
              isRecording = !isRecording;
            });
          }
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Row(
          spacing: 5,
          children: [
            Icon(Icons.directions_run),
            Text(activityName),
          ],
        ),
        Spacer(),
        Container(
          margin: EdgeInsets.only(right: 15),
          child: recordingRow(),
        ),
        IconButton(
          icon: Icon(Icons.remove),
          color: Colors.red,
          onPressed: () {
            setState(() {
              if (activityMinutes == 0) return;
              activityMinutes--;
              activityStore.updateCache(activityName, activityMinutes);
            });
          },
        ),
        Row(
          children: [
            SizedBox(
              width: 30,
              child: TextField(
                decoration: null,
                textAlign: TextAlign.center,
                keyboardType: TextInputType.number,
                controller: TextEditingController.fromValue(
                  TextEditingValue(
                    text: activityMinutes.toString(),
                    selection: TextSelection.fromPosition(
                      TextPosition(offset: activityMinutes.toString().length),
                    ),
                  ),
                ),
                onChanged: (text) {
                  if (text.isEmpty) {
                    setState(() {
                      activityMinutes = 0;
                      activityStore.updateCache(activityName, activityMinutes);
                    });
                    return;
                  }
                  final number = int.tryParse(text);
                  if (number != null) {
                    setState(() {
                      activityMinutes = number;
                      activityStore.updateCache(activityName, activityMinutes);
                    });
                  }
                },
              ),
            ),
            IconButton(
              icon: Icon(Icons.add),
              color: Colors.green,
              onPressed: () {
                setState(() {
                  activityMinutes++;
                  activityStore.updateCache(activityName, activityMinutes);
                });
              },
            ),
          ],
        ),
      ],
    );
  }
}
