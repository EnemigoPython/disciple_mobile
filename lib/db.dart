import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class SqfliteHelper {
  static Database? _database;

  Future<Database> get database async {
    // ??= null coalescing
    _database ??= await getConnection();
    // ! null assertion
    return _database!;
  }

  static Future<Database> getConnection() async {  
    // Avoid errors caused by flutter upgrade.
    // Importing 'package:flutter/widgets.dart' is required.
    WidgetsFlutterBinding.ensureInitialized();
    // Open the database and store the reference.
    return await openDatabase(
      // Set the path to the database. Note: Using the `join` function from the
      // `path` package is best practice to ensure the path is correctly
      // constructed for each platform.
      join(await getDatabasesPath(), 'disciple.db'),
      onCreate: (db, version) {
        // Run the CREATE TABLE statement on the database.
        return db.execute(
          '''
          CREATE TABLE manifest(
            activity_id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, 
            activity_name TEXT, 
            date_added TEXT, 
            category_id INTEGER, 
            target_minutes INTEGER
          );
          CREATE TABLE category(
            category_id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, 
            category_name TEXT, 
            category_colour TEXT
          );
          CREATE TABLE activity_log(
            log_id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, 
            activity_id INTEGER, 
            date_logged TEXT, 
            minutes INTEGER
          );
          CREATE TABLE app_settings(
            setting_id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, 
            setting_name TEXT, 
            setting_value TEXT
          );
          ''',
        );
      },
      // Set the version. This executes the onCreate function and provides a
      // path to perform database upgrades and downgrades.
      version: 1,
    );
  }
}


class DatabaseRow {
  final Map<String, dynamic> columns;

  DatabaseRow(this.columns);

  String camelCaseToSnakeCase(String input) {
    return input.replaceAllMapped(
      RegExp(r'[A-Z]'),
      (match) => '_${match.group(0)!.toLowerCase()}',
    );
  }

  @override
  String toString() {
    return '';
  }
}

class Manifest extends DatabaseRow {
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
  ) : 
  super({
    'activity_id': activityId, 
    'activity_name': activityName, 
    'date_added': dateAdded, 
    'category_id': categoryId, 
    'target_minutes': targetMinutes
  });
}

class Category extends DatabaseRow {
  final int categoryId;
  final String categoryName;
  final String categoryColour;

  Category(
    this.categoryId, 
    this.categoryName, 
    this.categoryColour
  ) : 
  super({
    'category_id': categoryId, 
    'category_name': categoryName, 
    'category_colour': categoryColour
  });
}

class ActivityLog extends DatabaseRow {
  final int logId;
  final int activityId;
  final DateTime dateLogged;
  final int minutes;

  ActivityLog(
    this.logId, 
    this.activityId, 
    this.dateLogged, 
    this.minutes
  ) : 
  super({
    'log_id': logId, 
    'activity_id': activityId, 
    'date_logged': dateLogged, 
    'minutes': minutes
  });
}

class AppSettings extends DatabaseRow {
  final int settingId;
  final String settingName;
  final String settingValue;

  AppSettings(
    this.settingId, 
    this.settingName, 
    this.settingValue
  ) : 
  super({
    'setting_id': settingId, 
    'setting_name': settingName, 
    'setting_value': settingValue
  });
}
