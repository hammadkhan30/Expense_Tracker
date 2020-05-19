import 'package:intl/intl.dart';

class Val {
  static String Validate(String val) {
    return (val != null && val != "") ? null : "Title can't be blank";
  }
}

class DateUtils {
  static DateTime convertToDate(String input) {
    try {
      var d = new DateFormat("yyyy-MM-dd").parseStrict(input);
      return d;
    } catch (e) {
      return null;
    }
  }
  static String TrimDate(String dt) {
    if (dt.contains(" ")) {
      List<String> p = dt.split(" ");
      return p[0];
    }
    else
      return dt;
  }
}