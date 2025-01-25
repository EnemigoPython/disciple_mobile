import 'package:flutter/material.dart';

AppBar customAppBar(BuildContext context) {
  return AppBar(
    title: Text('Disciple', style: TextStyle(color: Theme.of(context).colorScheme.primary)),
    leading: Icon(Icons.rocket),
    backgroundColor: Theme.of(context).colorScheme.inversePrimary,
  );
}
