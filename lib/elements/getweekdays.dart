import 'package:intl/intl.dart';

String getWeekDays() {
  DateFormat formatter = DateFormat('EEEE');
  DateTime now = DateTime.now();

  return formatter.format(now);
}

String getWeekDaysbydate(DateTime date) {
  DateFormat formatter = DateFormat('EEEE');
  DateTime now = date;

  return formatter.format(now);
}
