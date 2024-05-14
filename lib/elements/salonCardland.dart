import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:mysalon/elements/color.dart';
import 'package:mysalon/elements/topbar.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mysalon/elements/timeparse.dart';
import 'package:mysalon/elements/lightlabel.dart';
import 'package:mysalon/elements/screenloader.dart';
import 'package:mysalon/elements/locationmodel.dart';
import 'package:mysalon/elements/custominputbox.dart';
import 'package:mysalon/services/saveData/addtoFav.dart';
import 'package:mysalon/services/getData/getReviews.dart';
import 'package:mysalon/services/getData/getUserById.dart';
import 'package:mysalon/services/initDataloader/salonloader.dart';
import 'package:mysalon/services/location/getlatloglocation.dart';

class SalonCardLand extends StatefulWidget {
  final Map<String, dynamic> salondata;
  bool isAds;
  bool isFav;
  SalonCardLand(
      {super.key,
      this.isAds = false,
      this.isFav = false,
      required this.salondata});

  @override
  State<SalonCardLand> createState() => _SalonCardLandState();
}

class _SalonCardLandState extends State<SalonCardLand> {
  var salonMedia = null;

  double totalRating = 0;

  double totalReview = 0.0;

  bool isFav = false;

  @override
  void initState() {
    super.initState();

    print(widget.salondata);

    shopStatus();
    getMedia();

    getReview();

    checkFavStatus();
  }

  checkFavStatus() async {
    isFav = await checkSalonifFav(widget.salondata["id"]);

    setState(() {});
  }

  getReview() async {
    var salonReview = await getSalonReviewsById(widget.salondata["id"]) ?? [];

    if (salonReview.isNotEmpty) {
      for (int i = 0; i < salonReview!.length; i++) {
        totalRating += salonReview[i].data()["rating"];
      }

      totalReview = totalRating / salonReview.length;
    }

    setState(() {});
  }

  getMedia() async {
    salonMedia = await getSalonMediaById(context, widget.salondata["id"]);

    print(salonMedia);

    setState(() {});
  }

  var distance = 0;

  String statusMessage = "...";

  shopStatus() {
    TimeOfDay currentTime = TimeOfDay.now();

    TimeOfDay openTime = parseTime(widget.salondata["openTime"].toString());
    TimeOfDay closeTime = parseTime(widget.salondata["closeTime"].toString());

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

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(10),
      width: MediaQuery.of(context).size.width,
      height: 150,
      decoration: BoxDecoration(boxShadow: [
        BoxShadow(
          color: const Color.fromARGB(139, 158, 158, 158),
          spreadRadius: 2,
          blurRadius: 2.0,
        )
      ], borderRadius: BorderRadius.circular(20), color: Colors.white),
      child: Row(
        children: [
          Stack(
            children: [
              salonMedia == null
                  ? screenLoader()
                  : Container(
                      width: 150,
                      height: 150,
                      decoration: BoxDecoration(
                          color: Colors.amber,
                          borderRadius: BorderRadius.circular(10),
                          image: DecorationImage(
                              image: NetworkImage(salonMedia["salonCover"] ??
                                  "https://images.squarespace-cdn.com/content/v1/5b4818cdd274cba3ecbed6f9/de90d39c-1fca-48ba-93a8-7e6fb07fdd70/Salon+hero.jpg"),
                              fit: BoxFit.cover)),
                    ),
              widget.isAds
                  ? Positioned(
                      right: 2,
                      top: 5,
                      child: SizedBox(
                          width: 50,
                          height: 20,
                          child: Container(
                            decoration: BoxDecoration(
                                color: primeColor,
                                borderRadius: BorderRadius.circular(10)),
                            child: Row(
                              children: [
                                SizedBox(
                                  width: 12,
                                ),
                                Text(
                                  "Ads",
                                  style: GoogleFonts.inter(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12),
                                )
                              ],
                            ),
                          )))
                  : SizedBox(),
              Positioned(
                  right: 2,
                  bottom: 5,
                  child: SizedBox(
                      width: 50,
                      height: 20,
                      child: Container(
                        decoration: BoxDecoration(
                            color: Colors.yellow,
                            borderRadius: BorderRadius.circular(10)),
                        child: Row(
                          children: [
                            SizedBox(
                              width: 3,
                            ),
                            Icon(
                              Icons.stars,
                              color: primeColor,
                              size: 15,
                            ),
                            SizedBox(
                              width: 3,
                            ),
                            Text(
                              totalRating.toString(),
                              style: GoogleFonts.inter(
                                  fontWeight: FontWeight.bold, fontSize: 12),
                            )
                          ],
                        ),
                      ))),
              Positioned(
                  left: 10,
                  top: 10,
                  child: CircleAvatar(
                    backgroundColor: Colors.white.withOpacity(0.6),
                    radius: 15,
                    child: Icon(
                      isFav ? Icons.favorite : Icons.favorite_outline,
                      size: 20,
                      color: primeColor,
                    ),
                  )),
            ],
          ),
          Container(
            width: MediaQuery.of(context).size.width * 0.50,
            height: 150,
            child: Column(
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.45,
                  child: Text(
                    widget.salondata["salonName"] ?? "loading..",
                    style: GoogleFonts.inter(
                        color: Colors.black,
                        fontSize: 18,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                SizedBox(
                  height: 3,
                ),
                Container(
                  width: 200,
                  height: 20,
                  child: Row(
                    children: [
                      Icon(Icons.shopping_basket_outlined),
                      SizedBox(
                        width: 10,
                      ),
                      Text(
                        statusMessage ?? "...",
                        style: GoogleFonts.inter(
                            color: primeColor, fontWeight: FontWeight.bold),
                      )
                    ],
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Container(
                  width: 200,
                  height: 20,
                  child: Row(
                    children: [
                      Icon(Icons.location_on_outlined),
                      SizedBox(
                        width: 10,
                      ),
                      SizedBox(
                        width: 150,
                        child: Text(
                          widget.salondata["fetchAddr"],
                          style: GoogleFonts.inter(
                            color: Colors.black,
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                widget.salondata["distance"] == null
                    ? SizedBox()
                    : Container(
                        width: 200,
                        height: 20,
                        child: Row(
                          children: [
                            Icon(Icons.social_distance_rounded),
                            SizedBox(
                              width: 10,
                            ),
                            Text(
                              "${widget.salondata["distance"]} km",
                              style: GoogleFonts.inter(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold),
                            )
                          ],
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
