import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

Future<Map<String, dynamic>> getlatlongLocation() async {
  var loc = await Geolocator.getCurrentPosition();
  return {"lat": loc.latitude, "long": loc.longitude};
}

Future<Placemark> getAddressFromLocation() async {
  var loc = await getlatlongLocation();

  List<Placemark> placemarks =
      await placemarkFromCoordinates(loc["lat"], loc["long"]);
  Placemark place = placemarks[0];

  return place;
}

Future<Placemark> getAddressFromLocationwithlatlang(
    Map<String, dynamic> loc) async {
  List<Placemark> placemarks =
      await placemarkFromCoordinates(loc["lat"], loc["long"]);
  Placemark place = placemarks[0];

  return place;
}
