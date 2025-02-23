import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:path/path.dart';
import 'package:sqflite_common_ffi_web/sqflite_ffi_web.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseService {
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

    // UNCOMMENT for cleaning up old DB paths as necessary
    // List<String> oldDbPaths = [
    //   'disciple.db',
    // ];
    // for (String path in oldDbPaths) {
    //   String _path = join(await getDatabasesPath(), path);
    //   await deleteDatabase(_path);
    // }

    // Default web database path
    String path = 'disciple.db';

    if (kIsWeb) {
      // Change default factory on the web
      databaseFactory = databaseFactoryFfiWeb;
    } else {
      // Set the path to the database. Note: Using the `join` function from the
      // `path` package is best practice to ensure the path is correctly
      // constructed for each platform.

      // TODO: clean up old db paths
      path = join(await getDatabasesPath(), 'disciple.db');
    }
    // Open the database and store the reference.
    return await openDatabase(
      path,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE manifest(
            activity_id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, 
            activity_name TEXT, 
            date_added TEXT, 
            target_minutes INTEGER,
            colour TEXT,
            icon_code_point INTEGER,
            icon_font_family TEXT
          );''');
        await db.execute('''
          CREATE TABLE activity_log(
            log_id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, 
            activity_id INTEGER, 
            date_logged TEXT, 
            date_logged_for TEXT,
            minutes INTEGER
          );''');
        await db.execute('''
          CREATE TABLE app_settings(
            setting_id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, 
            setting_name TEXT, 
            setting_value TEXT
          );''');
        await db.execute('''
          CREATE TABLE streak(
            streak_name TEXT, 
            streak_value INTEGER
          );''');
        await db.execute('''
          INSERT INTO streak (streak_name, streak_value) VALUES ('Current streak', 0);
          ''');
        await db.execute('''
          INSERT INTO streak (streak_name, streak_value) VALUES ('Best streak', 0);
          ''');
      },
      // Set the version. This executes the onCreate function and provides a
      // path to perform database upgrades and downgrades.
      version: 3,
    );
  }

  Future<List<DatabaseRow>> select(DatabaseQuery query) async {
    Database db = await database;
    List<Map<String, dynamic>> rows = await db.query(
      query.tableName, 
      where: query.whereStatement, 
      whereArgs: query.whereArgs
    );
    return rows.map((row) => DatabaseRow.fromMap(query.tableName, row)).toList();
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
  final String? whereStatement;
  final List<dynamic>? whereArgs;

  DatabaseQuery({
    required this.tableName, 
    this.whereStatement, 
    this.whereArgs
  });
}

abstract class DatabaseRow {
  final String tableName;
  final Map<String, dynamic> columns;

  DatabaseRow(this.tableName, this.columns);

  static String colorToHex(Color color) {
    return '#'
        '${(color.a * 255).toInt().toRadixString(16).padLeft(2, '0')}'
        '${(color.r * 255).toInt().toRadixString(16).padLeft(2, '0')}'
        '${(color.g * 255).toInt().toRadixString(16).padLeft(2, '0')}'
        '${(color.b * 255).toInt().toRadixString(16).padLeft(2, '0')}';
  }

  static Color hexToColor(String hex) {
    hex = hex.replaceFirst('#', '');
    double a = int.parse(hex.substring(0, 2), radix: 16) / 255.0;
    double r = int.parse(hex.substring(2, 4), radix: 16) / 255.0;
    double g = int.parse(hex.substring(4, 6), radix: 16) / 255.0;
    double b = int.parse(hex.substring(6, 8), radix: 16) / 255.0;

    return Color.fromRGBO(
      (r * 255).toInt(),
      (g * 255).toInt(),
      (b * 255).toInt(),
      a,
    );
  }


  factory DatabaseRow.fromMap(String tableName, Map<String, dynamic> map) {
    switch (tableName) {
      case 'manifest':
        return Manifest.fromMap(map);
      case 'activity_log':
        return ActivityLog.fromMap(map);
      case 'app_settings':
        return AppSettings.fromMap(map);
      case 'streak':
        return Streak.fromMap(map);
    }
    throw UnsupportedError('Unknown table name: ${map['table_name']}');
  }
}

class Manifest extends DatabaseRow {
  int? activityId;
  final String activityName;
  final DateTime dateAdded;
  final int? targetMinutes;
  final Color colour;
  final IconData icon;

  Manifest(
    this.activityId, 
    this.activityName, 
    this.dateAdded, 
    this.targetMinutes,
    this.colour,
    this.icon 
  ) : 
  super('manifest', {
    'activity_id': activityId, 
    'activity_name': activityName, 
    'date_added': dateAdded.toString(), 
    'target_minutes': targetMinutes,
    'colour': DatabaseRow.colorToHex(colour),
    'icon_code_point': icon.codePoint,
    'icon_font_family': icon.fontFamily
  });

  @override
  factory Manifest.fromMap(Map<String, dynamic> map) {
    return Manifest(
      map['activity_id'], 
      map['activity_name'], 
      DateTime.parse(map['date_added']), 
      map['target_minutes'],
      DatabaseRow.hexToColor(map['colour']),
      IconData(map['icon_code_point'], fontFamily: map['icon_font_family'])
    );
  }
}

class ActivityLog extends DatabaseRow {
  int? logId;
  final int activityId;
  final DateTime dateLogged;
  final DateTime dateLoggedFor;
  final int minutes;

  ActivityLog(
    this.logId, 
    this.activityId, 
    this.dateLogged, 
    this.dateLoggedFor,
    this.minutes
  ) : 
  super('activity_log', {
    'log_id': logId, 
    'activity_id': activityId, 
    'date_logged': dateLogged.toString(), 
    'date_logged_for': dateLoggedFor.toString(),
    'minutes': minutes
  });

  @override
  factory ActivityLog.fromMap(Map<String, dynamic> map) {
    return ActivityLog(
      map['log_id'], 
      map['activity_id'], 
      DateTime.parse(map['date_logged']), 
      DateTime.parse(map['date_logged_for']), 
      map['minutes']
    );
  }
}

class AppSettings extends DatabaseRow {
  int? settingId;
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
