import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

Future<Database> databaseConnection() async {  
  // Avoid errors caused by flutter upgrade.
  // Importing 'package:flutter/widgets.dart' is required.
  WidgetsFlutterBinding.ensureInitialized();
  // Open the database and store the reference.
  return openDatabase(
    // Set the path to the database. Note: Using the `join` function from the
    // `path` package is best practice to ensure the path is correctly
    // constructed for each platform.
    join(await getDatabasesPath(), 'disciple.db'),
    onCreate: (db, version) {
      // Run the CREATE TABLE statement on the database.
      return db.execute(
        'CREATE TABLE dogs(id INTEGER PRIMARY KEY, name TEXT, age INTEGER)',
      );
    },
    // Set the version. This executes the onCreate function and provides a
    // path to perform database upgrades and downgrades.
    version: 1,
  );
}

class Manifest {
  final int activityId;
  final String activityName;
  final DateTime dateAdded;
  final int categoryId;
  final int targetMinutes;

  Manifest(
    this.activityId, 
    this.activityName, 
    this.dateAdded, 
    this.categoryId, 
    this.targetMinutes
  );
}

class Category {
  final int categoryId;
  final String categoryName;
  final String categoryColour;

  Category(
    this.categoryId, 
    this.categoryName, 
    this.categoryColour
  );
}

class ActivityLog {
  final int logId;
  final int activityId;
  final DateTime dateLogged;
  final int minutes;

  ActivityLog(
    this.logId, 
    this.activityId, 
    this.dateLogged, 
    this.minutes
  );
}

class AppSettings {
  final int settingId;
  final String settingName;
  final String settingValue;

  AppSettings(
    this.settingId, 
    this.settingName, 
    this.settingValue
  );
}

String camelCaseToSnakeCase(String input) {
  return input.replaceAllMapped(
    RegExp(r'[A-Z]'),
    (match) => '_${match.group(0)!.toLowerCase()}',
  );
}
