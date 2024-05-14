import 'package:flutter/widgets.dart';
import 'package:geolocator/geolocator.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mysalon/services/auth/getUser.dart';
import 'package:mysalon/elements/locationmodel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mysalon/services/getData/getUserById.dart';
import 'package:mysalon/services/location/calculateDIstance.dart';
import 'package:mysalon/services/location/getlatloglocation.dart';

Future<List<Map<String, dynamic>>?> getSameCitySalon() async {
  DateTime now = DateTime.now();

  // Get the start of today
  DateTime startOfDay = DateTime(now.year, now.month, now.day);

  // Get the end of today (start of next day)
  DateTime endOfDay = DateTime(now.year, now.month, now.day + 1);

  var user = await getCurrentUser();

  var mycity = await getAddressFromLocation();

  var myloc = await getlatlongLocation();

  print("My Current City");
  print(mycity.administrativeArea);

  var snapshot = await FirebaseFirestore.instance.collection("salons").get();

  List<Map<String, dynamic>> salonData = [];

  for (int i = 0; i < snapshot.docs.length; i++) {
    var salonloc = snapshot.docs[i].data();

    var dalcp = await FirebaseFirestore.instance
        .collection("salons")
        .doc(snapshot.docs[i].id)
        .collection("Ads")
        .where("isApproved", isEqualTo: true)
        .where("startDate",
            isGreaterThanOrEqualTo: Timestamp.fromDate(startOfDay))
        .where("startDate", isLessThanOrEqualTo: Timestamp.fromDate(endOfDay))
        .get();

    var salonCity =
        await getAddressFromLocationwithlatlang(salonloc["location"]);

    var salonLocation = salonloc["location"];

    Location loc1 = new Location(myloc["lat"], myloc["long"]);

    Location loc2 = new Location(salonLocation["lat"], salonLocation["long"]);

    var distance = calculateDistance(loc1, loc2).round();

    if (mycity.administrativeArea == salonCity.administrativeArea) {
      Map<String, dynamic> salonloc = {
        ...snapshot.docs[i].data(),
        'id': snapshot.docs[i].id,
        "distance": distance,
        "isAds": dalcp.docs.isEmpty ? false : true,
      };
      if (dalcp.docs.isNotEmpty) {
        // If it's an ad, add it at the beginning of the list
        salonData.insert(0, salonloc);
      } else {
        // If it's not an ad, add it at the end of the list
        salonData.add(salonloc);
      }
    }
  }

  return salonData;
}
