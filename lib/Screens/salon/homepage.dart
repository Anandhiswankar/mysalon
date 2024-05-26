import 'package:flutter/material.dart';
import 'package:mysalon/elements/color.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mysalon/elements/screenloader.dart';
import 'package:mysalon/services/auth/getUser.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mysalon/elements/appointmentcard.dart';
import 'package:mysalon/Screens/salon/bookinglist.dart';
import 'package:mysalon/Screens/salon/profilepage.dart';
import 'package:mysalon/Screens/salon/notification.dart';
import 'package:mysalon/Screens/salon/reviewscreen.dart';
import 'package:mysalon/Screens/salon/adsandservice.dart';
import 'package:mysalon/services/getData/getReviews.dart';
import 'package:mysalon/Screens/salon/bookappointment.dart';
import 'package:mysalon/services/utility/changeScreen.dart';
import 'package:mysalon/Screens/salon/managespecialist.dart';
import 'package:mysalon/services/notification/updatetoken.dart';
import 'package:mysalon/services/getData/getMySalonBooking.dart';
import 'package:mysalon/services/initDataloader/salonloader.dart';
import 'package:mysalon/Screens/salonRegister/registerSalonA.dart';

class SalonHomePage extends StatefulWidget {
  const SalonHomePage({super.key});

  @override
  State<SalonHomePage> createState() => _SalonHomePageState();
}

class _SalonHomePageState extends State<SalonHomePage> {
  bool loader = true;
  @override
  void initState() {
    super.initState();

    loadData();
  }

  var salonMedia = null;
  var salonInfo = null;

  double totalRating = 0;
  List<QueryDocumentSnapshot<dynamic>>? salonReview = null;

  int todaysCount = 0;
  int tomCount = 0;

  List<dynamic> todaysAppointment = [];

