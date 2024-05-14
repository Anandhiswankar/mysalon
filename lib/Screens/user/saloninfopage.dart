import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:mysalon/elements/color.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:mysalon/elements/timeparse.dart';
import 'package:mysalon/elements/lightlabel.dart';
import 'package:mysalon/elements/reviewcard.dart';
import 'package:mysalon/elements/specialist.dart';
import 'package:mysalon/elements/fullviewbtn.dart';
import 'package:mysalon/elements/screenloader.dart';
import 'package:mysalon/elements/getNormalDate.dart';
import 'package:mysalon/elements/locationmodel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mysalon/services/saveData/addtoFav.dart';
import 'package:mysalon/services/getData/getReviews.dart';
import 'package:mysalon/services/getData/getUserById.dart';
import 'package:mysalon/Screens/user/bookAppointmentA.dart';
import 'package:mysalon/services/utility/changeScreen.dart';
import 'package:mysalon/services/saveData/disableSalon.dart';
import 'package:mysalon/services/initDataloader/salonloader.dart';
import 'package:mysalon/services/location/calculateDIstance.dart';
import 'package:mysalon/services/location/getlatloglocation.dart';
import 'package:flutter_image_slideshow/flutter_image_slideshow.dart';

// import 'package:firebase_messaging/firebase_messaging.dart';

class SalonInfoPage extends StatefulWidget {
  final Map<String, dynamic> salonData;
  bool isAdmin;
  SalonInfoPage({super.key, required this.salonData, this.isAdmin = false});

  @override
  State<SalonInfoPage> createState() => _SalonInfoPageState();
}

class _SalonInfoPageState extends State<SalonInfoPage> {
  List<dynamic> slideShowImages = [
    "https://img.freepik.com/free-photo/interior-latino-hair-salon_23-2150555185.jpg",
    "https://shilpaahuja.com/wp-content/uploads/2019/04/top-salons-india-hair-coloring-costs-color-service-haircolor.jpg",
    "https://media.istockphoto.com/id/1271712634/photo/young-woman-looking-for-changes-trying-new-hairstyle-at-beauty-salon.jpg?s=612x612&w=0&k=20&c=Ylwrr2lDHn9F9y2lP5oFqc7CqzadLJAIcfWYx1l7Vjc="
  ];

  List<Widget> slideChild = [];

  int activePage = 0;

  dynamic userData = {};

  @override
  void initState() {
    super.initState();

    getminLocation();

    load();
  }

  var distance = 0.0;

  double totalRating = 0;

  double totalReview = 0.0;

  var salonImages = {};

  List<QueryDocumentSnapshot<dynamic>>? salonReview = [];

  Map<String, dynamic> salonTypes = {};

  Map<String, dynamic> salonSpecialist = {};

  var isFave = false;

  bool isEnable = false;

  getminLocation() async {
    var mycity = await getlatlongLocation();

    var salonLocation = widget.salonData["location"];

    Location loc1 = new Location(mycity["lat"], mycity["long"]);

    Location loc2 = new Location(salonLocation["lat"], salonLocation["long"]);

    distance = calculateDistance(loc1, loc2);
    print("Salon Distance is:");
    print(distance);

    salonReview = await getSalonReviewsById(widget.salonData["id"]);

    if (salonReview != null) {
      for (int i = 0; i < salonReview!.length; i++) {
        totalRating += salonReview![i].data()["rating"];
      }

      totalReview = totalRating / salonReview!.length;
    }

    salonTypes = await getSalonServicesbyId(context, widget.salonData["id"]);

    salonSpecialist =
        await getSalonSpecialistByid(context, widget.salonData["id"]);

    setState(() {});
  }

  String statusMessage = "";

  load() async {
    salonImages = await getSalonMediaById(context, widget.salonData["id"]);

    slideShowImages.clear();
    slideShowImages = salonImages["Slider"];

    setState(() {});

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

      TimeOfDay currentTime = TimeOfDay.now();

      // Parse salon open and close times from decimal numbers to TimeOfDay objects
      TimeOfDay openTime = parseTime(widget.salonData["openTime"].toString());
      TimeOfDay closeTime = parseTime(widget.salonData["closeTime"].toString());

      // Check if the current time is within the open and close times
      bool isOpen = currentTime.hour > openTime.hour ||
          (currentTime.hour == openTime.hour &&
              currentTime.minute >= openTime.minute);
      bool isClosed = currentTime.hour < closeTime.hour ||
          (currentTime.hour == closeTime.hour &&
              currentTime.minute <= closeTime.minute);

      statusMessage =
          isOpen && isClosed && widget.salonData["isOpen"] ? "Open" : "Closed";

      setState(() {});
    }

    isFave = await checkSalonifFav(widget.salonData["id"]);

    userData = await getUserById(widget.salonData["id"]);

    if (userData != null) {
      isEnable = userData["isEnable"];
      setState(() {});
    }

