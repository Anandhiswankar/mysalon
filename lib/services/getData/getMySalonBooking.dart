import 'package:intl/intl.dart';
import 'package:flutter/widgets.dart';
import 'package:geolocator/geolocator.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mysalon/services/auth/getUser.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

Future<List?> getMySalonBooking(String fiilter) async {
  try {
    var salonId = FirebaseAuth.instance.currentUser!.uid;

    DateFormat dateFormat = DateFormat("dd-M-yyyy");

    // Format the DateTime object into a string
    String datetime = dateFormat.format(DateTime.now());

    if (fiilter == "tom") {
      datetime = dateFormat.format(DateTime.now().add(const Duration(days: 1)));
    }

    print("Date Time loader");

    print(datetime);

    List<Map<String, dynamic>> mainData = [];

    // Fetch my bookings

    // Check if there are any bookings

    // Iterate through each booking

    // Fetch booked appointments for each salon
    QuerySnapshot appointmentsSnapshot = await FirebaseFirestore.instance
        .collection("salons")
        .doc(salonId)
        .collection("bookedAppointments")
        .where("selectedDate", isEqualTo: datetime)
        .orderBy("timestamp", descending: true)
        .get();

    // Process appointmentsSnapshot and add data to mainData
    appointmentsSnapshot.docs.forEach((appointmentDoc) {
      mainData
          .add({...?appointmentDoc.data() as dynamic, "id": appointmentDoc.id});
    });

    // Return mainData after processing all bookings
    return mainData;
  } catch (error) {
    // Handle errors, you can print or log the error here
    print("Error fetching user by id: $error");
    return null;
  }
}
