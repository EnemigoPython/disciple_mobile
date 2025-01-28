import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../model/store.dart';

class LogRow extends StatefulWidget {
  final String activityName;
  final int activityMinutes;

  const LogRow({
    super.key, 
    required this.activityName, 
    required this.activityMinutes
  });

  @override
  State<LogRow> createState() => _LogRowState();
}

class _LogRowState extends State<LogRow> {
  late ActivityStore activityStore;
  late String activityName;
  late int activityMinutes;

  @override
  void initState() {
    super.initState();
    activityStore = Provider.of<ActivityStore>(context, listen: false);
    activityName = widget.activityName;
    activityMinutes = widget.activityMinutes;
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
              width: 50,
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
