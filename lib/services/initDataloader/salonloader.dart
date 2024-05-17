import 'dart:ffi';
import 'package:flutter/widgets.dart';
import 'package:mysalon/elements/warningbox.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mysalon/services/auth/getUser.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';

Future<List<QueryDocumentSnapshot<dynamic>>?> getAllSalonInfo(
    BuildContext context) async {
  try {
    var snapshot = await FirebaseFirestore.instance.collection("salons").get();

    if (snapshot.docs.isNotEmpty) {
      return snapshot.docs;
    } else {
      // Return null if document doesn't exist
      return null;
    }
  } catch (error) {
    // Handle errors, you can print or log the error here
    print("Error fetching salon media: $error");
    return null;
  }
}

Future<dynamic> getSalonInfo(BuildContext context) async {
  try {
    var userId = await getCurrentUser();

    var snapshot = await FirebaseFirestore.instance
        .collection("salons")
        .doc(userId!.uid)
        .get();

    if (snapshot.exists) {
      return snapshot.data();
    } else {
      // Return null if document doesn't exist
      return null;
    }
  } catch (error) {
    // Handle errors, you can print or log the error here
    print("Error fetching salon media: $error");
    return null;
  }
}

Future<dynamic> getSalonMedia(BuildContext context) async {
  try {
    var userId = await getCurrentUser();

    var snapshot = await FirebaseFirestore.instance
        .collection("salons")
        .doc(userId!.uid)
        .collection("Media")
        .doc("Images")
        .get();

    if (snapshot.exists) {
      return snapshot.data();
    } else {
      // Return null if document doesn't exist
      return null;
    }
  } catch (error) {
    // Handle errors, you can print or log the error here
    print("Error fetching salon media: $error");
    return null;
  }
}

Future<dynamic> getSalonServices(BuildContext context) async {
  try {
    var userId = await getCurrentUser();

    var snapshot = await FirebaseFirestore.instance
        .collection("salons")
        .doc(userId!.uid)
        .collection("Services")
        .doc("salons")
        .get();

    if (snapshot.exists) {
      return snapshot.data();
    } else {
      // Return null if document doesn't exist
      return null;
    }
  } catch (error) {
    // Handle errors, you can print or log the error here
    print("Error fetching salon media: $error");
    return null;
  }
}

Future<dynamic> getSalonSpecialist(BuildContext context) async {
  try {
    var userId = await getCurrentUser();

    var snapshot = await FirebaseFirestore.instance
        .collection("salons")
        .doc(userId!.uid)
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
    print("Error fetching salon media: $error");
    return null;
  }
}

Future<dynamic> MarkSalonStatus(BuildContext context, bool status) async {
  try {
    var userId = await getCurrentUser();
    await FirebaseFirestore.instance
        .collection("salons")
        .doc(userId!.uid)
        .update({"isOpen": status}).then((value) {
      print("Salon Status updated");
    });
  } catch (error) {
    // Handle errors, you can print or log the error here
    print("Error fetching salon media: $error");
    return null;
  }
}

Future<Map<String, dynamic>?> getSalonInfobyId(
    BuildContext context, String user) async {
  try {
    var snapshot =
        await FirebaseFirestore.instance.collection("salons").doc(user).get();

    if (snapshot.exists) {
      return {...snapshot.data() as dynamic, "id": snapshot.id};
    } else {
      // Return null if document doesn't exist
      return null;
    }
  } catch (error) {
    // Handle errors, you can print or log the error here
    print("Error fetching salon media: $error");
    return null;
  }
}

Future<dynamic> getSalonMediaById(BuildContext context, String id) async {
  try {
    var snapshot = await FirebaseFirestore.instance
        .collection("salons")
        .doc(id)
        .collection("Media")
        .doc("Images")
        .get();

    if (snapshot.exists) {
      return snapshot.data();
    } else {
      // Return null if document doesn't exist
      return null;
    }
  } catch (error) {
    // Handle errors, you can print or log the error here
    print("Error fetching salon media: $error");
    return null;
  }
}

Future<dynamic> getSalonServicesbyId(BuildContext context, String uid) async {
  try {
    var snapshot = await FirebaseFirestore.instance
        .collection("salons")
        .doc(uid)
        .collection("Services")
        .doc("salons")
        .get();

    if (snapshot.exists) {
      return snapshot.data();
    } else {
      // Return null if document doesn't exist
      return null;
    }
  } catch (error) {
    // Handle errors, you can print or log the error here
    print("Error fetching salon media: $error");
    return null;
  }
}

Future<dynamic> getSalonSpecialistByid(BuildContext context, String uid) async {
  try {
    var snapshot = await FirebaseFirestore.instance
        .collection("salons")
        .doc(uid)
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
    print("Error fetching salon media: $error");
    return null;
  }
}
