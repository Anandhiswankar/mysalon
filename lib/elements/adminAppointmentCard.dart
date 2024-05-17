import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:mysalon/elements/color.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:mysalon/services/getData/getUserById.dart';
import 'package:mysalon/services/initDataloader/salonloader.dart';

class AppointmentCardAdmin extends StatefulWidget {
  final dynamic bookingData;
  const AppointmentCardAdmin({super.key, this.bookingData});

  @override
  State<AppointmentCardAdmin> createState() => _AppointmentCardAdminState();
}

class _AppointmentCardAdminState extends State<AppointmentCardAdmin> {
  List<String> solonOffers = [
    'Haircut',
    'Hairstyling',
  ];

  dynamic userdata = {};
  dynamic salonData = {};

  String status = "loading..";

  @override
  void initState() {
    super.initState();

    loadData();
  }

  loadData() async {
    print(widget.bookingData);

    userdata = await getUserById(widget.bookingData["userId"]);

    salonData = await getSalonInfobyId(context, widget.bookingData["salonId"]);

    setState(() {});

    String combinedStr =
        "${widget.bookingData["selectedDate"]} ${widget.bookingData["bookedSlot"]}";

    // Define the date format
    DateFormat dateFormat = DateFormat("dd-MM-yyyy hh:mm a");

    // Parse the combined string into a DateTime object
    DateTime dateTime = dateFormat.parse(combinedStr);

    if (dateTime.isBefore(DateTime.now())) {
      status = "Completed";
    } else {
      status = "pending";
    }

    solonOffers = widget.bookingData["selectedServices"];

    setState(() {});
  }

  void callUser() async {
    final String call = 'tel:+91${widget.bookingData["mobile"]}';

    if (await canLaunch(call)) {
      await launch(call);
    } else {
      throw 'Could not open maps application.';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 220,
      decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
                offset: Offset(0, 3),
                spreadRadius: 2,
                blurRadius: 10,
                color: Color.fromARGB(138, 142, 142, 142))
          ],
          borderRadius: BorderRadius.circular(10)),
      margin: EdgeInsets.all(10),
      child: Column(
        children: [
          Container(
            width: MediaQuery.of(context).size.width * 90,
            height: 150,
            padding: EdgeInsets.all(10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  backgroundColor: Colors.black,
                  radius: 45,
                  backgroundImage: NetworkImage(userdata["profile"] ??
                      "https://images.pexels.com/photos/1689731/pexels-photo-1689731.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1"),
                ),
                SizedBox(
                  width: 10,
                ),
                Expanded(
                  child: Column(
                    children: [
                      Container(
                        child: Row(
                          children: [
                            const Text("Time:"),
                            const SizedBox(
                              width: 10,
                            ),
                            Text(
                              widget.bookingData["bookedSlot"].toString() ?? "",
                              style: GoogleFonts.inter(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold),
                            )
                          ],
                        ),
                      ),
                      Container(
                        child: Row(
                          children: [
                            Text("Name:"),
                            SizedBox(
                              width: 10,
                            ),
                            Text(
                              widget.bookingData["name"].toString() ?? "",
                              style: GoogleFonts.inter(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold),
                            )
                          ],
                        ),
                      ),
                      Container(
                        child: Row(
                          children: [
                            Text("Specialist:"),
                            SizedBox(
                              width: 10,
                            ),
                            Text(
                              widget.bookingData["selectedSpecialist"]["name"]
                                      .toString() ??
                                  "",
                              style: GoogleFonts.inter(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold),
                            )
                          ],
                        ),
                      ),
                      Container(
                        child: Row(
                          children: [
                            Text(
                              "Status:",
                              textAlign: TextAlign.start,
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Text(
                              status,
                              style: GoogleFonts.inter(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold),
                            )
                          ],
                        ),
                      ),
                      salonData == null
                          ? SizedBox()
                          : Container(
                              child: Row(
                                children: [
                                  Text(
                                    "Salon:",
                                    textAlign: TextAlign.start,
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Text(
                                    salonData["name"] ?? "",
                                    style: GoogleFonts.inter(
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold),
                                  )
                                ],
                              ),
                            ),
                      Container(
                        child: Row(
                          children: [
                            Text(
                              "Date:",
                              textAlign: TextAlign.start,
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Text(
                              widget.bookingData["selectedDate"].toString(),
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
                // Container(
                //   height: 200,
                //   alignment: Alignment.center,
                //   child: Column(
                //     mainAxisAlignment: MainAxisAlignment.center,
                //     crossAxisAlignment: CrossAxisAlignment.center,
                //     children: [
                //       CircleAvatar(
                //         radius: 16,
                //         backgroundColor: const Color.fromARGB(255, 36, 44, 36),
                //         child: Icon(
                //           Icons.check,
                //           color: Colors.white,
                //         ),
                //       ),
                //       SizedBox(
                //         height: 10,
                //       ),
                //       CircleAvatar(
                //         radius: 16,
                //         backgroundColor: primeColor,
                //         child: Icon(Icons.close, color: Colors.white),
                //       )
                //     ],
                //   ),
                // ),
              ],
            ),
          ),
          Container(
            width: MediaQuery.of(context).size.width,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: primeColor,
                        foregroundColor: Colors.white),
                    onPressed: () {
                      showModalBottomSheet(
                          showDragHandle: true,
                          enableDrag: true,
                          context: context,
                          builder: (context) {
                            return Container(
                              width: MediaQuery.of(context).size.width,
                              height: MediaQuery.of(context).size.height * 0.59,
                              child: Column(
                                children: [
                                  Text(
                                    "Services",
                                    style: GoogleFonts.inter(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20),
                                  ),
                                  SizedBox(
                                    height: 20,
                                  ),
                                  Container(
                                    width: MediaQuery.of(context).size.width *
                                        0.96,
                                    height: MediaQuery.of(context).size.height *
                                        0.40,
                                    child: SingleChildScrollView(
                                      child: Wrap(
                                        spacing: 8.0,
                                        runSpacing: 8.0,
                                        children: solonOffers.map((day) {
                                          return InkWell(
                                            onTap: () {
                                              // if (solonOffersSelected.contains(day)) {
                                              //   solonOffersSelected.remove(day);
                                              // } else {
                                              //   solonOffersSelected.add(day);
                                              // }

                                              setState(() {});
                                            },
                                            child: Chip(
                                              label: Text(day),
                                              avatar: Icon(
                                                true
                                                    ? Icons.circle
                                                    : Icons.circle_outlined,
                                                color: Colors.white,
                                              ),
                                              elevation: 2.0,
                                              backgroundColor: primeColor,
                                              labelStyle: TextStyle(
                                                  color: Colors.white),
                                            ),
                                          );
                                        }).toList(),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          });
                    },
                    child: Text("Services")),
                SizedBox(
                  width: 10,
                ),
                ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: primeColor,
                        foregroundColor: Colors.white),
                    onPressed: () {
                      callUser();
                    },
                    child: Text("Call"))
              ],
            ),
          ),
        ],
      ),
    );
  }
}
