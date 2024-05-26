import 'dart:ui';
import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:mysalon/elements/color.dart';
import 'package:mysalon/elements/authbtn.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mysalon/elements/namecircle.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mysalon/elements/fullviewbtn.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mysalon/services/firestore/checkuserindb.dart';

class loginScreen extends StatefulWidget {
  const loginScreen({super.key});

  @override
  State<loginScreen> createState() => _loginScreenState();
}

class _loginScreenState extends State<loginScreen> {
  @override
  void initState() {
    super.initState();
  }

  googlelogin() async {
    var cp = await signInWithGoogle();

    SharedPreferences session = await SharedPreferences.getInstance();

    var data = {
      "uid": cp!.user!.uid.toString(),
      "username": cp!.user!.displayName,
      "profile": cp!.user!.photoURL,
      "mail": cp!.user!.email,
    };

    checkUserindb(context);

    FirebaseFirestore.instance
        .collection("users")
        .doc(cp!.user!.uid)
        .set(data)
        .then((value) {
      print("Data Added");
    });

    session.setBool("loginDone", true);
    session.setString("userId", cp!.user!.uid.toString());
  }

  // Future<UserCredential?> signInWithGoogle() async {
  //   final GoogleSignInAccount? googleSignInAccount =
  //       await GoogleSignIn().signIn();

  //   if (googleSignInAccount == null) {
  //     // The user canceled the sign-in
  //     return null;
  //   }

  //   final GoogleSignInAuthentication googleSignInAuthentication =
  //       await googleSignInAccount.authentication;

  //   final OAuthCredential credential = GoogleAuthProvider.credential(
  //     accessToken: googleSignInAuthentication.accessToken,
  //     idToken: googleSignInAuthentication.idToken,
  //   );

  //   return await FirebaseAuth.instance.signInWithCredential(credential);
  // }

  Future<UserCredential?> signInWithGoogle() async {
    final GoogleSignInAccount? googleSignInAccount =
        await GoogleSignIn().signIn();

    final GoogleSignInAuthentication googleSignInAuthentication =
        await googleSignInAccount!.authentication;

    final OAuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleSignInAuthentication.accessToken,
      idToken: googleSignInAuthentication.idToken,
    );

    return await FirebaseAuth.instance.signInWithCredential(credential);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: colorBackground,
        body: Column(
          children: [
            SizedBox(
              height: 70,
            ),
            Align(
                alignment: Alignment.center,
                child: SizedBox(
                    width: 200,
                    height: 200,
                    child: nameCircle(
                      inverse: false,
                    ))),
            SizedBox(
              height: 70,
            ),
            Container(
              margin: EdgeInsets.all(20),
              child: Text(
                "Step into a world of Beauty and Confidence!",
                textAlign: TextAlign.center,
                style: GoogleFonts.inter(
                    color: Colors.white,
                    fontSize: 25,
                    fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(
              height: 70,
            ),
            SizedBox(
              child: InkWell(
                onTap: () async {
                  googlelogin();
                },
                child: authIconBtn(
                  isgoogle: true,
                ),
              ),
            ),
            // SizedBox(
            //   child: authIconBtn(
            //     isgoogle: false,
            //   ),
            // ),
            SizedBox(
              height: 20,
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              height: 40,
              alignment: Alignment.center,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    "Login in Accept All",
                    style: GoogleFonts.inter(
                        color: Colors.white,
                        fontSize: 15,
                        fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Text(
                    "Teams and Conditions",
                    style: GoogleFonts.inter(
                        color: Colors.black,
                        fontSize: 15,
                        fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
