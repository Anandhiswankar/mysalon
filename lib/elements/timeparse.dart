import 'package:flutter/material.dart';

TimeOfDay parseTime(String timeString) {
  List<String> parts = timeString.split(":");
  int hour = int.parse(parts[0]);
  int minute = int.parse(parts[1]);
  return TimeOfDay(hour: hour, minute: minute);
}
