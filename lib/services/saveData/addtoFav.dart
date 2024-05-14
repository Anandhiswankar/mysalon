import 'package:flutter/widgets.dart';
import 'package:geolocator/geolocator.dart';
import 'package:mysalon/elements/alertbox.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mysalon/elements/warningbox.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mysalon/services/auth/getUser.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

checkSalonifFav(String salonId) async {
  var user = await getCurrentUser();

  var favList = await FirebaseFirestore.instance
      .collection("users")
      .doc(user!.uid)
      .collection("favSalon")
      .where("salonid", isEqualTo: salonId)
      .get();

  if (favList.docs.isNotEmpty) {
    return true;
  } else {
    return false;
  }
}

addsalontoFav(BuildContext context, String salonId) async {
  var user = await getCurrentUser();

  var data = {
    "salonid": salonId,
    "timestamp": Timestamp.now(),
  };

  var favList = await FirebaseFirestore.instance
      .collection("users")
      .doc(user!.uid)
      .collection("favSalon")
      .where("salonid", isEqualTo: salonId)
      .get();

  if (favList.docs.isEmpty) {
    FirebaseFirestore.instance
        .collection("users")
        .doc(user!.uid)
        .collection("favSalon")
        .add(data)
        .then((value) {
      warningBox(context, "Added");
    }).catchError((onError) {
      print("Error to add post: " + onError);
      warningBox(context, "Error to post Ads: " + onError.toString());
    });
  } else {
    FirebaseFirestore.instance
        .collection("users")
        .doc(user!.uid)
        .collection("favSalon")
        .doc(favList.docs[0].id)
        .delete()
        .then((value) {
      warningBox(context, "Removed");
    }).catchError((onError) {
      print("Error to add post: " + onError);
      warningBox(context, "Error to post Ads: " + onError.toString());
    });
  }
}
