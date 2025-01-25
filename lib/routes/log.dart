import 'package:flutter/material.dart';

import '../widgets/app_bar.dart';

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