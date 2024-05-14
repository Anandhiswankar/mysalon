import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import 'package:mysalon/elements/color.dart';
import 'package:mysalon/elements/topbar.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mysalon/elements/screenloader.dart';
import 'package:mysalon/elements/appointmentcard.dart';
import 'package:mysalon/services/getData/getMySalonBooking.dart';

class bookinglist extends StatefulWidget {
  bool isTom;
  bookinglist({super.key, this.isTom = false});

  @override
  State<bookinglist> createState() => _bookinglistState();
}

class _bookinglistState extends State<bookinglist> {
  List<dynamic>? todaysAppointment = [];

  @override
  void initState() {
    super.initState();
    loadData();
  }

  loadData() async {
    setState(() {});

    if (widget.isTom) {
      todaysAppointment = await getMySalonBooking("tom");
    } else {
      todaysAppointment = await getMySalonBooking("today");
    }

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            TopBarLabel(
                label: !widget.isTom
                    ? "Today's Appointment"
                    : "Tomorrow Appointment"),
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
            //         !widget.isTom
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
            Expanded(
              child: Container(
                child: todaysAppointment!.isEmpty
                    ? screenLoader()
                    : ListView.builder(
                        itemCount: todaysAppointment!.length,
                        itemBuilder: (context, index) {
                          return AppointmentCard(
                            bookingData: todaysAppointment![index],
                          );
                        }),
              ),
            )
          ],
        ),
      ),
    );
  }
}
