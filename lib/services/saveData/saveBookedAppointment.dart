import 'package:flutter/widgets.dart';
import 'package:geolocator/geolocator.dart';
import 'package:mysalon/elements/alertbox.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mysalon/elements/warningbox.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mysalon/services/auth/getUser.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mysalon/services/saveData/saveNotification.dart';

saveMyBookedAppointment(BuildContext context, dynamic data) async {
  FirebaseFirestore.instance
      .collection("salons")
      .doc(data["salonId"])
      .collection("bookedAppointments")
      .add(data)
      .then((value) {
    // warningBox(context, "Appointment Booked");

    FirebaseFirestore.instance
        .collection("users")
        .doc(data["userId"])
        .collection("mybooking")
        .doc(data["salonId"])
        .set({
      "salonId": data["salonId"],
      "timestamp": Timestamp.now(),
    });

    var datas = {
      "salonId": data["salonId"],
      "userId": data["userId"],
      "paymentId": data["paymentID"] ?? "",
      "timestamp": Timestamp.now(),
      "payment": data["bookingCost"],
      "bookingId": value.id,
      "bookingCost": data["bookingCost"],
    };

    FirebaseFirestore.instance.collection("recipts").add(datas).then((value) {
      print("Recipt Added");

      //j

      saveNotification(
          context, data["salonId"], "Appointment Booked", "Booking");
      saveNotificationAdmin(
          context, "Appointment Booked Payment Recived", "Booking");

      //hh
    }).catchError((onError) {
      print("Error to store recipt");
    });
  }).catchError((onError) {
    print("Error to add post: " + onError);
    warningBox(context, "Error to post Ads: " + onError.toString());
  });
}
