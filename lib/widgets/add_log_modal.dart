import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../model/store.dart';

class AddLogModal extends StatefulWidget {
  final Function(String, IconData, Color) onAddActivity;

  const AddLogModal({super.key, required this.onAddActivity});

  @override
  State<AddLogModal> createState() => _AddLogModalState();
}

class _AddLogModalState extends State<AddLogModal> {
  late ActivityStore activityStore;
  String _activityName = '';
  IconData _selectedIcon = Icons.directions_run;
  Color _selectedColour = Colors.black;

  List<IconData> icons = [
    Icons.directions_run,
    Icons.directions_walk,
    Icons.local_cafe,
    Icons.local_bar,
    Icons.local_dining,
    Icons.beach_access,
    Icons.pool,
    Icons.spa,
    Icons.icecream,
    Icons.sports_baseball,
    Icons.sports_basketball,
    Icons.sports_soccer,
    Icons.sports_tennis,
    Icons.sports_volleyball,
    Icons.sports_motorsports,
    Icons.sports_handball,
    Icons.sports_cricket,
    Icons.sports_hockey,
    Icons.sports_golf,
    Icons.sports_rugby,
    Icons.sports_kabaddi,
    Icons.sports_mma,
    Icons.task,
    Icons.assignment,
    Icons.event,
    Icons.done,
    Icons.fact_check,
    Icons.checklist, 
    Icons.timer,
    Icons.cancel_outlined,
    Icons.hourglass_top,
    Icons.schedule,
    Icons.hiking,
    Icons.music_note,
    Icons.movie,
    Icons.theater_comedy,
    Icons.palette,
    Icons.videogame_asset,
    Icons.toys,
    Icons.card_giftcard,
    Icons.fitness_center,
    Icons.sports_gymnastics,
    Icons.self_improvement,
  ];

  List<Color> colours = [
    Colors.black,
    Colors.red,
    Colors.blue,
    Colors.green,
    Colors.purple,
    Colors.pink,
    Colors.orange,
  ];

  @override
  void initState() {
    super.initState();
    activityStore = Provider.of<ActivityStore>(context, listen: false);
  }

  bool isValidInput() {
    return _activityName.isNotEmpty && !activityStore.nameIsDuplicate(_activityName);
  }

  void saveActivity() {
    widget.onAddActivity(_activityName, _selectedIcon, _selectedColour);
    Navigator.of(context).pop();
  }

  void _showIconDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: SizedBox(
            width: 50,
            child: GridView.builder(
              shrinkWrap: true,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 5,
              ),
              itemCount: icons.length,
              itemBuilder: (BuildContext context, int index) {
                return IconButton(
                  onPressed: () {
                    setState(() {
                      _selectedIcon = icons[index];
                    });
                    Navigator.of(context).pop();
                    _showColorDialog();
                  },
                  icon: Icon(icons[index])
                );
              },
            ),
          ),
        );
      },
    );
  }

  void _showColorDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Row(
            mainAxisSize: MainAxisSize.min,
            children: List.generate(colours.length, (index) {
              return IconButton(
                  icon: Icon(_selectedIcon, color: colours[index]),
                  onPressed: () {
                    setState(() {
                      _selectedColour = colours[index];
                    });
                    Navigator.of(context).pop();
                  },
                );
            })
          ),
        );
      }
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Add Activity'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            spacing: 5,
            children: [
              IconButton(
                icon: Icon(_selectedIcon),
                color: _selectedColour,
                onPressed: _showIconDialog,
              ),
              SizedBox(
                width: 150,
                child: TextField(
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Enter Activity Name',
                    errorText: activityStore.nameIsDuplicate(_activityName) ? 
                      'Activity name already exists' : 
                      null
                  ),
                  onChanged: (text) {
                    setState(() {
                      _activityName = text;
                    });
                  }
                ),
              ),
            ],
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => isValidInput() ? saveActivity() : null,
          child: Text('Save'),
        ),
        TextButton(
          child: Text('Cancel'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }
}
