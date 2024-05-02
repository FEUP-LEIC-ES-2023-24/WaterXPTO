import 'dart:async';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final _databaseName = "WaterXpto.db";
  static final _databaseVersion = 2;
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
        ALTER TABLE WaterConsumption ADD COLUMN waterSpent REAL;
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
    int id = row['id'];
    return await db.update('User', row, where: 'id = ?', whereArgs: [id]);
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
    var result = await db.rawQuery('SELECT SUM(waterSpent) as Total FROM WaterConsumption');
    double total = result[0]['Total'] as double? ?? 0.0;
    print('Sum of all water flows: $total\n');
    return total;
  }

  void _updateWaterSpentStream() async {
    double total = await sumAllWaterFlows();
    print('Updating water spent stream with total: $total\n');
    _waterSpentController.add(total);
  }
}