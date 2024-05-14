import 'dart:ui';
import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import 'package:mysalon/elements/color.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mysalon/elements/lightlabel.dart';
import 'package:mysalon/elements/screenloader.dart';
import 'package:mysalon/Screens/user/mybooking.dart';
import 'package:mysalon/elements/citySalonCard.dart';
import 'package:mysalon/Screens/user/searchPage.dart';
import 'package:mysalon/Screens/user/profilepage.dart';
import 'package:mysalon/Screens/salon/notification.dart';
import 'package:mysalon/Screens/user/saloninfopage.dart';
import 'package:mysalon/services/utility/changeScreen.dart';
import 'package:mysalon/services/getData/getUserSlider.dart';
import 'package:mysalon/services/getData/getSameCitySalon.dart';
import 'package:mysalon/services/location/getlatloglocation.dart';
import 'package:flutter_image_slideshow/flutter_image_slideshow.dart';

// import 'package:mysalon/services/notification/updatetoken.dart'; //removed

class HomePageUser extends StatefulWidget {
  const HomePageUser({super.key});

  @override
  State<HomePageUser> createState() => _HomePageUserState();
}

class _HomePageUserState extends State<HomePageUser> {
  List<dynamic> slideShowImages = [
    "https://img.freepik.com/free-photo/interior-latino-hair-salon_23-2150555185.jpg",
  ];

  List<Widget> slideChild = [];

  int activePage = 0;

  var sortOption = [
    "maleicon.png",
    "femaleicon.png",
    "unisex.png",
    "distanceIcon.png",
    "distanceIcon.png"
  ];

  var sortOptionText = [
    "Male",
    "Female",
    "unisex",
    "Near 5km",
    "Near 10km",
  ];

  String mylocation = "loading..";

  List<Map<String, dynamic>>? SameCitySalon = [];

