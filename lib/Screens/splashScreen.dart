import 'package:lottie/lottie.dart';
import 'package:flutter/material.dart';
import 'package:mysalon/elements/color.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:mysalon/services/permission/onStartPermisisons.dart';

class SpalshScreen extends StatefulWidget {
  const SpalshScreen({super.key});

  @override
  State<SpalshScreen> createState() => _SpalshScreenState();
}

class _SpalshScreenState extends State<SpalshScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    waitfortime();
  }

  waitfortime() async {
    if (!await onStartPermission()) {
      Fluttertoast.showToast(
          msg: "This App need Location Permission for work fine");
      return;
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      backgroundColor: colorBackground,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              decoration: const BoxDecoration(boxShadow: [
                BoxShadow(
                    color: Color.fromARGB(87, 0, 0, 0),
                    offset: Offset(0, 2),
                    blurRadius: 15,
                    spreadRadius: 5)
              ], color: Colors.white, shape: BoxShape.circle),
              width: 200,
              height: 200,
              child: SizedBox(
                  width: 100,
                  height: 100,
                  child: Lottie.asset("assets/json/startlogo.json")),
            ),
            const SizedBox(
              height: 20,
            ),
            AnimatedTextKit(
              animatedTexts: [
                FadeAnimatedText("Ziggly",
                    textStyle:
                        GoogleFonts.aclonica(fontSize: 45, color: Colors.white),
                    duration: Duration(seconds: 2)),
              ],
              totalRepeatCount: 2,
              displayFullTextOnTap: false,
              stopPauseOnTap: false,
            )
          ],
        ),
      ),
    ));
  }
}
