import 'package:flutter/widgets.dart';
import 'package:geolocator/geolocator.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mysalon/services/auth/getUser.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

storeUser(bool isUser) async {
  var c = await getCurrentUser() as User;

  bool ret = false;

  var currentLocation = await Geolocator.getCurrentPosition();

  var data = {
    "displayName": c.displayName,
    "mail": c.email,
    "profile": c.photoURL,
    "role": isUser ? "user" : "salon",
    "isUser": isUser,
    "isSalon": !isUser,
    "isAdmin": false,
    "joinDate": Timestamp.now(),
    "isEnable": true,
    "location": {
      "lat": currentLocation.latitude,
      "long": currentLocation.longitude
    },
    "uid": c.uid
  };

  await FirebaseFirestore.instance
      .collection("users")
      .doc(c!.uid)
      .set(data)
      .then((value) {
    Fluttertoast.showToast(msg: "Welcome : " + c.displayName.toString());

    ret = true;
  }).onError((error, stackTrace) {
    Fluttertoast.showToast(msg: "Error to Save User");
    ret = false;
  });

  return ret;
}
