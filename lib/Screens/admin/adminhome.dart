import 'package:flutter/material.dart';
import 'package:mysalon/elements/color.dart';
import 'package:mysalon/elements/alertbox.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mysalon/elements/lightlabel.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mysalon/services/auth/logout.dart';
import 'package:mysalon/elements/screenloader.dart';
import 'package:mysalon/services/auth/getUser.dart';
import 'package:mysalon/Screens/admin/payments.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mysalon/Screens/admin/adsRequest.dart';
import 'package:mysalon/Screens/admin/ListOfUser.dart';
import 'package:mysalon/Screens/admin/editBanner.dart';
import 'package:mysalon/Screens/admin/ListOfSalon.dart';
import 'package:mysalon/services/utility/changeScreen.dart';
import 'package:mysalon/Screens/admin/boookingSettings.dart';
import 'package:mysalon/services/getData/getadminstate.dart';
import 'package:mysalon/services/getData/getUserSlider.dart';
import 'package:mysalon/Screens/admin/appointmentbooked.dart';
import 'package:mysalon/elements/adminPanelcountingCard.dart';
import 'package:mysalon/services/notification/updatetoken.dart';
import 'package:mysalon/services/getData/getAdsRequestAndData.dart';
import 'package:flutter_image_slideshow/flutter_image_slideshow.dart';

class AdminHome extends StatefulWidget {
  const AdminHome({super.key});
  @override
  State<AdminHome> createState() => _AdminHomeState();
}

class _AdminHomeState extends State<AdminHome> {
  List<dynamic> slideShowImages = [
    "https://img.freepik.com/free-photo/interior-latino-hair-salon_23-2150555185.jpg",
    "https://shilpaahuja.com/wp-content/uploads/2019/04/top-salons-india-hair-coloring-costs-color-service-haircolor.jpg",
    "https://media.istockphoto.com/id/1271712634/photo/young-woman-looking-for-changes-trying-new-hairstyle-at-beauty-salon.jpg?s=612x612&w=0&k=20&c=Ylwrr2lDHn9F9y2lP5oFqc7CqzadLJAIcfWYx1l7Vjc="
  ];

  List<Widget> slideChild = [];

  int activePage = 0;
  int activeTab = 0;

