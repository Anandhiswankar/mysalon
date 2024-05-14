import 'package:flutter/widgets.dart';
import 'package:geolocator/geolocator.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mysalon/services/auth/getUser.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

Future<List<dynamic>?> GetAllAdsRequest({bool isPending = false}) async {
  try {
    List<dynamic> salonList = [];
    dynamic snap = [];

    DateTime now = DateTime.now();

    // Get the start of today
    DateTime startOfDay = DateTime(now.year, now.month, now.day);

    // Get the end of today (start of next day)
    DateTime endOfDay = DateTime(now.year, now.month, now.day + 1);

    var snapshot = await FirebaseFirestore.instance
        .collection("users")
        .where("isSalon", isEqualTo: true)
        .get();

    for (int i = 0; i < snapshot!.docs.length; i++) {
      if (isPending) {
        snap = await FirebaseFirestore.instance
            .collection("salons")
            .doc(snapshot.docs[i].id)
            .collection("Ads")
            .where("isApproved", isEqualTo: false)
            .get();
      } else {
        snap = await FirebaseFirestore.instance
            .collection("salons")
            .doc(snapshot.docs[i].id)
            .collection("Ads")
            .where("isApproved", isEqualTo: true)
            .get();
      }

      print("Selcection review");
      print(snap.docs.length);

      for (int j = 0; j < snap.docs.length; j++) {
        if (snap.docs.isNotEmpty) {
          salonList
              .add({...snap.docs[j].data() as dynamic, "id": snap.docs[j].id});
        }
      }
    }

    // print("")
    return salonList;
  } catch (error) {
    // Handle errors, you can print or log the error here
    print("Error fetching user by id: $error");
    return [];
  }
}

Future<List<dynamic>?> GetAllAdsRequestCount() async {
  try {
    List<dynamic> salonList = [];

    DateTime now = DateTime.now();

    // Get the start of today
    DateTime startOfDay = DateTime(now.year, now.month, now.day);

    // Get the end of today (start of next day)
    DateTime endOfDay = DateTime(now.year, now.month, now.day + 1);

    var snapshot = await FirebaseFirestore.instance
        .collection("users")
        .where("isSalon", isEqualTo: true)
        .get();

    for (int i = 0; i < snapshot!.docs.length; i++) {
      var snap = await FirebaseFirestore.instance
          .collection("salons")
          .doc(snapshot.docs[i].id)
          .collection("Ads")
          .where("timestamp",
              isGreaterThanOrEqualTo: Timestamp.fromDate(startOfDay))
          .where("timestamp", isLessThan: Timestamp.fromDate(endOfDay))
          .get();

      print("Selcection review");
      print(snap.docs.length);

      for (int j = 0; j < snap.docs.length; j++) {
        if (snap.docs.isNotEmpty) {
          salonList.add(snap.docs[j].data());
        }
      }
    }

    // print("")
    return salonList;
  } catch (error) {
    // Handle errors, you can print or log the error here
    print("Error fetching user by id: $error");
    return [];
  }
}
