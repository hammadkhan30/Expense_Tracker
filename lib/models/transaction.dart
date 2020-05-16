import '../controller/dbhelper.dart';
//TODO: check the use of ID
class Transactions {
  String id;
  String title;
  double amount;
  DateTime date;

  Transactions({
    this.id,
    this.title,
    this.amount,
    this.date,
  });

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      DatabaseCreator.COLUMN_TITLE: title,
      DatabaseCreator.COLUMN_AMOUNT: amount,
      DatabaseCreator.COLUMN_DATE: date,
    };

    if (id != null) {
      map[DatabaseCreator.COLUMN_ID] = id;
    }

    return map;
  }

  Transactions.fromMap(Map<String, dynamic> map) {
    id = map[DatabaseCreator.COLUMN_ID];
    title = map[DatabaseCreator.COLUMN_TITLE];
    amount = map[DatabaseCreator.COLUMN_AMOUNT];
    date = map[DatabaseCreator.COLUMN_DATE];
  }


}