  int adsRequestCount = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    load();
  }

  List<QueryDocumentSnapshot<dynamic>> userCount = [];
  List<dynamic> salonCount = [];
  List<dynamic>? bookingCount = [];
  List<QueryDocumentSnapshot<dynamic>> paymentCount = [];

  load() async {
    // updatetoken(context);  //removed
    var data = await getUserSlider();

    if (data != null) {
      slideShowImages.clear();
      slideShowImages.addAll(data);

      setState(() {});
    }

    for (int i = 0; i < slideShowImages.length; i++) {
      var wid = Container(
        margin: EdgeInsets.all(10),
        decoration: BoxDecoration(
            color: Colors.black,
            boxShadow: [
              BoxShadow(
                  blurRadius: 10,
                  spreadRadius: 1.5,
                  offset: Offset(0, 5),
                  color: Color.fromARGB(156, 61, 61, 61))
            ],
            borderRadius: BorderRadius.circular(20),
            image: DecorationImage(
                image: NetworkImage(slideShowImages[i]), fit: BoxFit.cover)),
      );

      slideChild.add(wid);
    }

    userCount = (await getAdminStateUser())!;
    salonCount = (await getAdminStateSalon())!;
    bookingCount = await getAdminStateBooking();
    paymentCount = (await getAdminStateRecipt())!;

    var dbt = await GetAllAdsRequestCount();

    if (dbt != null) {
      adsRequestCount = dbt.length;
      setState(() {});
    }

    setState(() {});
  }

  getAllState() async {
    alertBox(context);

    userCount = (await getAdminStateUser())!;
    salonCount = (await getAdminStateSalon())!;
    bookingCount = await getAdminStateBooking();
    paymentCount = (await getAdminStateRecipt())!;

    Navigator.of(context).pop();

    activeTab = 0;

    setState(() {});
  }

  getTodayState() async {
    alertBox(context);
    userCount = (await getAdminStateUserFilter())!;
    salonCount = (await getAdminStateSalonFilter())!;
    bookingCount = await getAdminStateBookingFilter();
    paymentCount = (await getAdminStateReciptFilter())!;

    Navigator.of(context).pop();

    activeTab = 1;

    setState(() {});
  }

  getThisMonthState() async {
    alertBox(context);
    userCount = (await getAdminStateUserFilter(isFilter: "thismonth"))!;
    salonCount = (await getAdminStateSalonFilter(isFilter: "thismonth"))!;
    bookingCount = await getAdminStateBookingFilter(isFilter: "thismonth");
    paymentCount = (await getAdminStateReciptFilter(isFilter: "thismonth"))!;

    Navigator.of(context).pop();

    activeTab = 2;

    print(userCount);

    setState(() {});
  }

  getSixMonthState() async {
    alertBox(context);
    userCount = (await getAdminStateUserFilter(isFilter: "6month"))!;
    salonCount = (await getAdminStateSalonFilter(isFilter: "6month"));
    bookingCount = await getAdminStateBookingFilter(isFilter: "6month");
    paymentCount = (await getAdminStateReciptFilter(isFilter: "6month"))!;

    Navigator.of(context).pop();

    activeTab = 3;

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                width: MediaQuery.of(context).size.width,
                height: 100,
                child: Row(
                  children: [
                    Container(
                      child: Column(
                        children: [
                          Container(
                              width: MediaQuery.of(context).size.width * 0.40,
                              margin: EdgeInsets.only(left: 10, top: 10),
                              alignment: Alignment.centerLeft,
                              child: Text("Admin")),
                          Row(
                            children: [
                              Icon(
                                Icons.admin_panel_settings,
                                color: primeColor,
                                size: 40,
                              ),
                              Text(
                                "Admin Name",
                                style: GoogleFonts.inter(
                                    color: Colors.black,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold),
                              )
                            ],
                          )
                        ],
                      ),
                    ),
                    Spacer(),
                    Container(
                      margin: EdgeInsets.only(right: 20),
                      child: CircleAvatar(
                        backgroundColor: primeColor.withOpacity(0.2),
                        child: Icon(
                          Icons.notifications,
                          color: primeColor,
                        ),
                      ),
                    )
                  ],
                ),
              ),
              Container(
                width: MediaQuery.of(context).size.width * 0.95,
                height: 200,
                child: slideChild.isEmpty
                    ? screenLoader()
                    : ImageSlideshow(
                        width: MediaQuery.of(context).size.width,
                        height: 200,
                        initialPage: 0,
                        indicatorRadius: 0,
                        onPageChanged: (e) {
                          activePage = e;
                          setState(() {});
                        },
                        children: slideChild.toList()),
              ),
              SizedBox(
                height: 5,
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                height: 30,
                alignment: Alignment.center,
                child: ListView.builder(
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                    itemCount: slideShowImages.length,
                    itemBuilder: (context, index) {
                      return Icon(
                        Icons.circle,
                        size: 15,
                        color: activePage == index ? primeColor : Colors.grey,
                      );
                    }),
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                height: 60,
                alignment: Alignment.center,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: primeColor,
                      foregroundColor: Colors.white,
                      textStyle: TextStyle(
                          color: const Color.fromARGB(255, 255, 255, 255))),
                  onPressed: () {
                    load();
                    nextScreen(context, EditBanner());
                  },
                  child: Text("Edit Banners"),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                height: 60,
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      InkWell(
                        onTap: () {
                          getAllState();
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            color: activeTab == 0 ? primeColor : Colors.white,
                          ),
                          padding: EdgeInsets.only(
                              left: 20, right: 20, top: 10, bottom: 10),
                          margin: EdgeInsets.all(5),
                          child: Text(
                            "All",
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 17),
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          getTodayState();
                        },
                        child: Container(
                          decoration: BoxDecoration(
                              boxShadow: [
                                BoxShadow(
                                    color: Color.fromARGB(102, 134, 134, 134),
                                    blurRadius: 2,
                                    spreadRadius: 2)
                              ],
                              borderRadius: BorderRadius.circular(5),
                              color:
                                  activeTab == 1 ? primeColor : Colors.white),
                          padding: EdgeInsets.only(
                              left: 20, right: 20, top: 10, bottom: 10),
                          margin: EdgeInsets.all(5),
                          child: Text(
                            "Today",
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 17),
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          getThisMonthState();
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            boxShadow: [
                              BoxShadow(
                                  color: Color.fromARGB(102, 134, 134, 134),
                                  blurRadius: 2,
                                  spreadRadius: 2)
                            ],
                            borderRadius: BorderRadius.circular(5),
                            color: activeTab == 2 ? primeColor : Colors.white,
                          ),
                          padding: EdgeInsets.only(
                              left: 20, right: 20, top: 10, bottom: 10),
                          margin: EdgeInsets.all(5),
                          child: Text(
                            "This Month",
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 17),
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          getSixMonthState();
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            boxShadow: [
                              BoxShadow(
                                  color: Color.fromARGB(102, 134, 134, 134),
                                  blurRadius: 2,
                                  spreadRadius: 2)
                            ],
                            borderRadius: BorderRadius.circular(5),
                            color: activeTab == 3 ? primeColor : Colors.white,
                          ),
                          padding: EdgeInsets.only(
                              left: 20, right: 20, top: 10, bottom: 10),
                          margin: EdgeInsets.all(5),
                          child: Text(
                            "Last 6 month",
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 17),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height * 0.35,
                child: Column(
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width * 0.85,
                      height: 150,
                      child: Row(
                        children: [
                          InkWell(
                            onTap: () {
                              if (userCount.isNotEmpty) {
                                nextScreen(
                                    context,
                                    ListOfUser(
                                      filtercode: activeTab,
                                    ));
                              }
                            },
                            child: AdminCardCountingCard(
                              label: "Users",
                              counter: userCount.length.toString(),
                              icons: Icons.group,
                            ),
                          ),
                          Spacer(),
                          InkWell(
                            onTap: () {
                              if (salonCount.isNotEmpty) {
                                nextScreen(
                                    context,
                                    ListOfSalons(
                                      filtercode: activeTab,
                                    ));
                              }
                            },
                            child: AdminCardCountingCard(
                              label: "Salons",
                              counter: salonCount!.length.toString(),
                              icons: Icons.store_mall_directory_outlined,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width * 0.85,
                      height: 150,
                      child: Row(
                        children: [
                          InkWell(
                            onTap: () {
                              nextScreen(
                                  context,
                                  Appointmentbooked(
                                    bookingData: bookingCount,
                                  ));
                            },
                            child: AdminCardCountingCard(
                              label: "Booking",
                              counter: bookingCount!.length.toString(),
                              icons: Icons.calendar_month_outlined,
                            ),
                          ),
                          Spacer(),
                          InkWell(
                            onTap: () {
                              nextScreen(
                                  context,
                                  paymentPage(
                                    paymentData: paymentCount,
                                  ));
                            },
                            child: AdminCardCountingCard(
                              label: "Payment",
                              counter: paymentCount!.length.toString(),
                              icons: Icons.monetization_on,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              lightLabel(label: "Advance Settings"),
              SizedBox(
                height: 10,
              ),
              Container(
                width: MediaQuery.of(context).size.width * 0.95,
                height: 80 * 4,
                child: Column(
                  children: [
                    InkWell(
                      onTap: () {
                        nextScreen(context, AdsRequest());
                      },
                      child: Container(
                        width: MediaQuery.of(context).size.width * 0.90,
                        height: 70,
                        color: primeColor,
                        child: Row(
                          children: [
                            SizedBox(
                              width: 10,
                            ),
                            Icon(
                              Icons.ads_click_rounded,
                              size: 30,
                              color: Colors.white,
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Text(
                              "Ads Request",
                              style: GoogleFonts.inter(
                                  color: Colors.white, fontSize: 20),
                            ),
                            Spacer(),
                            CircleAvatar(
                              backgroundColor: Colors.black,
                              radius: 15,
                              child: Text(
                                adsRequestCount.toString(),
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                            SizedBox(
                              width: 10,
                            )
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    InkWell(
                      onTap: () {
                        nextScreen(context, BookingSettings());
                      },
                      child: Container(
                        width: MediaQuery.of(context).size.width * 0.90,
                        height: 70,
                        color: primeColor,
                        child: Row(
                          children: [
                            SizedBox(
                              width: 10,
                            ),
                            Icon(
                              Icons.calendar_month_outlined,
                              size: 30,
                              color: Colors.white,
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Text(
                              "Booking Settings",
                              style: GoogleFonts.inter(
                                  color: Colors.white, fontSize: 20),
                            ),
                            Spacer(),
                            SizedBox(
                              width: 10,
                            )
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    // Container(
                    //   width: MediaQuery.of(context).size.width * 0.90,
                    //   height: 70,
                    //   color: primeColor,
                    //   child: Row(
                    //     children: [
                    //       SizedBox(
                    //         width: 10,
                    //       ),
                    //       Icon(
                    //         Icons.local_offer_sharp,
                    //         size: 30,
                    //         color: Colors.white,
                    //       ),
                    //       SizedBox(
                    //         width: 10,
                    //       ),
                    //       Text(
                    //         "Salon Type & Others",
                    //         style: GoogleFonts.inter(
                    //             color: Colors.white, fontSize: 20),
                    //       ),
                    //       Spacer(),
                    //       SizedBox(
                    //         width: 10,
                    //       )
                    //     ],
                    //   ),
                    // ),
                    // SizedBox(
                    //   height: 10,
                    // ),
                    InkWell(
                      onTap: () {
                        logoutUser(context);
                      },
                      child: Container(
                        width: MediaQuery.of(context).size.width * 0.90,
                        height: 70,
                        color: primeColor,
                        child: Row(
                          children: [
                            SizedBox(
                              width: 10,
                            ),
                            Icon(
                              Icons.person,
                              size: 30,
                              color: Colors.white,
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Text(
                              "Logout",
                              style: GoogleFonts.inter(
                                  color: Colors.white, fontSize: 20),
                            ),
                            Spacer(),
                            SizedBox(
                              width: 10,
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 20,
              )
            ],
          ),
        ),
      ),
    );
  }
}
