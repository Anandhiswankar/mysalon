import 'package:intl/intl.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:mysalon/elements/color.dart';
import 'package:mysalon/elements/topbar.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mysalon/elements/lightlabel.dart';
import 'package:mysalon/elements/fullviewbtn.dart';
import 'package:mysalon/elements/custominputbox.dart';
import 'package:mysalon/Screens/user/saloninfopage.dart';
import 'package:mysalon/services/saveData/saveReview.dart';
import 'package:mysalon/services/utility/changeScreen.dart';
import 'package:mysalon/services/getData/getMyReviewd.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:mysalon/services/initDataloader/salonloader.dart';

class SalonAppointmentCard extends StatefulWidget {
  bool isDone;
  bool isRevied;
  dynamic bookingData;

  SalonAppointmentCard(
      {super.key,
      this.isDone = false,
      this.isRevied = false,
      this.bookingData});

  @override
  State<SalonAppointmentCard> createState() => _SalonAppointmentCardState();
}

class _SalonAppointmentCardState extends State<SalonAppointmentCard> {
  TextEditingController name = TextEditingController();
  TextEditingController info = TextEditingController();

  dynamic salonInfo;
  dynamic salonMedia;

  String status = "loading..";

  bool isCompleted = false;

  dynamic reviewdata;

