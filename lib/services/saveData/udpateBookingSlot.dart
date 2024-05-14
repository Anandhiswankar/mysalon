import 'package:flutter/widgets.dart';
import 'package:geolocator/geolocator.dart';
import 'package:mysalon/elements/alertbox.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mysalon/elements/warningbox.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mysalon/services/auth/getUser.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

updateBookingSlotOnServer(BuildContext context, DateTime SelectedDate,
    List<dynamic> CanceledList) async {
  var user = await getCurrentUser();

  alertBox(context);

  FirebaseFirestore.instance
      .collection("salons")
      .doc(user!.uid)
      .collection("bookingSlotStatus")
      .doc(SelectedDate.toString().split(" ").first)
      .set({"canceledSlot": CanceledList}).then((value) {
    Navigator.of(context).pop();
    warningBox(context, "Updated");
  }).catchError((onError) {
    Navigator.of(context).pop();
    print("Error to update slot" + onError.toString());
    warningBox(context, "Error to update slots : " + onError.toString());
  });
}
