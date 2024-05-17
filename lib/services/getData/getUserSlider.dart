import 'package:flutter/widgets.dart';
import 'package:geolocator/geolocator.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mysalon/services/auth/getUser.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

Future<List<dynamic>?> getUserSlider() async {
  try {
    var snapshot = await FirebaseFirestore.instance
        .collection("settings")
        .doc("Slideshow")
        .get();

    if (snapshot.exists) {
      print("Slider data");
      print(snapshot.data()!["slider"]);
      return snapshot.data()!["slider"];
    } else {
      // Return null if document doesn't exist
      return null;
    }
  } catch (error) {
    // Handle errors, you can print or log the error here
    print("Error fetching Slider Image $error");
    return null;
  }
}

Future<List<dynamic>?> updateUserSlider(dynamic slidedata) async {
  try {
    Map<String, dynamic> data = {"slider": slidedata};
    var snapshot = await FirebaseFirestore.instance
        .collection("settings")
        .doc("Slideshow")
        .set(data);
  } catch (error) {
    // Handle errors, you can print or log the error here
    print("Error fetching Slider Image $error");
    return null;
  }
}
