import 'package:flutter/widgets.dart';
import 'package:geolocator/geolocator.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mysalon/services/auth/getUser.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

Future<dynamic> getUserById(String userId) async {
  try {
    var snapshot =
        await FirebaseFirestore.instance.collection("users").doc(userId).get();

    if (snapshot.exists) {
      return snapshot.data();
    } else {
      // Return null if document doesn't exist
      return null;
    }
  } catch (error) {
    // Handle errors, you can print or log the error here
    print("Error fetching user by id: $error");
    return null;
  }
}
