import 'package:flutter/widgets.dart';
import 'package:geolocator/geolocator.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mysalon/services/auth/getUser.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

Future<List<QueryDocumentSnapshot<dynamic>>?> getAdminStateUser() async {
  try {
    var snapshot = await FirebaseFirestore.instance
        .collection("users")
        .where("isSalon", isEqualTo: false)
        .get();

    if (snapshot.docs.isNotEmpty) {
      return snapshot.docs;
    } else {
      // Return null if document doesn't exist;
      return [];
    }
  } catch (error) {
    // Handle errors, you can print or log the error here;
    print("Error fetching user by id: $error");
    return [];
  }
}

Future<List<QueryDocumentSnapshot<dynamic>>?> getAdminStateRecipt() async {
  try {
    var snapshot = await FirebaseFirestore.instance.collection("recipts").get();

    if (snapshot.docs.isNotEmpty) {
      return snapshot.docs;
    } else {
      // Return null if document doesn't exist;
      return [];
    }
  } catch (error) {
    // Handle errors, you can print or log the error here;
    print("Error fetching user by id: $error");
    return [];
  }
}

Future<List<QueryDocumentSnapshot<dynamic>>?> getAdminStateSalon() async {
  try {
    var snapshot = await FirebaseFirestore.instance.collection("salons").get();

    if (snapshot.docs.isNotEmpty) {
      return snapshot.docs;
    } else {
      // Return null if document doesn't exist
      return [];
    }
  } catch (error) {
    // Handle errors, you can print or log the error here
    print("Error fetching user by id: $error");
    return [];
  }
}

Future<List<dynamic>?> getAdminStateBooking() async {
  try {
    List<dynamic> loaderData = [];

    var snap = await FirebaseFirestore.instance
        .collection("users")
        .where("isSalon", isEqualTo: true)
        .get();

    for (int i = 0; i < snap.docs.length; i++) {
      var snapshot = await FirebaseFirestore.instance
          .collection("salons")
          .doc(snap.docs[i].id)
          .collection("bookedAppointments")
          .get();

      for (int j = 0; j < snapshot.docs.length; j++) {
        loaderData.add(snapshot.docs[j].data());
      }
    }

    return loaderData;
  } catch (error) {
    // Handle errors, you can print or log the error here
    print("Error fetching user by id: $error");
    return [];
  }
}

Future<List<QueryDocumentSnapshot<dynamic>>?> getAdminStateUserFilter(
    {String isFilter = "today"}) async {
  try {
    dynamic snapshot = [];

    if (isFilter == "today") {
      DateTime now = DateTime.now();

      // Get the start of today
      DateTime startOfDay = DateTime(now.year, now.month, now.day);

      // Get the end of today (start of next day)
      DateTime endOfDay = DateTime(now.year, now.month, now.day + 1);

      // Query Firestore to fetch user data for today
      snapshot = await FirebaseFirestore.instance
          .collection("users")
          .where("joinDate",
              isGreaterThanOrEqualTo: Timestamp.fromDate(startOfDay))
          .where("joinDate", isLessThan: Timestamp.fromDate(endOfDay))
          .where("isSalon", isEqualTo: false)
          .get();
    } else if (isFilter == "thismonth") {
      print("Getting This month data");
      DateTime now = DateTime.now();

      // Get the start of the current month
      DateTime startOfMonth = DateTime(now.year, now.month, 1);

      // Get the start of the next month
      DateTime startOfNextMonth = DateTime(now.year, now.month + 1, 1);

      snapshot = await FirebaseFirestore.instance
          .collection("users")
          .where("joinDate",
              isGreaterThanOrEqualTo: Timestamp.fromDate(startOfMonth))
          .where("joinDate", isLessThan: Timestamp.fromDate(startOfNextMonth))
          .where("isSalon", isEqualTo: false)
          .get();

      print(snapshot.docs);
    } else if (isFilter == "6month") {
      DateTime now = DateTime.now();

      // Calculate the start date for 6 months ago
      DateTime startOfSixMonthsAgo = DateTime(now.year, now.month - 6, 1);

      // Get the start of the next month
      DateTime startOfNextMonth = DateTime(now.year, now.month + 1, 1);
      snapshot = await FirebaseFirestore.instance
          .collection("users")
          .where("isSalon", isEqualTo: false)
          .where("joinDate",
              isGreaterThanOrEqualTo: Timestamp.fromDate(startOfSixMonthsAgo))
          .where("joinDate", isLessThan: Timestamp.fromDate(startOfNextMonth))
          .get();
    }

    if (snapshot.docs.isNotEmpty) {
      print(snapshot);
      return snapshot.docs;
    } else {
      // Return null if document doesn't exist;
      return [];
    }
  } catch (error) {
    // Handle errors, you can print or log the error here;
    print("Error fetching user by id: $error");
    return [];
  }
}

