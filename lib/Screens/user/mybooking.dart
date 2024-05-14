import 'dart:ffi';
import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:mysalon/elements/color.dart';
import 'package:mysalon/elements/topbar.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mysalon/elements/lightlabel.dart';
import 'package:mysalon/elements/screenloader.dart';
import 'package:mysalon/elements/salonCardland.dart';
import 'package:mysalon/elements/custominputbox.dart';
import 'package:mysalon/elements/salonappointmentcard.dart';
import 'package:mysalon/services/getData/getMybooking.dart';
import 'package:mysalon/services/initDataloader/salonloader.dart';

class MyBooking extends StatefulWidget {
  const MyBooking({super.key});

  @override
  State<MyBooking> createState() => _MyBookingState();
}

class _MyBookingState extends State<MyBooking> {
  TextEditingController search = TextEditingController();

  double selectedSort = 1.0;

  @override
  void initState() {
    super.initState();

    loadData();
  }

  List<dynamic>? mybookingdata = [];

  dynamic salonData;
  dynamic salonMedia;

  loadData() async {
    mybookingdata = await getMyBooking();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: mybookingdata == null
              ? screenLoader()
              : Column(
                  children: [
                    TopBarLabel(label: "My Booking"),
                    SizedBox(
                      height: 10,
                    ),
                    // Container(
                    //   width: MediaQuery.of(context).size.width,
                    //   height: 60,
                    //   padding: EdgeInsets.all(5),
                    //   child: SingleChildScrollView(
                    //     scrollDirection: Axis.horizontal,
                    //     child: Row(
                    //       children: [
                    //         ElevatedButton(
                    //             style: ElevatedButton.styleFrom(
                    //                 backgroundColor: Colors.black,
                    //                 foregroundColor: Colors.white),
                    //             onPressed: () {},
                    //             child: Text("All")),
                    //         SizedBox(
                    //           width: 10,
                    //         ),
                    //         ElevatedButton(
                    //             style: ElevatedButton.styleFrom(
                    //                 backgroundColor: primeColor,
                    //                 foregroundColor: Colors.white),
                    //             onPressed: () {},
                    //             child: Text("Pending")),
                    //         SizedBox(
                    //           width: 10,
                    //         ),
                    //         ElevatedButton(
                    //             style: ElevatedButton.styleFrom(
                    //                 backgroundColor: primeColor,
                    //                 foregroundColor: Colors.white),
                    //             onPressed: () {},
                    //             child: Text("Upcomming")),
                    //         SizedBox(
                    //           width: 10,
                    //         ),
                    //         true
                    //             ? ElevatedButton(
                    //                 style: ElevatedButton.styleFrom(
                    //                     backgroundColor: primeColor,
                    //                     foregroundColor: Colors.white),
                    //                 onPressed: () {},
                    //                 child: Text("Completed"))
                    //             : SizedBox()
                    //       ],
                    //     ),
                    //   ),
                    // ),
                    Container(
                      width: MediaQuery.of(context).size.width,
                      height: (170 * mybookingdata!.length).toDouble(),
                      child: ListView.builder(
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: mybookingdata!.length,
                          itemBuilder: (context, index) {
                            return SalonAppointmentCard(
                              isDone: mybookingdata![index]["isDone"],
                              isRevied: index <= 5,
                              bookingData: mybookingdata![index],
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
