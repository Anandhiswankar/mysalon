import 'dart:math';
import 'package:mysalon/elements/locationmodel.dart';

const double earthRadius = 6371; // Radius of the earth in kilometers

double calculateDistance(Location location1, Location location2) {
  // Convert latitude and longitude from degrees to radians
  double lat1Radians = degreesToRadians(location1.latitude);
  double lon1Radians = degreesToRadians(location1.longitude);
  double lat2Radians = degreesToRadians(location2.latitude);
  double lon2Radians = degreesToRadians(location2.longitude);

  // Haversine formula
  double dLat = lat2Radians - lat1Radians;
  double dLon = lon2Radians - lon1Radians;
  double sinDLat = sin(dLat / 2);
  double sinDLon = sin(dLon / 2);
  double a = sinDLat * sinDLat +
      cos(lat1Radians) * cos(lat2Radians) * sinDLon * sinDLon;
  double c = 2 * atan2(sqrt(a), sqrt(1 - a));

  return earthRadius * c;
}

double degreesToRadians(double degrees) {
  return degrees * pi / 180;
}
