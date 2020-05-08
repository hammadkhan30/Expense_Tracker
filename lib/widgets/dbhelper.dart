import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:async';
import 'dart:io';
import './models/transaction.dart';
class DbHelper {
  static String tblDocs = "docs";
  String docId = "id";
  String docTitle = "title";
  double docAmount = "amount";
  DateTime docDate = "date";

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

  Future<Database> initializeDb() async {
    Directory d = await getApplicationDocumentsDirectory();
    String p = d.path + "/docexpire.db";
    var db = await openDatabase(p, version: 1, onCreate: _createDb);
    return db;
  }

  void _createDb(Database db, int version) async {
    await db.execute(
        "CREATE TABLE $tblDocs($docId INTEGER PRIMARY KEY, $docTitle TEXT,
            + $docAmount INTEGER, )"
    );
  }

  Future<int> insertDoc(Doc doc) async {
    var r;
    Database db = await this.db;
    try {
      r = await db.insert(tblDocs, doc.toMap());
    }
    catch (e) {
      debugPrint("insertDoc: " + e.toString());
    }
    return r;
  }
