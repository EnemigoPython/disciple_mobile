import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'model/db.dart';
import 'model/store.dart';
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
  runApp(
    MultiProvider(
      providers: [
        Provider<DatabaseService>(create: (_) => DatabaseService()),
        ChangeNotifierProvider<ActivityStore>(create: (_) => ActivityStore()),
      ],
      child: discipleApp()
    )
  );
}
