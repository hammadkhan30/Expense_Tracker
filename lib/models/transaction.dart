import 'package:flutter/foundation.dart';
import '../controller/dbhelper.dart';

//TODO: check the use of ID
class Transaction {
  String id;
  String title;
  double amount;
  DateTime date;

  Transaction({
    this.id,
    this.title,
    this.amount,
    this.date,
  });

  Transaction.fromMap(Map<String, dynamic> map, this.id, this.title, this.amount, this.date) {
    id = map['id'];
    title = map['title'];
    amount = map['amount'];
    date = map['date'];
  }

  Map<String,dynamic> toMap(){
    return{
      DatabaseHelper.columnId:id,
      DatabaseHelper.columnTitle:title,
      DatabaseHelper.columnAmount:amount,
      DatabaseHelper.columnDate:date,
    };
  }

}
