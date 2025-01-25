import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'db.dart';
import 'routes/home.dart';

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
  runApp(
    Provider(
      create: (_) => SqfliteHelper(),
      child: discipleApp()
    )
  );
}
