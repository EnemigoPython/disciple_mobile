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
          CREATE TABLE streak(
            streak_name TEXT, 
            streak_value INTEGER
          );
          INSERT INTO streak (streak_name, streak_value) VALUES ('Current streak', 0);
          INSERT INTO streak (streak_name, streak_value) VALUES ('Best streak', 0);
          ''',
        );
      },
      // Set the version. This executes the onCreate function and provides a
      // path to perform database upgrades and downgrades.
      version: 1,
    );
  }

  Future<List<DatabaseRow>> select(DatabaseQuery query) async {
    Database db = await database;
    List<Map<String, dynamic>> rows = await db.query(
      query.tableName, 
      where: query.whereStatement, 
      whereArgs: query.whereArgs
    );
    return rows.map((row) => DatabaseRow.fromMap(row)).toList();
  }

  Future<int> insert(DatabaseRow row) async {
    Database db = await database;
    return await db.insert(row.tableName, row.columns);
  }

  Future<int> delete(DatabaseQuery query) async {
    Database db = await database;
    return await db.delete(
      query.tableName, 
      where: query.whereStatement, 
      whereArgs: query.whereArgs
    );
  }

  Future<int> update(DatabaseRow row, DatabaseQuery query) async {
    Database db = await database;
    return await db.update(
      row.tableName, 
      row.columns, 
      where: query.whereStatement, 
      whereArgs: query.whereArgs,
      conflictAlgorithm: ConflictAlgorithm.replace
    );
  }
}

class DatabaseQuery {
  final String tableName;
  final String whereStatement;
  final List<String> whereArgs;

  DatabaseQuery(this.tableName, this.whereStatement, this.whereArgs);
}

abstract class DatabaseRow {
  final String tableName;
  final Map<String, dynamic> columns;

  DatabaseRow(this.tableName, this.columns);

  factory DatabaseRow.fromMap(Map<String, dynamic> map) {
    throw UnimplementedError('fromMap() must be implemented in subclass.');
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
  super('manifest', {
    'activity_id': activityId, 
    'activity_name': activityName, 
    'date_added': dateAdded, 
    'category_id': categoryId, 
    'target_minutes': targetMinutes
  });

  @override
  factory Manifest.fromMap(Map<String, dynamic> map) {
    return Manifest(
      map['activity_id'], 
      map['activity_name'], 
      DateTime.parse(map['date_added']), 
      map['category_id'], 
      map['target_minutes']
    );
  }
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
  super('category', {
    'category_id': categoryId, 
    'category_name': categoryName, 
    'category_colour': categoryColour
  });

  @override
  factory Category.fromMap(Map<String, dynamic> map) {
    return Category(
      map['category_id'], 
      map['category_name'], 
      map['category_colour']
    );
  }
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
  super('activity_log', {
    'log_id': logId, 
    'activity_id': activityId, 
    'date_logged': dateLogged, 
    'minutes': minutes
  });

  @override
  factory ActivityLog.fromMap(Map<String, dynamic> map) {
    return ActivityLog(
      map['log_id'], 
      map['activity_id'], 
      DateTime.parse(map['date_logged']), 
      map['minutes']
    );
  }
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
  super('app_settings', {
    'setting_id': settingId, 
    'setting_name': settingName, 
    'setting_value': settingValue
  });

  @override
  factory AppSettings.fromMap(Map<String, dynamic> map) {
    return AppSettings(
      map['setting_id'], 
      map['setting_name'], 
      map['setting_value']
    );
  }
}

class Streak extends DatabaseRow {
  final String streakName;
  final int streakValue;

  Streak(
    this.streakName, 
    this.streakValue
  ) : 
  super('streak', {
    'streak_name': streakName, 
    'streak_value': streakValue
  });

  @override
  factory Streak.fromMap(Map<String, dynamic> map) {
    return Streak(
      map['streak_name'], 
      map['streak_value']
    );
  }
}
