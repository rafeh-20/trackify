import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import '../models/habit.dart';
import 'dart:io' as io;

class DatabaseHelper {
  static const _dbName = 'HabitDatabase.db';
  static const _dbVersion = 1;
  static const _tableName = 'habits';
  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  static Database? _database;
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initiateDatabase();
    return _database!;
  }

  _initiateDatabase() async {
    io.Directory directory = await getApplicationDocumentsDirectory();
    String path = join(directory.path, _dbName);
    return await openDatabase(path, version: _dbVersion, onCreate: _onCreate);
  }

  Future _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE $_tableName (
        id TEXT PRIMARY KEY,
        name TEXT,
        description TEXT,
        category TEXT,
        startDate TEXT,
        dayStatuses TEXT,
        streakCount INTEGER,
        totalDays INTEGER,
        isCompleted INTEGER
      )
    ''');
  }

  Future<int> insert(Habit habit) async {
    Database db = await instance.database;
    return await db.insert(_tableName, habit.toMap());
  }

  Future<List<Habit>> getAllHabits() async {
    Database db = await instance.database;
    final List<Map<String, dynamic>> maps = await db.query(_tableName);
    return List.generate(maps.length, (i) {
      return Habit.fromMap(maps[i]);
    });
  }

  Future<int> update(Habit habit) async {
    Database db = await instance.database;
    return await db.update(_tableName, habit.toMap(),
        where: 'id = ?', whereArgs: [habit.id]);
  }

  Future<int> delete(String id) async {
    Database db = await instance.database;
    return await db.delete(_tableName, where: 'id = ?', whereArgs: [id]);
  }
}