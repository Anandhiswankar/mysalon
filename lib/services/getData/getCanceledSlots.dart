import 'package:flutter/widgets.dart';
import 'package:geolocator/geolocator.dart';
import 'package:mysalon/elements/alertbox.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mysalon/elements/warningbox.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mysalon/services/auth/getUser.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

getCanceledSlots(
  BuildContext context,
  DateTime SelectedDate,
) async {
  var user = await getCurrentUser();

  alertBox(context);

  var data = await FirebaseFirestore.instance
      .collection("salons")
      .doc(user!.uid)
      .collection("bookingSlotStatus")
      .doc(SelectedDate.toString().split(" ").first)
      .get();

  Navigator.of(context).pop();

  if (data.exists) {
    return data.data();
  }
}

getCanceledSlotsById(
    BuildContext context, DateTime SelectedDate, String uid) async {
  alertBox(context);

  var data = await FirebaseFirestore.instance
      .collection("salons")
      .doc(uid)
      .collection("bookingSlotStatus")
      .doc(SelectedDate.toString().split(" ").first)
      .get();

  Navigator.of(context).pop();

  if (data.exists) {
    return data.data();
  }
}
