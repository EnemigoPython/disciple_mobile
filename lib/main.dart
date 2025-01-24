import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:path/path.dart';
import 'package:provider/provider.dart';

import 'db.dart';

MaterialApp discipleApp() {
  return MaterialApp(
    title: 'Disciple',
    home: HomeRoute(),
    theme: ThemeData(
      colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      useMaterial3: true,
    ),
  );
}

void main() {
  // https://github.com/tekartik/sqflite/blob/master/sqflite/doc/opening_db.md
  // https://docs.flutter.dev/cookbook/persistence/sqlite
  // runApp(
  //   Provider(
  //     create: (_) => {},
  //     child: discipleApp()
  //   )
  // );
  runApp(discipleApp());
}

AppBar customAppBar(BuildContext context) {
  return AppBar(
    title: Text('Disciple', style: TextStyle(color: Theme.of(context).colorScheme.primary)),
    leading: Icon(Icons.rocket),
    backgroundColor: Theme.of(context).colorScheme.inversePrimary,
  );
}

class RadarGraph extends StatelessWidget {
  const RadarGraph({super.key});

  @override 
  Widget build(BuildContext context) {
    return RadarChart(
      RadarChartData(
        dataSets: [
          RadarDataSet(
            dataEntries: [
              RadarEntry(value: 1),
              RadarEntry(value: 2),
              RadarEntry(value: 3),
              RadarEntry(value: 4),
              RadarEntry(value: 5),
              RadarEntry(value: 6),
            ],
            borderColor: Theme.of(context).colorScheme.inversePrimary,
            // fillColor: Theme.of(context).colorScheme.secondary,
        )]
      ),
      duration: Duration(milliseconds: 150),
      curve: Curves.linear,
  );
  }
}

class DatePicker extends StatefulWidget {
  const DatePicker({super.key});

  @override
  DatePickerState createState() => DatePickerState();
}

class DatePickerState extends State<DatePicker> {
  DateTime? _selectedDate;

  void _showDatePicker(BuildContext context) {
    showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    ).then((pickedDate) {
      if (pickedDate != null) {
        setState(() {
          _selectedDate = pickedDate;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(_selectedDate != null
                ? 'Selected Date: ${_selectedDate.toString()}'
                : 'No date selected'),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => _showDatePicker(context),
              child: Text('Show Date Picker'),
            ),
          ],
        ),
      ),
    );
  }
}

class StreakIndicator extends StatelessWidget {
  final Color flameColor;
  final String streakText;

  const StreakIndicator({super.key, required this.flameColor, required this.streakText});

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: Colors.blueGrey,
        borderRadius: BorderRadius.circular(30),
      ),
      child: Padding(
        padding: EdgeInsets.only(top: 6, bottom: 6, left: 6, right: 6),
        child: Row(
          spacing: 10,
          children: <Widget> [
            SvgPicture.asset(
              'icons/flame.svg',
              colorFilter: ColorFilter.mode(flameColor, BlendMode.srcIn),
              width: 24,
              height: 24,
            ),
            Text('$streakText: 3', style: TextStyle(color: Colors.white, fontSize: 14)),
          ]
        ),
      ),
    );
  }
}

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

class LogRoute extends StatelessWidget {
  const LogRoute({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.surface,
        appBar: customAppBar(context),
        body: Center(
          child: Text('Hello World!'),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.pop(context);
          },
          tooltip: 'Return to Home',
          child: Icon(Icons.arrow_back_rounded),
        ),
      ),
    );
  }
}

class SettingsRoute extends StatelessWidget {
  const SettingsRoute({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: Scaffold(
        body: Center(
          child: Text('Hello World!'),
        ),
      ),
    );
  }
}
