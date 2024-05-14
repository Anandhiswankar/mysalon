import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/cupertino.dart';
import 'package:mysalon/elements/color.dart';
import 'package:mysalon/elements/topbar.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mysalon/elements/reviewcard.dart';
import 'package:mysalon/elements/lightlabel.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mysalon/elements/screenloader.dart';
import 'package:mysalon/services/auth/getUser.dart';
import 'package:mysalon/services/auth/getUser.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mysalon/elements/appointmentcard.dart';
import 'package:mysalon/services/getData/getReviews.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class ReviewScreen extends StatefulWidget {
  const ReviewScreen({super.key});
  @override
  State<ReviewScreen> createState() => _ReviewScreenState();
}

class _ReviewScreenState extends State<ReviewScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    loadData();
  }

  double totalRating = 0;
  List<QueryDocumentSnapshot<dynamic>>? salonReview = null;

  loadData() async {
    var uid = await getCurrentUser();

    salonReview = await getSalonReviewsById(uid!.uid);

    if (salonReview != null) {
      print("Total Reviews");
      print(salonReview!.length);

      for (int i = 0; i < salonReview!.length; i++) {
        totalRating += salonReview![i].data()["rating"];
      }

      print("Total Rating: " + totalRating.toString());

      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      backgroundColor: primeColor,
      body: Stack(
        children: [
          Positioned(
              child: TopBarLabel(
            label: "Review",
            textcolor: Colors.white,
          )),
          Container(
            width: MediaQuery.of(context).size.width,
            height: 300,
            alignment: Alignment.center,
            child: salonReview == null
                ? Text("No Salon Review found")
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      RatingBar(
                        ignoreGestures: true,
                        initialRating: totalRating / salonReview!.length,
                        direction: Axis.horizontal,
                        allowHalfRating: false,
                        glow: true,
                        glowColor: Colors.white,
                        glowRadius: 20,
                        itemCount: 5,
                        ratingWidget: RatingWidget(
                          full: Icon(Icons.favorite),
                          half: Icon(Icons.favorite),
                          empty: Icon(
                            Icons.favorite_border_rounded,
                            color: Colors.white,
                          ),
                        ),
                        itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                        onRatingUpdate: (rating) {
                          print(rating);
                        },
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Text(
                        (totalRating / salonReview!.length).toString(),
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 30,
                            fontWeight: FontWeight.bold),
                      )
                    ],
                  ),
          ),
          Container(
            alignment: Alignment.bottomCenter,
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: Container(
              width: MediaQuery.of(context).size.width * 0.95,
              height: MediaQuery.of(context).size.height * 0.65,
              decoration: BoxDecoration(
                  color: Color.fromARGB(255, 234, 234, 234),
                  border: Border.all(width: 0.5, color: primeColor),
                  boxShadow: [
                    BoxShadow(
                        color: Color.fromARGB(69, 20, 20, 20),
                        spreadRadius: 1,
                        blurRadius: 5,
                        offset: Offset(0, 12))
                  ],
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20))),
              alignment: Alignment.center,
              padding: EdgeInsets.all(20),
              child: Column(
                children: [
                  Text(
                    "Client Reviews",
                    style: TextStyle(
                        color: primeColor,
                        fontSize: 20,
                        fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  salonReview == null
                      ? Center(
                          child: Text("No Salon Reviews"),
                        )
                      : Expanded(
                          child: Container(
                          child: ListView.builder(
                              itemCount: salonReview!.length,
                              itemBuilder: (context, index) {
                                return ReviewCard(
                                    reviewObject: salonReview![index]);
                              }),
                        ))
                ],
              ),
            ),
          ),
        ],
      ),
    ));
  }
}
