import 'dart:async';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final _databaseName = "WaterXpto.db";
  static final _databaseVersion = 3;
  final _waterSpentController = StreamController<double>.broadcast();
  static Database? _database;
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  Stream<double> get waterSpentStream => _waterSpentController.stream;
  DatabaseHelper._privateConstructor();
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  _initDatabase() async {
    String path = join(await getDatabasesPath(), _databaseName);
    return await openDatabase(path,
        version: _databaseVersion,
        onCreate: _onCreate,
        onUpgrade: _onUpgrade,
    );
  }

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (newVersion > oldVersion) {
      await db.execute('''
        ALTER TABLE WaterConsumption ADD COLUMN date TEXT;
      ''');
    }
  }
  Future _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE User (
        id INTEGER PRIMARY KEY,
        name TEXT,
        birthDate TEXT,
        email TEXT,
        nationality TEXT
      );
    ''');
    await db.execute('''
      CREATE TABLE Goal (
        id INTEGER PRIMARY KEY,
        name TEXT,
        description TEXT,
        deadline TEXT,
        userId INTEGER,
        FOREIGN KEY(userId) REFERENCES User(id)
      );
    ''');
    await db.execute('''
      CREATE TABLE WaterConsumption (
        id INTEGER PRIMARY KEY,
        waterSpent REAL
        date TEXT
      );
    ''');
  }

  //User CRUD operations
  Future<int> insertUser(Map<String, dynamic> row) async {
    Database db = await instance.database;
    return await db.insert('User', row);
  }

  Future<List<Map<String, dynamic>>> queryAllUsers() async {
    Database db = await instance.database;
    return await db.query('User');
  }

  Future<int> updateUser(Map<String, dynamic> row) async {
    Database db = await instance.database;
    return await db.update('User', row, where: 'id = ?', whereArgs: [1]);
  }

  Future<int> deleteUser(int id) async {
    Database db = await instance.database;
    return await db.delete('User', where: 'id = ?', whereArgs: [id]);
  }

  //Goals CRUD operations
  Future<int> insertGoal(Map<String, dynamic> row) async {
    Database db = await instance.database;
    return await db.insert('Goal', row);
  }

  Future<List<Map<String, dynamic>>> queryAllGoals() async {
    Database db = await instance.database;
    return await db.query('Goal');
  }

  Future<int> updateGoal(Map<String, dynamic> row) async {
    Database db = await instance.database;
    int id = row['id'];
    return await db.update('Goal', row, where: 'id = ?', whereArgs: [id]);
  }

  Future<int> deleteGoal(int id) async {
    Database db = await instance.database;
    return await db.delete('Goal', where: 'id = ?', whereArgs: [id]);
  }

  Future<int> insertWaterConsumption(Map<String, dynamic> row) async {
    Database db = await instance.database;
    int result = 0;
    try {
      await db.transaction((txn) async {
        row['date'] = DateTime.now().toIso8601String();
        result = await txn.insert('WaterConsumption', row);
      });
      _updateWaterSpentStream();
    } catch (e) {
      print('Error inserting water consumption: $e');
    }
    return result;
  }

  Future<List<Map<String, dynamic>>> queryAllWaterConsumptions() async {
    Database db = await instance.database;
    return await db.query('WaterConsumption');
  }

  Future<int> updateWaterConsumption(Map<String, dynamic> row) async {
    Database db = await instance.database;
    int id = row['id'];
    return await db.update('WaterConsumption', row, where: 'id = ?', whereArgs: [id]);
  }

  Future<int> deleteWaterConsumption(int id) async {
    Database db = await instance.database;
    return await db.delete('WaterConsumption', where: 'id = ?', whereArgs: [id]);
  }

  Future<double> sumAllWaterFlows() async {
    Database db = await instance.database;
    String currentDate = DateTime.now().toIso8601String().substring(0, 10); // Get the current date in ISO 8601 format
    var result = await db.rawQuery('SELECT SUM(waterSpent) as Total FROM WaterConsumption WHERE date LIKE "$currentDate%"');
    double total = result[0]['Total'] as double? ?? 0.0;
    print('Sum of all water flows: $total\n');
    return total;
  }

  void _updateWaterSpentStream() async {
    double total = await sumAllWaterFlows();
    print('Updating water spent stream with total: $total\n');
    _waterSpentController.add(total);
  }

  Future<void> deleteAllWaterConsumption() async {
    Database db = await instance.database;
    await db.rawDelete('DELETE FROM WaterConsumption');
  }

  Future<List<double>> getWaterConsumptionForWeek() async {
    Database db = await instance.database;
    String currentDate = DateTime.now().toIso8601String().substring(0, 10); // Get the current date in ISO 8601 format
    List<double> weekData = List.filled(7, 0.0); // Initialize a list of 7 zeros
    var result = await db.rawQuery('''
      SELECT date, SUM(waterSpent) as Total
      FROM WaterConsumption
      WHERE date >= date('$currentDate', '-6 days')
      GROUP BY date
      ORDER BY date ASC
    ''');
    for (var row in result) {
      int index = DateTime.parse(row['date'] as String).weekday - 1; // Get the day of the week (0-indexed)
      weekData[index] = row['Total'] as double? ?? 0.0;
    }
    return weekData;
  }

  int daysInMonth(int year, int month) {
    return month < 12 ? DateTime(year, month + 1, 0).day : DateTime(year + 1, 1, 0).day;
  }

  Future<List<double>> getWaterConsumptionForMonth() async {
    Database db = await instance.database;
    DateTime now = DateTime.now();
    List<double> monthData = List.filled(daysInMonth(now.year, now.month), 0.0); // Initialize a list of zeros
    var result = await db.rawQuery('''
      SELECT date, SUM(waterSpent) as Total
      FROM WaterConsumption
      WHERE strftime('%Y-%m', date) = strftime('%Y-%m', '$now')
      GROUP BY date
      ORDER BY date ASC
    ''');
    for (var row in result) {
      int index = DateTime.parse(row['date'] as String).day - 1; // Get the day of the month (0-indexed)
      monthData[index] = row['Total'] as double? ?? 0.0;
    }
    return monthData;
  }

  Future<List<double>> getWaterConsumptionForYear() async {
    Database db = await instance.database;
    List<double> yearData = List.filled(12, 0.0);
    var result = await db.rawQuery('''
      SELECT strftime('%m', date) as Month, SUM(waterSpent) as Total
      FROM WaterConsumption
      WHERE strftime('%Y', date) = strftime('%Y', 'now')
      GROUP BY Month
      ORDER BY Month ASC
    ''');
    for (var row in result) {
      int index = int.parse(row['Month'] as String) - 1;
      yearData[index] = row['Total'] as double? ?? 0.0;
    }
    return yearData;
  }

}