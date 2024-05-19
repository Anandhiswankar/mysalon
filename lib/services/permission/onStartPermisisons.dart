import 'package:permission_handler/permission_handler.dart';

onStartPermission() async {
  bool isAllTrue = false;
  var locationPermission = await Permission.locationWhenInUse.isGranted;

  if (locationPermission) {
    isAllTrue = true;
  } else {
    isAllTrue = false;
  }

  var permissionRequest = await Permission.locationWhenInUse.request();

  if (permissionRequest.isGranted) {
    isAllTrue = true;
  } else {
    isAllTrue = false;
  }

  return isAllTrue;
}