  bool salonLoading = true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    load();
  }

  load() async {
    // updatetoken(context); //removed

    SameCitySalon = await getSameCitySalon();

    salonLoading = false;

    var placeMark = await getAddressFromLocation();

    mylocation = placeMark.thoroughfare.toString() +
        " " +
        placeMark.subLocality.toString() +
        " " +
        placeMark.street.toString();

    setState(() {});

    var data = await getUserSlider();

    print("HOme page data");
    print(data);

    if (data != null) {
      slideShowImages.clear();

      slideShowImages.addAll(data);

      setState(() {});
    }

    if (slideShowImages.isNotEmpty) {
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

      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        bottomNavigationBar: Container(
          width: MediaQuery.of(context).size.width,
          height: 60,
          padding: EdgeInsets.all(10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(
                Icons.home_filled,
                size: 40,
                color: primeColor,
              ),
              InkWell(
                onTap: () {
                  nextScreen(context, SearchPage());
                },
                child: Icon(
                  Icons.search,
                  size: 40,
                  color: Colors.grey,
                ),
              ),
              InkWell(
                onTap: () {
                  nextScreen(context, MyBooking());
                },
                child: Icon(
                  Icons.calendar_month,
                  size: 40,
                  color: Colors.grey,
                ),
              ),
              InkWell(
                onTap: () {
                  nextScreen(context, ProfilePageUser());
                },
                child: Icon(
                  Icons.person,
                  size: 40,
                  color: Colors.grey,
                ),
              )
            ],
          ),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                width: MediaQuery.of(context).size.width,
                height: 90,
                alignment: Alignment.centerRight,
                child: Row(
                  children: [
                    Container(
                      alignment: Alignment.centerRight,
                      child: Column(
                        children: [
                          Container(
                            width: MediaQuery.of(context).size.width * 0.50,
                            alignment: Alignment.centerLeft,
                            margin: EdgeInsets.only(left: 10, top: 10),
                            child: Text(
                              "Location",
                              textAlign: TextAlign.right,
                              style: GoogleFonts.inter(color: Colors.black),
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(left: 10, top: 10),
                            alignment: Alignment.centerLeft,
                            child: Row(
                              children: [
                                Icon(
                                  Icons.location_on_outlined,
                                  color: primeColor,
                                  size: 30,
                                ),
                                Text(
                                  mylocation.length > 20
                                      ? "${mylocation.substring(0, 20)}..."
                                      : mylocation,
                                  style: GoogleFonts.inter(
                                      fontSize: 18,
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold),
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Spacer(),
                    InkWell(
                      onTap: () {
                        nextScreen(context, NotificationSalonOwner());
                      },
                      child: CircleAvatar(
                        radius: 20,
                        child: Icon(
                          Icons.notifications_outlined,
                          color: primeColor,
                          size: 25,
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 20,
                    ),
                  ],
                ),
              ),
              InkWell(
                onTap: () {
                  nextScreen(context, SearchPage());
                },
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.98,
                  child: Row(
                    children: [
                      Container(
                        margin: EdgeInsets.only(left: 10),
                        width: MediaQuery.of(context).size.width * 0.80,
                        height: 40,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            boxShadow: [
                              BoxShadow(
                                  color: Color.fromARGB(117, 144, 144, 144),
                                  spreadRadius: 2,
                                  blurRadius: 5,
                                  offset: Offset(0, 2))
                            ],
                            borderRadius: BorderRadius.circular(10),
                            border:
                                Border.all(width: 0.5, color: Colors.black)),
                        child: Row(
                          children: [
                            SizedBox(
                              width: 10,
                            ),
                            Icon(
                              Icons.search,
                              color: primeColor,
                              size: 30,
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Text("Search Salon")
                          ],
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                            boxShadow: [
                              BoxShadow(
                                  color: Color.fromARGB(117, 71, 71, 71),
                                  spreadRadius: 2,
                                  blurRadius: 5,
                                  offset: Offset(0, 2))
                            ],
                            color: primeColor,
                            borderRadius: BorderRadius.circular(10)),
                        child: Icon(
                          Icons.filter_alt_outlined,
                          color: Colors.white,
                          size: 30,
                        ),
                      )
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Container(
                width: MediaQuery.of(context).size.width * 0.95,
                height: 200,
                child: slideChild.isNotEmpty
                    ? ImageSlideshow(
                        width: MediaQuery.of(context).size.width,
                        height: 200,
                        initialPage: 0,
                        indicatorRadius: 0,
                        onPageChanged: (e) {
                          activePage = e;
                          setState(() {});
                        },
                        children: slideChild.toList())
                    : SizedBox(
                        child: screenLoader(),
                      ),
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
                      })),
              SizedBox(
                height: 5,
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                height: 40,
                alignment: Alignment.centerLeft,
                margin: EdgeInsets.only(left: 10),
                child: Text(
                  "Salons",
                  style: GoogleFonts.inter(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 20),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                height: 100,
                alignment: Alignment.center,
                child: ListView.builder(
                    itemCount: 5,
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context, index) {
                      return Container(
                        margin: EdgeInsets.all(5),
                        child: Column(
                          children: [
                            InkWell(
                              onTap: () {
                                switch (sortOptionText[index].toLowerCase()) {
                                  case "male":
                                    nextScreen(
                                        context,
                                        SearchPage(
                                          searchbyGender: true,
                                          searchByGender: "male",
                                        ));
                                    break;
                                  case "female":
                                    nextScreen(
                                        context,
                                        SearchPage(
                                          searchbyGender: true,
                                          searchByGender: "female",
                                        ));
                                    break;
                                  case "unisex":
                                    nextScreen(
                                        context,
                                        SearchPage(
                                          searchbyGender: true,
                                          searchByGender: "unisex",
                                        ));
                                    break;
                                  case "near 5km":
                                    nextScreen(
                                        context,
                                        SearchPage(
                                          searchbykm: true,
                                          searchkm: 5,
                                        ));
                                    break;
                                  case "near 10km":
                                    nextScreen(
                                        context,
                                        SearchPage(
                                          searchbykm: true,
                                          searchkm: 10,
                                        ));
                                    break;

                                  default:
                                    break;
                                }
                              },
                              child: CircleAvatar(
                                radius: 35,
                                backgroundColor: primeColor.withOpacity(0.5),
                                child: SizedBox(
                                  width: 40,
                                  height: 40,
                                  child: Image.asset(
                                      "assets/icons/" + sortOption[index]),
                                ),
                              ),
                            ),
                            Text(
                              sortOptionText[index],
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold),
                            )
                          ],
                        ),
                      );
                    }),
              ),
              SizedBox(
                height: 10,
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                height: 40,
                alignment: Alignment.centerLeft,
                margin: EdgeInsets.only(left: 10),
                child: Text(
                  "Top Salons in your city",
                  style: GoogleFonts.inter(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 20),
                ),
              ),
              SizedBox(
                height: 5,
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                height: 270,
                child: salonLoading
                    ? screenLoader()
                    : ListView.builder(
                        itemCount: SameCitySalon!.length,
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (context, index) {
                          return InkWell(
                            onTap: () {
                              nextScreen(
                                  context,
                                  SalonInfoPage(
                                    salonData: SameCitySalon![index],
                                  ));
                            },
                            child: CitySalonCard(
                              salondata: SameCitySalon![index],
                            ),
                          );
                        }),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
