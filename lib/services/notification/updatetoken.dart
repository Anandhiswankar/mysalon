import 'package:flutter/widgets.dart';
import 'package:mysalon/elements/warningbox.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mysalon/services/auth/getUser.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';

updatetoken(BuildContext context) async {
  var user = await getCurrentUser();
  var message = await FirebaseMessaging.instance;

  message.requestPermission(alert: true);

  var token = await message.getToken();

  print("Notification Token");

  print(token);

  FirebaseFirestore.instance
      .collection("users")
      .doc(user!.uid)
      .get()
      .then((value) {
    if (value.data()!.containsKey("token")) {
      FirebaseFirestore.instance
          .collection("users")
          .doc(user.uid)
          .update({"token": token}).then((value) {
        print("Updated Token");
      }).catchError((onError) {
        warningBox(context, "Server Error 0xToken");
        print("Error to Update token");
      });
    } else {
      FirebaseFirestore.instance
          .collection("users")
          .doc(user.uid)
          .set({"token": token}, SetOptions(merge: true)).then((value) {
        print("Token Added");
      }).catchError((onError) {
        warningBox(context, "Server Error 0xToken");
        print("Error to Set token");
      });
    }
  }).catchError((onError) {
    warningBox(context, "Server Error 0xToken");
    print("Error to get user data: " + onError.toString());
  });
}
