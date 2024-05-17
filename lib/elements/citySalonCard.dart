import 'dart:ui';
import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:mysalon/elements/color.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mysalon/elements/timeparse.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mysalon/services/auth/getUser.dart';
import 'package:mysalon/elements/locationmodel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mysalon/services/saveData/addtoFav.dart';
import 'package:mysalon/services/getData/getReviews.dart';
import 'package:mysalon/services/initDataloader/salonloader.dart';
import 'package:mysalon/services/location/calculateDIstance.dart';
import 'package:mysalon/services/location/getlatloglocation.dart';

class CitySalonCard extends StatefulWidget {
  final Map<String, dynamic> salondata;

  const CitySalonCard({Key? key, required this.salondata}) : super(key: key);

  @override
  State<CitySalonCard> createState() => _CitySalonCardState();
}

class _CitySalonCardState extends State<CitySalonCard> {
  var salonMedia = null;

  bool isFav = false;

  @override
  void initState() {
    super.initState();

    print(widget.salondata);

    getminLocation();

    shopStatus();

    getMedia();

    checkFavStatus();
  }

  checkFavStatus() async {
    isFav = await checkSalonifFav(widget.salondata["id"]);

    setState(() {});
  }

  getMedia() async {
    salonMedia = await getSalonMediaById(context, widget.salondata["id"]);

    setState(() {});
  }

  var distance = 0.0;

  double totalRating = 0;

  double totalReview = 0.0;

  String statusMessage = "...";

  shopStatus() {
    TimeOfDay currentTime = TimeOfDay.now();

    // Parse salon open and close times from decimal numbers to TimeOfDay objects
    TimeOfDay openTime = parseTime(widget.salondata["openTime"].toString());
    TimeOfDay closeTime = parseTime(widget.salondata["closeTime"].toString());

    // Check if the current time is within the open and close times
    bool isOpen = currentTime.hour > openTime.hour ||
        (currentTime.hour == openTime.hour &&
            currentTime.minute >= openTime.minute);
    bool isClosed = currentTime.hour < closeTime.hour ||
        (currentTime.hour == closeTime.hour &&
            currentTime.minute <= closeTime.minute);

    statusMessage =
        isOpen && isClosed && widget.salondata["isOpen"] ? "Open" : "Closed";

    setState(() {});
  }

  getminLocation() async {
    var mycity = await getlatlongLocation();

    var salonLocation = widget.salondata["location"];

    Location loc1 = new Location(mycity["lat"], mycity["long"]);

    Location loc2 = new Location(salonLocation["lat"], salonLocation["long"]);

    distance = calculateDistance(loc1, loc2);
    print("Salon Distance is:");
    print(distance);

    var salonReview = await getSalonReviewsById(widget.salondata["id"]);

    if (salonReview != null) {
      for (int i = 0; i < salonReview!.length; i++) {
        totalRating += salonReview[i].data()["rating"];
      }

      totalReview = totalRating / salonReview.length;
    }

    setState(() {});
  }

  String dummyCover =
      "https://images.squarespace-cdn.com/content/v1/5b4818cdd274cba3ecbed6f9/de90d39c-1fca-48ba-93a8-7e6fb07fdd70/Salon+hero.jpg";

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(5),
      width: 200,
      height: 230,
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: const Color.fromARGB(139, 158, 158, 158),
            spreadRadius: 2,
            blurRadius: 2.0,
          )
        ],
        borderRadius: BorderRadius.circular(20),
        color: Colors.white,
      ),
      child: Column(
        children: [
          Stack(
            children: [
              Container(
                width: 200,
                height: 120,
                decoration: BoxDecoration(
                  color: Colors.amber,
                  borderRadius: BorderRadius.only(
                    topLeft: const Radius.circular(20),
                    topRight: const Radius.circular(20),
                  ),
                  image: DecorationImage(
                    image: salonMedia != null
                        ? NetworkImage(salonMedia["salonCover"] ?? dummyCover)
                        : NetworkImage(
                            dummyCover,
                          ),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Positioned(
                right: 2,
                bottom: 5,
                child: SizedBox(
                  width: 55,
                  height: 30,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.yellow,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      children: [
                        const SizedBox(width: 3),
                        Icon(
                          Icons.stars,
                          color: primeColor,
                          size: 20,
                        ),
                        const SizedBox(width: 3),
                        Text(
                          totalReview.toString(),
                          style: GoogleFonts.inter(fontWeight: FontWeight.bold),
                        )
                      ],
                    ),
                  ),
                ),
              ),
              Positioned(
                right: 10,
                top: 10,
                child: CircleAvatar(
                  backgroundColor: Colors.white.withOpacity(0.6),
                  radius: 20,
                  child: Icon(
                    isFav ? Icons.favorite : Icons.favorite_outline,
                    size: 25,
                    color: primeColor,
                  ),
                ),
              ),
            ],
          ),
          Text(
            widget.salondata['salonName'] ?? '',
            style: GoogleFonts.inter(
              color: Colors.black,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 3),
          Container(
            width: 200,
            height: 20,
            child: Row(
              children: [
                Icon(Icons.shopping_basket_outlined),
                SizedBox(width: 10),
                Text(
                  statusMessage,
                  style: GoogleFonts.inter(
                    color: primeColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 3),
          Container(
            width: 200,
            child: Row(
              children: [
                Icon(Icons.location_on_outlined),
                SizedBox(width: 10),
                SizedBox(
                  width: 150,
                  child: Text(
                    widget.salondata['fetchAddr'] ?? '',
                    style: GoogleFonts.inter(color: Colors.black),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 3),
          Container(
            width: 200,
            height: 20,
            child: Row(
              children: [
                Icon(Icons.social_distance_rounded),
                SizedBox(width: 10),
                Text(
                  "${distance.toStringAsFixed(2)} km", // You may calculate the distance based on the user's location
                  style: GoogleFonts.inter(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
