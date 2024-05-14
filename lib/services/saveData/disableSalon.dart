import 'package:flutter/widgets.dart';
import 'package:geolocator/geolocator.dart';
import 'package:mysalon/elements/alertbox.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mysalon/elements/warningbox.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mysalon/services/auth/getUser.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

disableSalonStatus(BuildContext context, String salonId, bool status) async {
  var user = await getCurrentUser();

  var data = {
    "isEnable": status,
  };

  await FirebaseFirestore.instance
      .collection("users")
      .doc(user!.uid)
      .set(data, SetOptions(merge: true))
      .then((value) {
    print("Disabled");
    warningBox(context, "Disabled");
  }).catchError((onError) {
    print(onError);
    warningBox(context, "Error to Mark Status");
  });
}
