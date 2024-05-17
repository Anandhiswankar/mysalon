import 'package:permission_handler/permission_handler.dart';

onStartPermission() async {
  var locationPermission = await Permission.locationWhenInUse.isGranted;

  if (locationPermission) {
    return true;
  }

  var permissionRequest = await Permission.locationWhenInUse.request();

  if (permissionRequest.isGranted) {
    return true;
  }

  return false;
}
