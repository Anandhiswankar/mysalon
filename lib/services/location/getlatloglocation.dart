import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

// Future<Map<String, dynamic>> getlatlongLocation() async {
//   var loc = await Geolocator.getCurrentPosition();
//   return {"lat": loc.latitude, "long": loc.longitude};
// }

Position? _currentPosition;
Placemark? _currentPlacemark;

Future<Map<String, double>> getlatlongLocation() async {
  _currentPosition ??= await Geolocator.getCurrentPosition();
  return {
    "lat": _currentPosition!.latitude,
    "long": _currentPosition!.longitude
  };
}

// Future<Placemark> getAddressFromLocation() async {
//   var loc = await getlatlongLocation();

//   List<Placemark> placemarks =
//       await placemarkFromCoordinates(loc["lat"], loc["long"]);
//   Placemark place = placemarks[0];

//   return place;
// }

Future<Placemark> getAddressFromLocation() async {
  print("log 1");

  if (_currentPlacemark != null) {
    return _currentPlacemark!;
  }

  var loc = await getlatlongLocation();

  print("log 2");

  List<Placemark> placemarks =
      await placemarkFromCoordinates(loc["lat"]!, loc["long"]!);

  print("log 3");
  _currentPlacemark = placemarks[0];

  return _currentPlacemark!;
}

Future<Placemark> getAddressFromLocationWithLatLong(
    Map<String, dynamic> loc) async {
  List<Placemark> placemarks =
      await placemarkFromCoordinates(loc["lat"]!, loc["long"]!);
  return placemarks[0];
}

// Future<Placemark> getAddressFromLocationwithlatlang(
//     Map<String, dynamic> loc) async {
//   List<Placemark> placemarks =
//       await placemarkFromCoordinates(loc["lat"], loc["long"]);
//   Placemark place = placemarks[0];

//   return place;
// }
