import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:async';
import 'dart:io';
import '../models/transaction.dart';

class DbHelper {
  static String tblDoccs = "docs";
  String docId = "id";
  String docTitle = "title";
  String docAmount = "amount";
  String docDate = "date";
  String fqYear = "fqYear";
  String fqMonth = "fqMonth";

  static final DbHelper _dbHelper = DbHelper._internal();

  DbHelper._internal();

  factory DbHelper() {
    return _dbHelper;
  }

  static Database _db;

  Future<Database> get db async {
    if (_db == null) {
      _db = await initializeDb();
    }

    return _db;
  }

  // Initialize the database
  Future<Database> initializeDb() async {
    Directory d = await getApplicationDocumentsDirectory();
    String p = d.path + "/docexp.db";
    var db = await openDatabase(p, version: 1, onCreate: _createDb);
    return db;
  }

  void _createDb(Database db, int version) async {
    await db.execute(
        "CREATE TABLE $tblDoccs($docId INTEGER PRIMARY KEY, $docTitle TEXT, " +
            "$docAmount INTEGER," +
            "$docDate TEXT, " +
            "$fqYear INTEGER," +
            "$fqMonth INTEGER)");
  }

  Future<int> insertDoc(Transactions doc) async {
    var r;

    Database db = await this.db;
    try {
      r = await db.insert(tblDoccs, doc.toMap());
    } catch (e) {
      debugPrint("insertDoc: " + e.toString());
    }
    return r;
  }

  Future<List> getDocs() async {
    Database db = await this.db;
    var r =
        await db.rawQuery("SELECT * FROM $tblDoccs ORDER BY $docId ASC");
    return r;
  }

  Future<List> getDoc(int id) async {
    Database db = await this.db;
    var r = await db.rawQuery(
        "SELECT * FROM $tblDoccs WHERE $docId = " + id.toString() + "");
    return r;
  }

  // Gets a Doc based on a String payload
  Future<List> getDocFromStr(String payload) async {
    List<String> p = payload.split("|");
    if (p.length == 2) {
      Database db = await this.db;
      var r = await db.rawQuery("SELECT * FROM $tblDoccs WHERE $docId = " +
          p[0] +
          " AND $docDate = '" +
          p[1] +
          "'");
      return r;
    } else
      return null;
  }

  Future<int> getDocsCount() async {
    Database db = await this.db;
    var r = Sqflite.firstIntValue(
        await db.rawQuery("SELECT COUNT(*) FROM $tblDoccs"));
    return r;
  }

  Future<int> getMaxId() async {
    Database db = await this.db;
    var r = Sqflite.firstIntValue(
        await db.rawQuery("SELECT MAX(id) FROM $tblDoccs"));
    return r;
  }

  Future<int> updateDoc(Transactions doc) async {
    var db = await this.db;
    var r = await db
        .update(tblDoccs, doc.toMap(), where: "$docId = ?", whereArgs: [doc.id]);
    return r;
  }

  // Delete a doc
  Future<int> deleteDoc(int id) async {
    var db = await this.db;
    int r = await db.rawDelete("DELETE FROM $tblDoccs WHERE $docId = $id");
    return r;
  }

  Future<int> deleteRows(String tbl) async {
    var db = await this.db;
    int r = await db.rawDelete("DELETE FROM $tbl");
    return r;
  }
}
