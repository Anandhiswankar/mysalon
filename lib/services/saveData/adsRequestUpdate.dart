import 'package:flutter/widgets.dart';
import 'package:geolocator/geolocator.dart';
import 'package:mysalon/elements/alertbox.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mysalon/elements/warningbox.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mysalon/services/auth/getUser.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

approveAdsRequestAllow(
    BuildContext context, String adsId, String SalonID) async {
  var data = {
    "isApproved": true,
    "isRejected": false,
    "msg": "Approved by admin"
  };
  FirebaseFirestore.instance
      .collection("salons")
      .doc(SalonID)
      .collection("Ads")
      .doc(adsId)
      .set(data, SetOptions(merge: true))
      .then((value) {
    warningBox(context, "Posted");
  }).catchError((onError) {
    print("Error to add post: " + onError);
    warningBox(context, "Error to post Ads: " + onError.toString());
  });
}

approveAdsRequestReject(
    BuildContext context, String adsId, String SalonID) async {
  var data = {
    "isApproved": false,
    "isRejected": true,
    "msg": "rejected by admin"
  };
  FirebaseFirestore.instance
      .collection("salons")
      .doc(SalonID)
      .collection("Ads")
      .doc(adsId)
      .set(data, SetOptions(merge: true))
      .then((value) {
    warningBox(context, "Posted");
  }).catchError((onError) {
    print("Error to add post: " + onError);
    warningBox(context, "Error to post Ads: " + onError.toString());
  });
}
