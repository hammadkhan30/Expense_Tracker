import '../controller/utils.dart';

class Transactions {
  int id;
  String title;
  int amount;
  String date;
  int fqYear;
  int fqMonth;

  Transactions(
    this.id,
    this.title,
    this.amount,
    this.date,
    this.fqYear,
    this.fqMonth,
  );

  Transactions.withId(
    this.id,
    this.title,
    this.amount,
    this.date,
    this.fqYear,
    this.fqMonth,
  );

  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();
    map["title"] = this.title;
    map["amount"] = this.amount;
    map["date"] = this.date;
    map["fqYear"] = this.fqYear;
    map["fqMonth"] = this.fqMonth;

    if (id != null) {
      map["id"] = id;
    }

    return map;
  }

  Transactions.fromObject(dynamic o) {
    this.id = o["id"];
    this.title = o["title"];
    this.amount = o["amount"];
    this.date = DateUtils.TrimDate(o["date"]);
    this.fqYear = o["fqYear"];
    this.fqMonth = o["fqMonth"];
  }
}
