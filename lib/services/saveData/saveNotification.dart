import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:geolocator/geolocator.dart';
import 'package:mysalon/elements/alertbox.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mysalon/elements/warningbox.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mysalon/services/auth/getUser.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mysalon/services/getData/getUserById.dart';
import 'package:mysalon/services/getData/getAdminData.dart';

saveNotification(
    BuildContext context, String toId, String msg, String action) async {
  var user = await getCurrentUser();

  var data = {
    "from": user!.uid,
    "to": toId,
    "msg": msg,
    "timestamp": Timestamp.now(),
    "action": action
  };

  FirebaseFirestore.instance
      .collection("Notification")
      .add(data)
      .then((value) async {
    warningBox(context, "Posted");
    await sendNotification(toId, msg);
  }).catchError((onError) {
    print("Error to add post: " + onError);
    warningBox(context, "Error to post Ads: " + onError.toString());
  });
}

saveNotificationAdmin(BuildContext context, String msg, String action) async {
  var user = await getCurrentUser();

  var admin = await GetAdminData();

  String toId = admin[0].uid;

  var data = {
    "from": user!.uid,
    "to": toId,
    "msg": msg,
    "timestamp": Timestamp.now(),
    "action": action
  };

  FirebaseFirestore.instance
      .collection("Notification")
      .add(data)
      .then((value) async {
    warningBox(context, "Posted");
    await sendNotification(toId, msg);
  }).catchError((onError) {
    print("Error to add post: " + onError);
    warningBox(context, "Error to post Ads: " + onError.toString());
  });
}

sendNotification(String toId, String msg) async {
  var snap = await getUserById(toId);

  var token = snap["token"];

  // Your backend server endpoint URL for sending notifications
  String serverUrl = 'https://fcm.googleapis.com/fcm/send';

  // Data to send to the server
  Map<String, dynamic> data = {
    'to': token,
    'title': msg,
    'body': "notification: " + msg,
    'data': {}
  };

  try {
    Map<String, String> headers = {
      'Authorization':
          'key=AAAAnlE3zz8:APA91bGAiRZw_bOn_rA42JjTptOL4mC1tadV9pPcvxL_l1hyBeSJ_8OAFjH4lcINUZE8O9Xo9cwpdRDRi4cCbHXE4T9WOdRy_MF96IFgYc5BOjYhuy5WVGWMASq7ugnD2MUMV4g_Zo05', // Add Firebase auth token here
      'Content-Type': 'application/json',
    };

    // Make HTTP POST request to the server
    final response = await http.post(
      headers: headers,
      Uri.parse(serverUrl),
      body: data,
    );

    // Check if the request was successful
    if (response.statusCode == 200) {
      print('Notification sent successfully');
    } else {
      print('Failed to send notification. Error: ${response.reasonPhrase}');
    }
  } catch (error) {
    print('Failed to send notification. Error: $error');
  }
}
