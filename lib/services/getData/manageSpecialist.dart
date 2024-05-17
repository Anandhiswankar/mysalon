import 'dart:io';
import 'package:flutter/widgets.dart';
import 'package:geolocator/geolocator.dart';
import 'package:mysalon/elements/alertbox.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mysalon/elements/warningbox.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mysalon/services/auth/getUser.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mysalon/services/upload/uploadImage.dart';

getSpecialist() async {
  try {
    var user = await getCurrentUser();

    var snapshot = await FirebaseFirestore.instance
        .collection("salons")
        .doc(user!.uid)
        .collection("specialists")
        .doc("Allspecialists")
        .get();

    if (snapshot.exists) {
      return snapshot.data();
    } else {
      // Return null if document doesn't exist
      return null;
    }
  } catch (error) {
    // Handle errors, you can print or log the error here
    print("Error fetching Specialist: $error");
    return null;
  }
}

Future<bool> addSpecialist(
    BuildContext context, String name, String info, File profile) async {
  alertBox(context);

  var user = await getCurrentUser();

  var image = await uploadToFirebase(profile, user!.uid);
  print("Specialist profiel image url");
  print(image);

  var data = [];

  await FirebaseFirestore.instance
      .collection("salons")
      .doc(user.uid)
      .collection("specialists")
      .doc("Allspecialists")
      .get()
      .then((value) {
    var db = value.data() as dynamic;

    data = db["specialist"] as List<dynamic>;

    print("data from server");

    data.add({
      "name": name,
      "info": info,
      "profile": image,
      "timestamp": Timestamp.now()
    });

    print("Specialist object");

    print(data);

    var added = FirebaseFirestore.instance
        .collection("salons")
        .doc(user.uid)
        .collection("specialists")
        .doc("Allspecialists")
        .update({"specialist": data}).then((value) {
      print("Added Specialist");
      Navigator.of(context).pop();
      return true;
    }).catchError((onError) {
      warningBox(context, "Error to Add Specialist");
      Navigator.of(context).pop();
      print("Error to Add specialist : " + onError.toString());
      return false;
    });

    print(data);
  }).catchError((err) {
    Navigator.of(context).pop();
    print("Error to get Specialist data");
  });

  return false;
}

Future<bool> DeleteSpecialist(BuildContext context, int index) async {
  alertBox(context);

  var user = await getCurrentUser();

  var data = [];

  await FirebaseFirestore.instance
      .collection("salons")
      .doc(user!.uid)
      .collection("specialists")
      .doc("Allspecialists")
      .get()
      .then((value) {
    var db = value.data() as dynamic;

    data = db["specialist"] as List<dynamic>;

    print(data);

    print("After delete");

    data.removeAt(index);

    print(data);

    var added = FirebaseFirestore.instance
        .collection("salons")
        .doc(user.uid)
        .collection("specialists")
        .doc("Allspecialists")
        .update({"specialist": data}).then((value) {
      print(" Specialist Deleted");
      Navigator.of(context).pop();
      return true;
    }).catchError((onError) {
      warningBox(context, "Error to Add Specialist");
      Navigator.of(context).pop();
      print("Error to Add specialist : " + onError.toString());
      return false;
    });

    print(data);
  }).catchError((err) {
    Navigator.of(context).pop();
    print("Error to get Specialist data");
  });

  return false;
}

Future<bool> EditSpecialist(
    BuildContext context, int index, Map<String, Object?> editedData) async {
  alertBox(context);

  var user = await getCurrentUser();

  if (!editedData["profile"].toString().contains("https://")) {
    print("Yes this is file man");

    editedData["profile"] =
        await uploadToFirebase(editedData["profile"] as File, user!.uid);
  } else {
    print("Yes object is a url");
  }

  var data = [];

  await FirebaseFirestore.instance
      .collection("salons")
      .doc(user!.uid)
      .collection("specialists")
      .doc("Allspecialists")
      .get()
      .then((value) {
    var db = value.data() as dynamic;

    data = db["specialist"] as List<dynamic>;

    print(data);

    print("After delete");

    data[index] = editedData;

    print(data);

    var added = FirebaseFirestore.instance
        .collection("salons")
        .doc(user.uid)
        .collection("specialists")
        .doc("Allspecialists")
        .update({"specialist": data}).then((value) {
      print(" Specialist Editied");
      Navigator.of(context).pop();
      return true;
    }).catchError((onError) {
      warningBox(context, "Error to Add Specialist");
      Navigator.of(context).pop();
      print("Error to Add specialist : " + onError.toString());
      return false;
    });

    print(data);
  }).catchError((err) {
    Navigator.of(context).pop();
    print("Error to get Specialist data");
  });

  return false;
}