Future<List<QueryDocumentSnapshot<dynamic>>?> getAdminStateReciptFilter(
    {String isFilter = "today"}) async {
  try {
    dynamic snapshot = [];

    if (isFilter == "today") {
      DateTime now = DateTime.now();

      // Get the start of today
      DateTime startOfDay = DateTime(now.year, now.month, now.day);

      // Get the end of today (start of next day)
      DateTime endOfDay = DateTime(now.year, now.month, now.day + 1);

      snapshot = await FirebaseFirestore.instance
          .collection("recipts")
          .where("timestamp",
              isGreaterThanOrEqualTo: Timestamp.fromDate(startOfDay))
          .where("timestamp", isLessThan: Timestamp.fromDate(endOfDay))
          .get();
    } else if (isFilter == "thismonth") {
      DateTime now = DateTime.now();

      // Get the start of the current month
      DateTime startOfMonth = DateTime(now.year, now.month, 1);

      // Get the start of the next month
      DateTime startOfNextMonth = DateTime(now.year, now.month + 1, 1);

      snapshot = await FirebaseFirestore.instance
          .collection("recipts")
          .where("timestamp",
              isGreaterThanOrEqualTo: Timestamp.fromDate(startOfMonth))
          .where("timestamp", isLessThan: Timestamp.fromDate(startOfNextMonth))
          .get();
    } else if (isFilter == "6month") {
      DateTime now = DateTime.now();

      // Calculate the start date for 6 months ago
      DateTime startOfSixMonthsAgo = DateTime(now.year, now.month - 6, 1);

      // Get the start of the next month
      DateTime startOfNextMonth = DateTime(now.year, now.month + 1, 1);

      snapshot = await FirebaseFirestore.instance
          .collection("recipts")
          .where("timestamp",
              isGreaterThanOrEqualTo: Timestamp.fromDate(startOfSixMonthsAgo))
          .where("timestamp", isLessThan: Timestamp.fromDate(startOfNextMonth))
          .get();
    }

    if (snapshot.docs.isNotEmpty) {
      return snapshot.docs;
    } else {
      // Return null if document doesn't exist;
      return [];
    }
  } catch (error) {
    // Handle errors, you can print or log the error here;
    print("Error fetching user by id: $error");
    return [];
  }
}

Future<List> getAdminStateSalonFilter({String isFilter = "today"}) async {
  try {
    dynamic snapshot = [];

    List<dynamic> loaderData = [];

    dynamic snap = [];

    if (isFilter == "today") {
      DateTime now = DateTime.now();

      // Get the start of today
      DateTime startOfDay = DateTime(now.year, now.month, now.day);

      // Get the end of today (start of next day)
      DateTime endOfDay = DateTime(now.year, now.month, now.day + 1);
      snapshot = await FirebaseFirestore.instance
          .collection("users")
          .where("joinDate",
              isGreaterThanOrEqualTo: Timestamp.fromDate(startOfDay))
          .where("joinDate", isLessThan: Timestamp.fromDate(endOfDay))
          .where("isSalon", isEqualTo: true)
          .get();
    } else if (isFilter == "thismonth") {
      DateTime now = DateTime.now();

      // Get the start of the current month
      DateTime startOfMonth = DateTime(now.year, now.month, 1);

      // Get the start of the next month
      DateTime startOfNextMonth = DateTime(now.year, now.month + 1, 1);

      snapshot = await FirebaseFirestore.instance
          .collection("users")
          .where("joinDate",
              isGreaterThanOrEqualTo: Timestamp.fromDate(startOfMonth))
          .where("joinDate", isLessThan: Timestamp.fromDate(startOfNextMonth))
          .where("isSalon", isEqualTo: true)
          .get();
    } else if (isFilter == "6month") {
      DateTime now = DateTime.now();

      // Calculate the start date for 6 months ago
      DateTime startOfSixMonthsAgo = DateTime(now.year, now.month - 6, 1);

      // Get the start of the next month
      DateTime startOfNextMonth = DateTime(now.year, now.month + 1, 1);

      snapshot = await FirebaseFirestore.instance
          .collection("users")
          .where("joinDate",
              isGreaterThanOrEqualTo: Timestamp.fromDate(startOfSixMonthsAgo))
          .where("joinDate", isLessThan: Timestamp.fromDate(startOfNextMonth))
          .where("isSalon", isEqualTo: true)
          .get();
    }

    for (int i = 0; i < snapshot.docs.length; i++) {
      var snapshots = await FirebaseFirestore.instance
          .collection("salons")
          .doc(snapshot.docs[i].id)
          .get();

      Map<String, dynamic> dat = {
        ...?snapshots.data() as dynamic,
        "id": snapshot.docs[i].id,
      };

      loaderData.add(dat);
    }

    return loaderData;
  } catch (error) {
    // Handle errors, you can print or log the error here
    print("Error fetching user by id: $error");
    return [];
  }
}