  loadRatings() async {
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

  loadData() async {
    updatetoken(context);

    salonMedia = await getSalonMedia(context);
    salonInfo = await getSalonInfo(context);

    await loadRatings();

    await loadBookingInfo();

    loader = false;
    setState(() {});
    print("Profile Image");
  }

  loadBookingInfo() async {
    var todayData = await getMySalonBooking("today");

    var tomData = await getMySalonBooking("tom");

    print("Appointment");
    todaysCount = todayData!.length;
    tomCount = tomData!.length;

    todaysAppointment = todayData;

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      bottomNavigationBar: Container(
        width: MediaQuery.of(context).size.width,
        height: 60,
        padding: EdgeInsets.only(left: 30, right: 30),
        color: Colors.white,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
                width: 35,
                height: 35,
                child: Icon(
                  Icons.home_outlined,
                  color: primeColor,
                  size: 35,
                )),
            InkWell(
              onTap: () {
                nextScreen(context, BookAppointment());
              },
              child: Container(
                  width: 35,
                  height: 35,
                  child: Icon(
                    Icons.calendar_month_outlined,
                    color: Color.fromARGB(255, 112, 112, 112),
                    size: 35,
                  )),
            ),
            InkWell(
              onTap: () {
                nextScreen(context, AdsAndService());
              },
              child: Container(
                  width: 35,
                  height: 35,
                  child: Icon(
                    Icons.local_offer_outlined,
                    color: Color.fromARGB(255, 112, 112, 112),
                    size: 35,
                  )),
            ),
            InkWell(
              onTap: () {
                nextScreen(context, ProfilePageSalonOwner());
              },
              child: Container(
                  width: 35,
                  height: 35,
                  child: Icon(
                    Icons.person_outline_outlined,
                    color: Color.fromARGB(255, 112, 112, 112),
                    size: 35,
                  )),
            )
          ],
        ),
      ),
      body: loader
          ? screenLoader()
          : Stack(
              children: [
                Container(
                  width: MediaQuery.of(context).size.width,
                  height: 250,
                  decoration: BoxDecoration(
                      color: Colors.black,
                      image: DecorationImage(
                          opacity: 0.7,
                          image: NetworkImage(salonMedia!["salonCover"] ??
                              "https://images.unsplash.com/photo-1560066984-138dadb4c035?q=80&w=1000&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8N3x8c2Fsb258ZW58MHx8MHx8fDA%3D"),
                          fit: BoxFit.cover)),
                ),
                Container(
                  width: MediaQuery.of(context).size.width,
                  height: 220,
                  alignment: Alignment.center,
                  child: CircleAvatar(
                    radius: 80,
                    backgroundColor: Colors.black,
                    backgroundImage: NetworkImage(salonMedia["salonLogo"] ??
                        "https://images.pexels.com/photos/2787341/pexels-photo-2787341.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1"),
                  ),
                ),
                InkWell(
                  onTap: () {
                    nextScreen(context, NotificationSalonOwner());
                  },
                  child: Container(
                    padding: EdgeInsets.only(right: 20),
                    width: MediaQuery.of(context).size.width,
                    height: 50,
                    alignment: Alignment.centerRight,
                    child: CircleAvatar(
                        backgroundColor: Colors.white,
                        radius: 15,
                        child: Icon(
                          Icons.notifications,
                          color: primeColor,
                        )),
                  ),
                ),
                Container(
                  alignment: Alignment.bottomCenter,
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                  child: Container(
                    margin: EdgeInsets.only(bottom: 10),
                    width: MediaQuery.of(context).size.width * 0.95,
                    height: MediaQuery.of(context).size.height * 0.65,
                    decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 232, 231, 231),
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
                          "Dashboard",
                          style: GoogleFonts.inter(
                              color: Colors.black, fontSize: 25),
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              width: 100,
                              height: 110,
                              padding: EdgeInsets.all(05),
                              decoration: BoxDecoration(
                                  border: Border.all(width: 1),
                                  color: primeColor,
                                  borderRadius: BorderRadius.circular(10)),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Text(
                                    "Salon",
                                    style: GoogleFonts.jetBrainsMono(
                                        color: Colors.white, fontSize: 15),
                                  ),
                                  Switch(
                                      inactiveTrackColor: Colors.white,
                                      activeTrackColor: Colors.white,
                                      activeColor: primeColor,
                                      inactiveThumbColor: Colors.black,
                                      value: salonInfo["isOpen"],
                                      onChanged: (e) {
                                        MarkSalonStatus(context, e);
                                        salonInfo["isOpen"] = e;
                                        setState(() {});
                                      }),
                                  Text(
                                    salonInfo["isOpen"] ? "Open" : "Closed",
                                    style: GoogleFonts.jetBrainsMono(
                                        color: Colors.white, fontSize: 15),
                                  ),
                                ],
                              ),
                            ),
                            InkWell(
                              onTap: () {
                                nextScreen(context, bookinglist());
                              },
                              child: Container(
                                width: 100,
                                height: 110,
                                padding: EdgeInsets.all(05),
                                decoration: BoxDecoration(
                                    border: Border.all(width: 1),
                                    color: primeColor,
                                    borderRadius: BorderRadius.circular(10)),
                                alignment: Alignment.center,
                                child: Column(
                                  children: [
                                    SizedBox(
                                      height: 20,
                                    ),
                                    Row(
                                      children: [
                                        Icon(
                                          Icons.calendar_month,
                                          color: Colors.white,
                                          size: 40,
                                        ),
                                        SizedBox(
                                          width: 5,
                                        ),
                                        Text(
                                          todaysCount.toString(),
                                          style: GoogleFonts.jetBrainsMono(
                                              color: Colors.white,
                                              fontSize: 25),
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      height: 15,
                                    ),
                                    Text(
                                      "Today",
                                      style: GoogleFonts.jetBrainsMono(
                                          color: Colors.white, fontSize: 15),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            InkWell(
                              onTap: () {
                                nextScreen(
                                    context,
                                    bookinglist(
                                      isTom: true,
                                    ));
                              },
                              child: Container(
                                width: 100,
                                height: 110,
                                padding: EdgeInsets.all(05),
                                decoration: BoxDecoration(
                                    border: Border.all(width: 1),
                                    color: primeColor,
                                    borderRadius: BorderRadius.circular(10)),
                                alignment: Alignment.center,
                                child: Column(
                                  children: [
                                    SizedBox(
                                      height: 20,
                                    ),
                                    Row(
                                      children: [
                                        Icon(
                                          Icons.calendar_month,
                                          color: Colors.white,
                                          size: 40,
                                        ),
                                        SizedBox(
                                          width: 5,
                                        ),
                                        Text(
                                          tomCount.toString(),
                                          style: GoogleFonts.jetBrainsMono(
                                              color: Colors.white,
                                              fontSize: 25),
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      height: 15,
                                    ),
                                    Text(
                                      "Tomorrow",
                                      style: GoogleFonts.jetBrainsMono(
                                          color: Colors.white, fontSize: 15),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        InkWell(
                          onTap: () {},
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              InkWell(
                                onTap: () {
                                  nextScreen(context, ReviewScreen());
                                },
                                child: Container(
                                  width: 100,
                                  height: 110,
                                  padding: EdgeInsets.all(05),
                                  decoration: BoxDecoration(
                                      border: Border.all(width: 1),
                                      color: primeColor,
                                      borderRadius: BorderRadius.circular(10)),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Icon(Icons.star_border,
                                              color: Colors.white),
                                          Icon(Icons.star_border,
                                              color: Colors.white),
                                          Icon(Icons.star_border,
                                              color: Colors.white),
                                        ],
                                      ),
                                      Text(
                                        salonReview == null
                                            ? "0"
                                            : (totalRating /
                                                    salonReview!.length)
                                                .toString(),
                                        style: GoogleFonts.jetBrainsMono(
                                            color: Colors.white, fontSize: 25),
                                      ),
                                      Text(
                                        "Rating",
                                        style: GoogleFonts.jetBrainsMono(
                                            color: Colors.white, fontSize: 15),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              InkWell(
                                onTap: () {
                                  nextScreen(context, ManageSpecialist());
                                },
                                child: Container(
                                  width: 100,
                                  height: 110,
                                  padding: EdgeInsets.all(05),
                                  decoration: BoxDecoration(
                                      border: Border.all(width: 1),
                                      color: primeColor,
                                      borderRadius: BorderRadius.circular(10)),
                                  alignment: Alignment.center,
                                  child: Column(
                                    children: [
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Icon(
                                            Icons.person,
                                            color: Colors.white,
                                            size: 50,
                                          ),
                                        ],
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Text(
                                        "Specialist",
                                        style: GoogleFonts.jetBrainsMono(
                                            color: Colors.white, fontSize: 13),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              InkWell(
                                onTap: () {
                                  nextScreen(
                                      context,
                                      registerSalonA(
                                        isUpdate: true,
                                      ));
                                },
                                child: Container(
                                  width: 100,
                                  height: 110,
                                  padding: EdgeInsets.all(05),
                                  decoration: BoxDecoration(
                                      border: Border.all(width: 1),
                                      color: primeColor,
                                      borderRadius: BorderRadius.circular(10)),
                                  alignment: Alignment.center,
                                  child: Column(
                                    children: [
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Icon(
                                            Icons.settings_suggest_rounded,
                                            color: Colors.white,
                                            size: 50,
                                          ),
                                        ],
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Text(
                                        "Services",
                                        style: GoogleFonts.jetBrainsMono(
                                            color: Colors.white, fontSize: 13),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 19,
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            SizedBox(
                                child: Text(
                              "Today's Appointment",
                              style: GoogleFonts.inter(
                                  color: Color.fromARGB(255, 57, 57, 57)),
                            )),
                            InkWell(
                              onTap: () {
                                nextScreen(context, bookinglist());
                              },
                              child: Text(
                                "View All",
                                style: GoogleFonts.inter(
                                    color: primeColor,
                                    fontWeight: FontWeight.bold),
                              ),
                            )
                          ],
                        ),
                        SizedBox(
                          height: 1,
                        ),
                        Container(
                            width: MediaQuery.of(context).size.width,
                            height: 180,
                            child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                shrinkWrap: true,
                                itemCount: todaysAppointment.length,
                                itemBuilder: (context, index) {
                                  return Container(
                                      width: MediaQuery.of(context).size.width *
                                          0.85,
                                      height: 180,
                                      child: AppointmentCard(
                                        bookingData: todaysAppointment[index],
                                      ));
                                })),
                      ],
                    ),
                  ),
                ),
              ],
            ),
    ));
  }
}
