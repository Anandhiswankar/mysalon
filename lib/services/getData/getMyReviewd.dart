import 'package:flutter/widgets.dart';
import 'package:geolocator/geolocator.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mysalon/services/auth/getUser.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

Future<List<QueryDocumentSnapshot<dynamic>>?> getMyReviewForthisbooking(
    String salonId, String bookingId) async {
  try {
    var userId = FirebaseAuth.instance.currentUser!.uid;

    var snapshot = await FirebaseFirestore.instance
        .collection("salons")
        .doc(salonId)
        .collection("Review")
        .where("bookingId", isEqualTo: bookingId)
        .where("salonid", isEqualTo: salonId)
        .where("uid", isEqualTo: userId)
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