Future<List<QueryDocumentSnapshot<dynamic>>?> getAdminStateBookingFilter(
    {String isFilter = "today"}) async {
  try {
    List<QueryDocumentSnapshot<dynamic>> loaderData = [];

    dynamic snap = [];

    snap = await FirebaseFirestore.instance
        .collection("users")
        .where("isSalon", isEqualTo: true)
        .get();

    if (isFilter == "today") {
      DateTime now = DateTime.now();

      // Get the start of today
      DateTime startOfDay = DateTime(now.year, now.month, now.day);

      // Get the end of today (start of next day)
      DateTime endOfDay = DateTime(now.year, now.month, now.day + 1);

      snap = await FirebaseFirestore.instance
          .collection("users")
          .where("isSalon", isEqualTo: true)
          .where("joinDate",
              isGreaterThanOrEqualTo: Timestamp.fromDate(startOfDay))
          .where("joinDate", isLessThan: Timestamp.fromDate(endOfDay))
          .get();
    } else if (isFilter == "thismonth") {
      DateTime now = DateTime.now();

      // Get the start of the current month
      DateTime startOfMonth = DateTime(now.year, now.month, 1);

      // Get the start of the next month
      DateTime startOfNextMonth = DateTime(now.year, now.month + 1, 1);

      snap = await FirebaseFirestore.instance
          .collection("users")
          .where("isSalon", isEqualTo: true)
          .where("joinDate",
              isGreaterThanOrEqualTo: Timestamp.fromDate(startOfMonth))
          .where("joinDate", isLessThan: Timestamp.fromDate(startOfNextMonth))
          .get();
    } else if (isFilter == "6month") {
      DateTime now = DateTime.now();

      // Calculate the start date for 6 months ago
      DateTime startOfSixMonthsAgo = DateTime(now.year, now.month - 6, 1);

      // Get the start of the next month
      DateTime startOfNextMonth = DateTime(now.year, now.month + 1, 1);

      snap = await FirebaseFirestore.instance
          .collection("users")
          .where("isSalon", isEqualTo: true)
          .where("joinDate",
              isGreaterThanOrEqualTo: Timestamp.fromDate(startOfSixMonthsAgo))
          .where("joinDate", isLessThan: Timestamp.fromDate(startOfNextMonth))
          .get();
    }

    for (int i = 0; i < snap.docs.length; i++) {
      var snapshot = await FirebaseFirestore.instance
          .collection("salons")
          .doc(snap.docs[i].id)
          .collection("bookedAppointments")
          .get();

      for (int j = 0; j < snapshot.docs.length; j++) {
        loaderData.add(snapshot.docs[j]);
      }
    }

    return loaderData;
  } catch (error) {
    // Handle errors, you can print or log the error here
    print("Error fetching user by id: $error");
    return [];
  }
}

Future<List<dynamic>?> getAdminAllSalons() async {
  try {
    List<Map<String, dynamic>> loaderData = [];

    dynamic snap = [];

    snap = await FirebaseFirestore.instance
        .collection("users")
        .where("isSalon", isEqualTo: true)
        .get();

    for (int i = 0; i < snap.docs.length; i++) {
      var snapshot = await FirebaseFirestore.instance
          .collection("salons")
          .doc(snap.docs[i].id)
          .get();

      Map<String, dynamic> dat = {
        ...?snapshot.data() as dynamic,
        "id": snap.docs[i].id,
      };

      loaderData.add(dat);
    }

    return loaderData;
  } catch (error) {
    // Handle errors, you can print or log the error here;
    print("Error fetching user by id: $error");
    return [];
  }
}
