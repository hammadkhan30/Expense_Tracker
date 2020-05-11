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
}
