import 'package:flutter/widgets.dart';
import 'package:geolocator/geolocator.dart';
import 'package:mysalon/elements/alertbox.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mysalon/elements/warningbox.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mysalon/services/auth/getUser.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

disableUser(BuildContext context, String userId, bool status) {
  FirebaseFirestore.instance
      .collection("users")
      .doc(userId)
      .set({"isEnable": status}, SetOptions(merge: true)).then((value) {
    print("Updated");
    warningBox(context, "Updated");
  }).onError((error, stackTrace) {
    print("Error to save status");
  });
}
