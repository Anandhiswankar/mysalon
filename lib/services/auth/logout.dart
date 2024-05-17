import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mysalon/Screens/splashScreen.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:mysalon/services/utility/changeScreen.dart';
import 'package:shared_preferences/shared_preferences.dart';

logoutUser(BuildContext context) async {
  SharedPreferences session = await SharedPreferences.getInstance();

  await FirebaseAuth.instance.signOut();

  session.clear();

  await GoogleSignIn().signOut();

  Fluttertoast.showToast(msg: "Bye...");

  StartfromScreen(context, SpalshScreen());
}
