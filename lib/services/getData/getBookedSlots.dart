import 'package:flutter/widgets.dart';
import 'package:geolocator/geolocator.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mysalon/services/auth/getUser.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

Future<List<QueryDocumentSnapshot<dynamic>>?> getSalonBookedSlots(
    String userId) async {
  try {
    var snapshot = await FirebaseFirestore.instance
        .collection("salons")
        .doc(userId)
        .collection("bookedAppointments")
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

Future<List<QueryDocumentSnapshot<dynamic>>?> getSalonBookedSlotByTimeDate(
    String userId, String time, DateTime timestamps) async {
  try {
    var snapshot = await FirebaseFirestore.instance
        .collection("salons")
        .doc(userId)
        .collection("bookedAppointments")
        .where("bookedSlot", isEqualTo: time)
        .where("selectedDate",
            isEqualTo: timestamps.day.toString() +
                "-" +
                timestamps.month.toString() +
                "-" +
                timestamps.year.toString())
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
