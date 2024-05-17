import 'dart:math';
import 'package:mysalon/elements/locationmodel.dart';

double calculateDistance(Location location1, Location location2) {
  const double earthRadius = 6371; // Radius of the earth in kilometers

  // Convert latitude and longitude from degrees to radians
  double lat1Radians = degreesToRadians(location1.latitude);
  double lon1Radians = degreesToRadians(location1.longitude);
  double lat2Radians = degreesToRadians(location2.latitude);
  double lon2Radians = degreesToRadians(location2.longitude);

  // Haversine formula
  double dLat = lat2Radians - lat1Radians;
  double dLon = lon2Radians - lon1Radians;
  double a = pow(sin(dLat / 2), 2) +
      cos(lat1Radians) * cos(lat2Radians) * pow(sin(dLon / 2), 2);
  double c = 2 * atan2(sqrt(a), sqrt(1 - a));
  double distance = earthRadius * c;

  return distance; // Distance in kilometers
}

double degreesToRadians(double degrees) {
  return degrees * pi / 180;
}
