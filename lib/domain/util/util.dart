import 'package:intl/intl.dart';
import 'package:timeago/timeago.dart' as timeago;

class Util {
  static bool validateEmail(String value) {
    Pattern pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = new RegExp(pattern);
    return (!regex.hasMatch(value)) ? false : true;
  }

  static bool getStringLengthValidator(String s, int length) {
    if (s == null) return false;
    return s.length >= length ? true : false;
  }

  static String getLocalTimeAgoAndTime(int time) {
    return getLocalTimeAgo(time) +
        "\n" +
        DateFormat.yMEd()
            .add_jms()
            .format(new DateTime.fromMillisecondsSinceEpoch(time).toLocal());
  }

  static String getLocalTimeAgo(int time) {
    return timeago.format(DateTime.fromMillisecondsSinceEpoch(time).toLocal());
  }

  static String getLocalTime(int time) {
    return DateFormat.yMEd()
        .add_jms()
        .format(new DateTime.fromMillisecondsSinceEpoch(time).toLocal());
  }

  static DateTime getLocalDateTime(int time) {
    return new DateTime.fromMillisecondsSinceEpoch(time).toLocal();
  }
}
