import '../models/transaction.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static final _databaseName = "transaction.db";
  static final _databaseVersion = "1";

  static final tableName = "transaction_table";

  static final columnId = "id";
  static final columnTitle = "title";
  static final columnAmount = "amount";
  static final columnDate = "date";

  DatabaseHelper._privateConstructor();

  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  static Database _database;

  Future<Database> get database async {
    if (_database != null) return _database;
    _database = await _initDatabase();
    return _database;
  }

  _initDatabase() async {
    String path = join(await getDatabasesPath(), _databaseName);
    return await openDatabase(path,
        version: _databaseVersion, onCreate: _onCreate);
  }

  Future _onCreate(Database db, int version) async {
    await db.execute('''
    CREATE TABLE $tableName (
    $columnId INTEGER PRIMARY KEY AUTOINCREMENT,
    $columnTitle TEXT NOT NULL,
    $columnAmount INTEGER NOT NULL,
    $columnDate DATETIME NOT NULL,
    )''');
  }

  Future<int> insert(Transaction transaction) async {
    Database db = await instance.database;
    return await db.insert(table, {'title': transaction.title, 'Amount': transaction.amount,'Date':transaction.date});
  }

  Future<List<Map<String, dynamic>>> queryAllRows() async {
    Database db = await instance.database;
    return await db.query(table);
  }

  Future<List<Map<String, dynamic>>> queryRows(name) async {
    Database db = await instance.database;
    return await db.query(table, where: "$columnTitle LIKE '%$title%'");
  }

  Future<int> queryRowCount() async {
    Database db = await instance.database;
    return Sqflite.firstIntValue(await db.rawQuery('SELECT COUNT(*) FROM $table'));
  }

  Future<int> update(Transaction transaction) async {
    Database db = await instance.database;
    int id = transaction.toMap()['id'];
    return await db.update(table, transaction.toMap(), where: '$columnId = ?', whereArgs: [id]);
  }
  
  Future<int> delete(int id) async {
    Database db = await instance.database;
    return await db.delete(table, where: '$columnId = ?', whereArgs: [id]);
  }
}
