import '../models/transaction.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

Database db;

class DatabaseCreator {
  static const transactionTable = "transaction";
  static const COLUMN_ID = "id";
  static const COLUMN_TITLE = "title";
  static const COLUMN_AMOUNT = "amount";
  static const COLUMN_DATE = "date";

  DatabaseCreator._();

  static final DatabaseCreator db = DatabaseCreator._();

  Database _database;

  Future<Database> get database async {
    print("Database getter called");

    if (_database != null) {
      return _database;
    }
    _database = await createDatabase();

    return _database;
  }

  Future<Database> createDatabase() async {
    String dbPath = await getDatabasesPath();

    return await openDatabase(
      join(dbPath, 'transactionDB.db'),
      version: 1,
      onCreate: (Database database, int version) async {
        print("Creating transaction table");

        await database.execute(
          "CREATE TABLE $transactionTable ("
          "$COLUMN_ID INTEGER PRIMARY KEY,"
          "$COLUMN_TITLE TEXT,"
          "$COLUMN_AMOUNT INTEGER,"
          "$COLUMN_DATE DateTime"
          ")",
        );
      },
    );
  }
  Future<Transactions> insert(Transactions transaction) async {
    final db = await database;
    transaction.id = (await db.insert(transactionTable, transaction.toMap())) as String;
    return transaction;
  }

  Future<int> delete(int id) async {
    final db = await database;

    return await db.delete(
      transactionTable,
      where: "id = ?",
      whereArgs: [id],
    );
  }
}