    setState(() {});
  }

  Future<void> _launchURL() async {
    String url = "https://" + widget.salonData["salonWebsite"];
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  void openMap() async {
    final double destinationLatitude = widget.salonData["location"]["lat"];
    final double destinationLongitude = widget.salonData["location"]["long"];
    final String label = widget.salonData["salonName"];

    final String mapsUrl =
        'https://www.google.com/maps/dir/?api=1&destination=$destinationLatitude,$destinationLongitude';

    if (await canLaunch(mapsUrl)) {
      await launch(mapsUrl);
    } else {
      throw 'Could not open maps application.';
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      bottomNavigationBar: Container(
        width: MediaQuery.of(context).size.width,
        height: 70,
        alignment: Alignment.center,
        child: Container(
          width: MediaQuery.of(context).size.width * 0.50,
          child: InkWell(
            onTap: () {
              nextScreen(
                  context,
                  BookAppointmentA(
                    data: widget.salonData,
                  ));
            },
            child: fullviewbtn(
              text: "Book now",
              inverse: true,
              isDisabled: false,
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: 10,
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              height: 320,
              child: Stack(
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width,
                    height: 250,
                    alignment: Alignment.center,
                    child: Container(
                      width: MediaQuery.of(context).size.width * 0.95,
                      height: 250,
                      decoration: BoxDecoration(
                          color: Colors.amber,
                          borderRadius: BorderRadius.circular(20),
                          image: DecorationImage(
                              image: NetworkImage(salonImages["salonCover"] ??
                                  "https://images.squarespace-cdn.com/content/v1/5b4818cdd274cba3ecbed6f9/de90d39c-1fca-48ba-93a8-7e6fb07fdd70/Salon+hero.jpg"),
                              fit: BoxFit.cover)),
                    ),
                  ),
                  Positioned(
                      right: 20,
                      top: 5,
                      child: SizedBox(
                          width: 55,
                          height: 30,
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
                                  size: 20,
                                ),
                                SizedBox(
                                  width: 3,
                                ),
                                Text(
                                  totalReview.toString(),
                                  style: GoogleFonts.inter(
                                      fontWeight: FontWeight.bold),
                                )
                              ],
                            ),
                          ))),
                  Positioned(
                      bottom: 0,
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        height: 180,
                        alignment: Alignment.center,
                        child: Container(
                          width: 170,
                          height: 170,
                          decoration: BoxDecoration(
                              boxShadow: [
                                BoxShadow(
                                    color: Color.fromARGB(143, 84, 84, 84),
                                    spreadRadius: 2.0,
                                    blurRadius: 2)
                              ],
                              image: DecorationImage(
                                  image: NetworkImage(salonImages[
                                          "salonLogo"] ??
                                      "https://cdn.dribbble.com/users/2984251/screenshots/16200026/media/5f404ede522388e2e56976dad9c265f1.jpg?resize=400x300&vertical=center"),
                                  fit: BoxFit.cover),
                              shape: BoxShape.circle,
                              color: Colors.yellow),
                        ),
                      ))
                ],
              ),
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              margin: EdgeInsets.only(left: 20, top: 10),
              child: Text(
                widget.salonData["salonName"] ?? "loading..",
                style: GoogleFonts.inter(
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                    fontSize: 25),
              ),
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              margin: EdgeInsets.only(left: 20, top: 20),
              child: Row(
                children: [
                  Icon(
                    Icons.shopping_basket_outlined,
                    color: primeColor,
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Text(
                    "${convertToHourFormat(widget.salonData["openTime"])} - ${convertToHourFormat(widget.salonData["closeTime"])}",
                    style: GoogleFonts.inter(color: Colors.black, fontSize: 20),
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  Text(
                    statusMessage.toString(),
                    style: GoogleFonts.inter(
                      color: primeColor,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              margin: EdgeInsets.only(left: 20, top: 10),
              child: Row(
                children: [
                  Icon(
                    Icons.social_distance_sharp,
                    color: primeColor,
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Text(
                    "${distance.toStringAsFixed(2)} km",
                    style: GoogleFonts.inter(color: Colors.black, fontSize: 20),
                  ),
                ],
              ),
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              margin: EdgeInsets.only(left: 20, top: 10),
              child: Row(
                children: [
                  Icon(
                    Icons.boy_rounded,
                    color: primeColor,
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Text(
                    widget.salonData["salonFor"] == 1
                        ? "Male"
                        : widget.salonData["salonFor"] == 2
                            ? "Female"
                            : "Unisex",
                    style: GoogleFonts.inter(color: Colors.black, fontSize: 20),
                  ),
                ],
              ),
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              margin: EdgeInsets.only(left: 20, top: 10),
              child: Row(
                children: [
                  Icon(
                    Icons.store_mall_directory_outlined,
                    color: primeColor,
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  salonTypes.isEmpty
                      ? Text("loading..")
                      : Text(
                          "${salonTypes["salonType"][0]},${salonTypes.length >= 1 ? salonTypes["salonType"][1] : ''}...",
                          style: GoogleFonts.inter(
                              color: Colors.black, fontSize: 20),
                        ),
                ],
              ),
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              margin: EdgeInsets.only(left: 20, top: 10),
              child: Row(
                children: [
                  Icon(
                    Icons.location_on_outlined,
                    color: primeColor,
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.80,
                    child: Text(
                      widget.salonData["fetchAddr"] ?? "loading..",
                      style:
                          GoogleFonts.inter(color: Colors.black, fontSize: 20),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Container(
              margin: EdgeInsets.all(10),
              width: MediaQuery.of(context).size.width * 0.70,
              alignment: Alignment.center,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  InkWell(
                    onTap: () {
                      _launchURL();
                    },
                    child: CircleAvatar(
                        radius: 30,
                        backgroundColor: primeColor,
                        child: Icon(
                          Icons.link,
                          color: Colors.white,
                          size: 30,
                        )),
                  ),
                  InkWell(
                    onTap: () {
                      openMap();
                    },
                    child: CircleAvatar(
                        radius: 30,
                        backgroundColor: primeColor,
                        child: Icon(
                          Icons.directions,
                          color: Colors.white,
                          size: 30,
                        )),
                  ),
                  InkWell(
                    onTap: () async {
                      await addsalontoFav(context, widget.salonData["id"]);

                      isFave = await checkSalonifFav(widget.salonData["id"]);
                      setState(() {});
                    },
                    child: CircleAvatar(
                        radius: 30,
                        backgroundColor: primeColor,
                        child: Icon(
                          isFave ? Icons.favorite : Icons.favorite_outline,
                          color: Colors.white,
                          size: 30,
                        )),
                  ),
                  widget.isAdmin
                      ? InkWell(
                          onTap: () async {
                            disableSalonStatus(
                                context, widget.salonData["id"], !isEnable);
                            isEnable = !isEnable;
                            setState(() {});
                          },
                          child: CircleAvatar(
                              radius: 30,
                              backgroundColor: primeColor,
                              child: Icon(
                                isEnable
                                    ? Icons.visibility
                                    : Icons.visibility_off,
                                color: Colors.white,
                                size: 30,
                              )),
                        )
                      : SizedBox()
                ],
              ),
            ),
            SizedBox(
              height: 10,
            ),
            lightLabel(
              label: "About Salon",
              fontSize: 20,
            ),
            SizedBox(
              height: 10,
            ),
            Container(
              width: MediaQuery.of(context).size.width * 0.95,
              child: SizedBox(child: Text(widget.salonData["salonInfo"])),
            ),
            SizedBox(
              height: 20,
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
            SizedBox(
              height: 20,
            ),
            lightLabel(label: "Our Services"),
            salonTypes.isEmpty
                ? Text("No Services Found")
                : Container(
                    width: MediaQuery.of(context).size.width,
                    height: (25 *
                            (salonTypes["salonOffer"] as List<dynamic>).length)
                        .toDouble(),
                    margin: EdgeInsets.only(left: 10),
                    child: ListView.builder(
                        itemCount:
                            (salonTypes["salonOffer"] as List<dynamic>).length,
                        physics: NeverScrollableScrollPhysics(),
                        itemBuilder: (context, index) {
                          return Text(
                            index.toString() +
                                ". " +
                                (salonTypes["salonOffer"]
                                    as List<dynamic>)[index],
                            style: GoogleFonts.inter(fontSize: 16),
                          );
                        }),
                  ),
            SizedBox(
              height: 10,
            ),
            lightLabel(label: "Our Specialist"),
            salonSpecialist.isEmpty
                ? Text("No Specialist")
                : Container(
                    width: MediaQuery.of(context).size.width,
                    height:
                        (150 * salonSpecialist["specialist"].length).toDouble(),
                    margin: EdgeInsets.only(left: 10),
                    child: ListView.builder(
                        itemCount: salonSpecialist["specialist"].length,
                        physics: NeverScrollableScrollPhysics(),
                        itemBuilder: (context, index) {
                          return Container(
                              margin: EdgeInsets.all(10),
                              child: SpecialistCard(
                                name: salonSpecialist["specialist"][index]
                                    ["name"],
                                info: salonSpecialist["specialist"][index]
                                    ["info"],
                                profile: salonSpecialist["specialist"][index]
                                    ["profile"],
                                showEditIcon: false,
                              ));
                        }),
                  ),
            SizedBox(
              height: 10,
            ),
            lightLabel(label: "Client Review"),
            salonReview == null
                ? Text("No Reviews")
                : Container(
                    width: MediaQuery.of(context).size.width,
                    height: (170 * salonReview!.length).toDouble(),
                    margin: EdgeInsets.only(left: 10),
                    child: ListView.builder(
                        itemCount: salonReview!.length,
                        physics: NeverScrollableScrollPhysics(),
                        itemBuilder: (context, index) {
                          return Container(
                              margin: EdgeInsets.all(10),
                              child: ReviewCard(
                                reviewObject: salonReview![index],
                              ));
                        }),
                  ),
          ],
        ),
      ),
    ));
  }
}
