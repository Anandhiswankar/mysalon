import 'package:lottie/lottie.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/cupertino.dart';
import 'package:mysalon/elements/color.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mysalon/Screens/salon/homepage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mysalon/Screens/authscreens/loginscreen.dart';
import 'package:flutter_slider_indicator/flutter_slider_indicator.dart';

class guideScreen extends StatefulWidget {
  const guideScreen({super.key});

  @override
  State<guideScreen> createState() => _guideScreenState();
}

class _guideScreenState extends State<guideScreen> {
  int activePage = 0;

  PageController pc = PageController(initialPage: 0);

  @override
  void initState() {
    super.initState();
  }

  checkUser() async {
    SharedPreferences session = await SharedPreferences.getInstance();
    session.setBool("loaded", true);

    if (FirebaseAuth.instance.currentUser != null) {
      Navigator.of(context)
          .pushReplacement(MaterialPageRoute(builder: (context) {
        return SalonHomePage();
      }));
    } else {
      Navigator.of(context)
          .pushReplacement(MaterialPageRoute(builder: (context) {
        return loginScreen();
      }));
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: colorBackground,
        body: Column(
          children: [
            SizedBox(
              height: 50,
            ),
            Container(
              width: MediaQuery.of(context).size.width * 0.80,
              height: 550,
              child: PageView(
                controller: pc,
                onPageChanged: (value) {
                  activePage = value;
                  setState(() {});
                },
                children: [
                  Container(
                    child: Column(
                      children: [
                        Container(
                          width: 400,
                          height: 400,
                          decoration: BoxDecoration(
                              image: DecorationImage(
                                  image: AssetImage("assets/images/guide1.png"),
                                  fit: BoxFit.cover)),
                        ),
                        SizedBox(
                          height: 40,
                        ),
                        Text(
                          "Discover Nearby Beauty Salons",
                          textAlign: TextAlign.center,
                          style: GoogleFonts.inter(
                              color: Colors.white,
                              fontSize: 25,
                              fontWeight: FontWeight.bold),
                        )
                      ],
                    ),
                  ),
                  Container(
                    child: Column(
                      children: [
                        Container(
                          height: 300,
                          decoration: BoxDecoration(
                              image: DecorationImage(
                                  image: AssetImage("assets/images/guide2.png"),
                                  fit: BoxFit.fitHeight)),
                        ),
                        SizedBox(
                          height: 40,
                        ),
                        Text(
                          "Effortless Appointment Bookings",
                          textAlign: TextAlign.center,
                          style: GoogleFonts.inter(
                              color: Colors.white,
                              fontSize: 25,
                              fontWeight: FontWeight.bold),
                        )
                      ],
                    ),
                  ),
                  Container(
                    child: Column(
                      children: [
                        Container(
                          height: 300,
                          decoration: BoxDecoration(
                              image: DecorationImage(
                                  image: AssetImage("assets/images/guide3.png"),
                                  fit: BoxFit.fitHeight)),
                        ),
                        SizedBox(
                          height: 50,
                        ),
                        Text(
                          "All your service in your one click",
                          textAlign: TextAlign.center,
                          style: GoogleFonts.inter(
                              color: Colors.white,
                              fontSize: 25,
                              fontWeight: FontWeight.bold),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Spacer(),
            Container(
              width: MediaQuery.of(context).size.width,
              height: 40,
              alignment: Alignment.center,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Icon(
                    size: 20,
                    activePage == 0 ? Icons.circle_outlined : Icons.circle,
                    color: Colors.white,
                  ),
                  Icon(
                    size: 20,
                    activePage == 1 ? Icons.circle_outlined : Icons.circle,
                    color: Colors.white,
                  ),
                  Icon(
                    size: 20,
                    activePage == 2 ? Icons.circle_outlined : Icons.circle,
                    color: Colors.white,
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 20,
            ),
            InkWell(
              onTap: () {
                if (activePage < 2) {
                  activePage += 1;
                  pc.jumpToPage(activePage);
                  setState(() {});
                } else {
                  checkUser();
                  //Fluttertoast.showToast(msg: "Welcome");
                }
              },
              child: Container(
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(80)),
                width: MediaQuery.of(context).size.width * 0.70,
                height: 60,
                alignment: Alignment.center,
                child: Text(
                  activePage == 2 ? "Done" : "Next",
                  style: GoogleFonts.inter(
                      fontSize: 25,
                      color: primeColor,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ),
            SizedBox(
              height: 60,
            )
          ],
        ),
      ),
    );
  }
}