  double selectedRating = 1;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    loadData();
  }

  loadData() async {
    salonInfo = await getSalonInfobyId(context, widget.bookingData["salonId"]);
    salonMedia =
        await getSalonMediaById(context, widget.bookingData["salonId"]);

    setState(() {});

    print(salonInfo);
    print(salonMedia);

    String combinedStr =
        "${widget.bookingData["selectedDate"]} ${widget.bookingData["bookedSlot"]}";

    // Define the date format
    DateFormat dateFormat = DateFormat("dd-MM-yyyy hh:mm a");

    // Parse the combined string into a DateTime object
    DateTime dateTime = dateFormat.parse(combinedStr);

    if (dateTime.isBefore(DateTime.now())) {
      status = "Completed";
      isCompleted = true;
    } else {
      status = "pending";
      isCompleted = false;
    }

    reviewdata = await getMyReviewForthisbooking(
      widget.bookingData["salonId"],
      widget.bookingData["id"],
    );

    print("review data");
    print(reviewdata);

    setState(() {});
  }

  void openMap() async {
    final double destinationLatitude = salonInfo["location"]["lat"];
    final double destinationLongitude = salonInfo["location"]["long"];
    final String label = salonInfo["salonName"];

    final String mapsUrl =
        'https://www.google.com/maps/dir/?api=1&destination=$destinationLatitude,$destinationLongitude';

    if (await canLaunch(mapsUrl)) {
      await launch(mapsUrl);
    } else {
      throw 'Could not open maps application.';
    }
  }

  void callSalon() async {
    final String call = 'tel:+91${salonInfo["contact"]}';

    if (await canLaunch(call)) {
      await launch(call);
    } else {
      throw 'Could not open maps application.';
    }
  }

  saveReview() async {
    if (info.text.isNotEmpty) {
      await addSalonReview(context, widget.bookingData["salonId"],
          widget.bookingData["id"], selectedRating, info.text);

      Navigator.of(context).pop();
    } else {
      Fluttertoast.showToast(msg: "Enter Name And Review");
    }
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        nextScreen(context, SalonInfoPage(salonData: salonInfo));
      },
      child: Container(
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
                Container(
                  width: 150,
                  height: 150,
                  decoration: BoxDecoration(
                      color: Colors.amber,
                      borderRadius: BorderRadius.circular(10),
                      image: DecorationImage(
                          image: NetworkImage(salonMedia != null
                              ? salonMedia["salonLogo"] ??
                                  "https://images.squarespace-cdn.com/content/v1/5b4818cdd274cba3ecbed6f9/de90d39c-1fca-48ba-93a8-7e6fb07fdd70/Salon+hero.jpg"
                              : "https://images.squarespace-cdn.com/content/v1/5b4818cdd274cba3ecbed6f9/de90d39c-1fca-48ba-93a8-7e6fb07fdd70/Salon+hero.jpg"),
                          fit: BoxFit.cover)),
                ),
                // Positioned(
                //     right: 2,
                //     bottom: 5,
                //     child: SizedBox(
                //         width: 50,
                //         height: 20,
                //         child: Container(
                //           decoration: BoxDecoration(
                //               color: Colors.yellow,
                //               borderRadius: BorderRadius.circular(10)),
                //           child: Row(
                //             children: [
                //               SizedBox(
                //                 width: 3,
                //               ),
                //               Icon(
                //                 Icons.stars,
                //                 color: primeColor,
                //                 size: 15,
                //               ),
                //               SizedBox(
                //                 width: 3,
                //               ),
                //               Text(
                //                 "4.8",
                //                 style: GoogleFonts.inter(
                //                     fontWeight: FontWeight.bold, fontSize: 12),
                //               )
                //             ],
                //           ),
                //         ))),
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
                      salonInfo != null ? salonInfo["salonName"] : "loading..",
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
                          status,
                          style: GoogleFonts.inter(
                              color: primeColor, fontWeight: FontWeight.bold),
                        )
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  // Container(
                  //   width: 200,
                  //   height: 20,
                  //   child: Row(
                  //     children: [
                  //       Icon(Icons.location_on_outlined),
                  //       SizedBox(
                  //         width: 10,
                  //       ),
                  //       Text(
                  //         "Nahatma road indor",
                  //         style: GoogleFonts.inter(
                  //           color: Colors.black,
                  //         ),
                  //       )
                  //     ],
                  //   ),
                  // ),

                  Container(
                    width: 200,
                    height: 20,
                    child: Row(
                      children: [
                        Icon(Icons.alarm),
                        SizedBox(
                          width: 10,
                        ),
                        Text(
                          "${widget.bookingData["selectedDate"]} ${widget.bookingData["bookedSlot"]}",
                          style: GoogleFonts.inter(
                              color: Colors.black, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),

                  SizedBox(
                    height: 10,
                  ),

                  isCompleted
                      ? reviewdata != null
                          ? Container(
                              child: Container(
                                width: 250,
                                height: 20,
                                child: RatingBar(
                                  ignoreGestures: true,
                                  initialRating: double.parse(
                                      reviewdata[0]["rating"].toString()),
                                  direction: Axis.vertical,
                                  allowHalfRating: false,
                                  glow: true,
                                  glowColor: Colors.white,
                                  glowRadius: 20,
                                  itemCount: 5,
                                  ratingWidget: RatingWidget(
                                    full: Icon(
                                      Icons.star,
                                      size: 10,
                                      color: Colors.amber,
                                    ),
                                    half: Icon(
                                      Icons.star,
                                      size: 10,
                                      color: Colors.amber,
                                    ),
                                    empty: Icon(
                                      Icons.star_border,
                                      color: Colors.grey,
                                      size: 10,
                                    ),
                                  ),
                                  onRatingUpdate: (rating) {
                                    print(rating);
                                    selectedRating = rating;
                                    setState(() {});
                                  },
                                ),
                              ),
                            )
                          : Container(
                              width: 120,
                              height: 30,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.black),
                                onPressed: () {
                                  showModalBottomSheet(
                                      context: context,
                                      isScrollControlled: true,
                                      enableDrag: true,
                                      showDragHandle: true,
                                      builder: (context) {
                                        return StatefulBuilder(
                                            builder: (context, mystate) {
                                          return Container(
                                            width: MediaQuery.of(context)
                                                .size
                                                .width,
                                            height: MediaQuery.of(context)
                                                .size
                                                .height,
                                            decoration: BoxDecoration(
                                                color: Colors.white,
                                                borderRadius: BorderRadius.only(
                                                    topLeft:
                                                        Radius.circular(30),
                                                    topRight:
                                                        Radius.circular(30))),
                                            child: Column(
                                              children: [
                                                Container(
                                                  child: Text(
                                                    "Review",
                                                    style: TextStyle(
                                                        color: Colors.black,
                                                        fontSize: 22),
                                                  ),
                                                ),
                                                Container(
                                                  child: Stack(
                                                    children: [
                                                      Container(
                                                        margin:
                                                            EdgeInsets.all(10),
                                                        decoration: BoxDecoration(
                                                            color:
                                                                Colors.yellow,
                                                            shape:
                                                                BoxShape.circle,
                                                            image: DecorationImage(
                                                                image: NetworkImage(
                                                                    "https://cdn-icons-png.flaticon.com/512/1804/1804155.png"),
                                                                fit: BoxFit
                                                                    .cover)),
                                                        width: 140,
                                                        height: 140,
                                                        clipBehavior:
                                                            Clip.hardEdge,
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                SizedBox(
                                                  height: 20,
                                                ),
                                                Container(
                                                  width: MediaQuery.of(context)
                                                      .size
                                                      .width,
                                                  height: 50,
                                                  alignment: Alignment.center,
                                                  child: Container(
                                                    width: 250,
                                                    height: 50,
                                                    alignment: Alignment.center,
                                                    child: RatingBar(
                                                      initialRating: 3,
                                                      direction: Axis.vertical,
                                                      allowHalfRating: false,
                                                      glow: true,
                                                      glowColor: Colors.white,
                                                      glowRadius: 20,
                                                      itemCount: 5,
                                                      ratingWidget:
                                                          RatingWidget(
                                                        full: Icon(
                                                          Icons.star,
                                                          size: 30,
                                                          color: Colors.amber,
                                                        ),
                                                        half: Icon(
                                                          Icons.star,
                                                          size: 30,
                                                          color: Colors.amber,
                                                        ),
                                                        empty: Icon(
                                                          Icons.star_border,
                                                          color: Colors.grey,
                                                          size: 30,
                                                        ),
                                                      ),
                                                      onRatingUpdate: (rating) {
                                                        print(rating);
                                                        selectedRating = rating;
                                                        setState(() {});

                                                        mystate(() {});
                                                      },
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(
                                                  height: 20,
                                                ),
                                                Container(
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.90,
                                                  height: 120,
                                                  padding: EdgeInsets.all(10),
                                                  decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              5),
                                                      color: Colors.white,
                                                      boxShadow: [
                                                        BoxShadow(
                                                            color:
                                                                Color.fromARGB(
                                                                    61,
                                                                    0,
                                                                    0,
                                                                    0),
                                                            blurRadius: 2.2,
                                                            offset:
                                                                Offset(0, 3),
                                                            spreadRadius: 0.2)
                                                      ]),
                                                  child: TextField(
                                                    controller: info,
                                                    maxLines: 7,
                                                    decoration: InputDecoration(
                                                        hintText: "Enter info"),
                                                  ),
                                                ),
                                                SizedBox(
                                                  height: 20,
                                                ),
                                                Container(
                                                  child: InkWell(
                                                    onTap: () {
                                                      if (info
                                                          .text.isNotEmpty) {
                                                        saveReview();
                                                      }
                                                    },
                                                    child: fullviewbtn(
                                                      inverse: true,
                                                      isDisabled:
                                                          info.text.isEmpty
                                                              ? true
                                                              : false,
                                                      text: "Submit",
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          );
                                        });
                                      });
                                },
                                child: Text(
                                  "Feedback",
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            )
                      : Container(
                          width: 200,
                          height: 30,
                          margin: EdgeInsets.only(left: 10),
                          child: Row(
                            children: [
                              ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                      backgroundColor: primeColor),
                                  onPressed: () {
                                    openMap();
                                  },
                                  child: Text(
                                    "Direction",
                                    style: TextStyle(color: Colors.white),
                                  )),
                              SizedBox(
                                width: 2,
                              ),
                              ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.black),
                                  onPressed: () {
                                    callSalon();
                                  },
                                  child: Text(
                                    "Call",
                                    style: TextStyle(color: Colors.white),
                                  )),
                            ],
                          ),
                        ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
