import 'package:flutter/material.dart';

import '../widgets/app_bar.dart';

class LogRoute extends StatelessWidget {
  final List<String> items = List.generate(20, (index) => "Row $index");

  LogRoute({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.surface,
        appBar: customAppBar(context),
        body: ListView.separated(
          itemCount: items.length,
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 8.0),
              child: Text(
                items[index],
                style: TextStyle(fontSize: 18),
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
            Navigator.pop(context);
          },
          tooltip: 'Return to Home',
          child: Icon(Icons.arrow_back_rounded),
        ),
      ),
    );
  }
}