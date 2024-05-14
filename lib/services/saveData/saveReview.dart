import 'package:flutter/widgets.dart';
import 'package:geolocator/geolocator.dart';
import 'package:mysalon/elements/alertbox.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mysalon/elements/warningbox.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mysalon/services/auth/getUser.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

addSalonReview(
  BuildContext context,
  String salonId,
  String bookingId,
  double reviewNumber,
  String msg,
) async {
  var user = await getCurrentUser();

  var data = {
    "bookingId": bookingId,
    "isEnable": true,
    "msg": msg,
    "rating": reviewNumber,
    "salonid": salonId,
    "timestamp": Timestamp.now(),
    "uid": user!.uid
  };

  FirebaseFirestore.instance
      .collection("salons")
      .doc(salonId)
      .collection("Review")
      .add(data)
      .then((value) {
    warningBox(context, "Posted");
  }).catchError((onError) {
    print("Error to add post: " + onError);
    warningBox(context, "Error to post Ads: " + onError.toString());
  });
}
