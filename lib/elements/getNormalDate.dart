import 'package:intl/intl.dart';

String convertToHourFormat(String time24Hour) {
  final DateFormat dateFormat = DateFormat('H:m');
  final DateTime dateTime = dateFormat.parse(time24Hour);

  final String formattedTime = DateFormat('h:mm a').format(dateTime);

  return formattedTime;
}
