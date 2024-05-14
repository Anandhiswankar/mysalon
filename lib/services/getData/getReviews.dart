import 'package:flutter/widgets.dart';
import 'package:geolocator/geolocator.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mysalon/services/auth/getUser.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

Future<List<QueryDocumentSnapshot<dynamic>>?> getSalonReviewsById(
    String userId) async {
  try {
    var snapshot = await FirebaseFirestore.instance
        .collection("salons")
        .doc(userId)
        .collection("Review")
        .get();

    if (snapshot.docs.isNotEmpty) {
      return snapshot.docs;
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

Future<List?> getSalonReviewsByUserId(String userId) async {
  List<dynamic> loaderData = [];

  dynamic snap = [];

  try {
    snap = await FirebaseFirestore.instance
        .collection("users")
        .where("isSalon", isEqualTo: true)
        .get();

    for (int i = 0; i < snap.docs.length; i++) {
      var snapshot = await FirebaseFirestore.instance
          .collection("salons")
          .doc(snap.docs[i].id)
          .collection("Review")
          .where("uid", isEqualTo: userId)
          .get();

      for (int j = 0; j < snapshot.docs.length; j++) {
        loaderData.add(snapshot.docs[j].data());
      }
    }

    return loaderData;
  } catch (error) {
    // Handle errors, you can print or log the error here
    print("Error fetching user by id: $error");
    return null;
  }
}
