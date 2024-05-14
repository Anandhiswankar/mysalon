import 'package:flutter/widgets.dart';
import 'package:geolocator/geolocator.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mysalon/services/auth/getUser.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

Future<List?> getMyBooking() async {
  try {
    var userId = FirebaseAuth.instance.currentUser!.uid;

    List<Map<String, dynamic>> mainData = [];

    // Fetch my bookings
    QuerySnapshot salonsSnapshot = await FirebaseFirestore.instance
        .collection("users")
        .doc(userId)
        .collection("mybooking")
        .orderBy("timestamp", descending: true)
        .get();

    // Check if there are any bookings
    if (salonsSnapshot.docs.isNotEmpty) {
      // Iterate through each booking
      for (QueryDocumentSnapshot salonDoc in salonsSnapshot.docs) {
        String salonId = salonDoc.id;

        // Fetch booked appointments for each salon
        QuerySnapshot appointmentsSnapshot = await FirebaseFirestore.instance
            .collection("salons")
            .doc(salonId)
            .collection("bookedAppointments")
            .where("userId", isEqualTo: userId)
            .get();

        // Process appointmentsSnapshot and add data to mainData
        appointmentsSnapshot.docs.forEach((appointmentDoc) {
          mainData.add(
              {...?appointmentDoc.data() as dynamic, "id": appointmentDoc.id});
        });
      }

      // Return mainData after processing all bookings
      return mainData;
    } else {
      // Return null if there are no bookings
      return null;
    }
  } catch (error) {
    // Handle errors, you can print or log the error here
    print("Error fetching user by id: $error");
    return null;
  }
}

Future<List?> getMyBookingById(String uid) async {
  try {
    var userId = uid;

    List<Map<String, dynamic>> mainData = [];

    // Fetch my bookings
    QuerySnapshot salonsSnapshot = await FirebaseFirestore.instance
        .collection("users")
        .doc(userId)
        .collection("mybooking")
        .orderBy("timestamp", descending: true)
        .get();

    // Check if there are any bookings
    if (salonsSnapshot.docs.isNotEmpty) {
      // Iterate through each booking
      for (QueryDocumentSnapshot salonDoc in salonsSnapshot.docs) {
        String salonId = salonDoc.id;

        // Fetch booked appointments for each salon
        QuerySnapshot appointmentsSnapshot = await FirebaseFirestore.instance
            .collection("salons")
            .doc(salonId)
            .collection("bookedAppointments")
            .where("userId", isEqualTo: userId)
            .get();

        // Process appointmentsSnapshot and add data to mainData
        appointmentsSnapshot.docs.forEach((appointmentDoc) {
          mainData.add(
              {...?appointmentDoc.data() as dynamic, "id": appointmentDoc.id});
        });
      }

      // Return mainData after processing all bookings
      return mainData;
    } else {
      // Return null if there are no bookings
      return null;
    }
  } catch (error) {
    // Handle errors, you can print or log the error here
    print("Error fetching user by id: $error");
    return null;
  }
}
