import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:flutter/material.dart';
import 'package:mysalon/elements/color.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mysalon/elements/fullviewbtn.dart';
import 'package:mysalon/services/auth/getUser.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mysalon/Screens/user/homepageuser.dart';
import 'package:mysalon/services/utility/changeScreen.dart';
import 'package:mysalon/services/initDataloader/salonloader.dart';
import 'package:mysalon/services/saveData/saveBookedAppointment.dart';

class PaymentScreen extends StatefulWidget {
  bool paymentDone;
  final dynamic data;
  PaymentScreen({super.key, this.paymentDone = true, this.data});

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  var mediaData = {};

  @override
  void initState() {
    super.initState();

    loadData();
  }

  loadData() async {
    print(widget.data);

    mediaData = await getSalonMediaById(context, widget.data["id"]);
    setState(() {});

    if (widget.paymentDone) {
      saveBookedAppointment();
    }
  }

  saveBookedAppointment() async {
    var user = await getCurrentUser();

    var data = {
      "salonId": widget.data["id"],
      "userId": user!.uid,
      "paymentId": widget.data["paymentID"],
      "timestamp": Timestamp.now(),
      "payment": widget.data["bookingCost"],
      "bookedSlot": widget.data["bookedSlot"],
      "bookingCost": widget.data["bookingCost"],
      "selectedDate": widget.data["selectedDate"],
      "selectedSpecialist": widget.data["selectedSpecialist"],
      "selectedServices": widget.data["selectedServices"],
      "status": "pending",
      "reviews": "",
      "isDone": false,
      "isPending": true,
      "isCompleted": false,
      "name": widget.data["name"],
      "mobile": widget.data["mobile"]
    };

    await saveMyBookedAppointment(context, data);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        bottomNavigationBar: Container(
          width: MediaQuery.of(context).size.width,
          height: 60,
          child: Center(
            child: Container(
              width: MediaQuery.of(context).size.width * 0.50,
              height: 60,
              child: InkWell(
                onTap: () {
                  if (widget.paymentDone) {
                    StartfromScreen(context, HomePageUser());
                  } else {
                    Navigator.of(context).pop();
                  }
                },
                child: fullviewbtn(
                  inverse: true,
                  text: widget.paymentDone ? "Home" : "Back",
                  isDisabled: false,
                  fontSize: 20,
                ),
              ),
            ),
          ),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: 60,
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                height: 220,
                alignment: Alignment.center,
                child: CircleAvatar(
                  radius: 320,
                  backgroundColor: widget.paymentDone
                      ? Color.fromARGB(255, 0, 168, 6)
                      : Colors.red,
                  child: Lottie.asset(
                      widget.paymentDone
                          ? 'assets/json/paymentDone.json'
                          : 'assets/json/paymentFailed.json',
                      width: 220,
                      fit: BoxFit.cover,
                      repeat: false),
                ),
              ),
              SizedBox(
                height: 60,
              ),
              Container(
                child: Text(
                  widget.paymentDone ? "Appointment Booked" : "Booking Failed",
                  style: GoogleFonts.inter(
                      color: Colors.black,
                      fontSize: 25,
                      fontWeight: FontWeight.bold),
                ),
              ),
              SizedBox(
                height: 5,
              ),
              Container(
                child: Text(
                  widget.paymentDone ? "Payment Done" : "Payment Failed",
                  style: GoogleFonts.inter(
                    color: Colors.black,
                    fontSize: 15,
                  ),
                ),
              ),
              SizedBox(
                height: 5,
              ),
              Container(
                child: Text(
                  DateFormat('dd-MM-yyyy hh:mm a')
                      .format(DateTime.now())
                      .toString(),
                  style: GoogleFonts.inter(
                    color: Colors.black,
                    fontSize: 15,
                  ),
                ),
              ),
              SizedBox(
                height: 30,
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                height: 250,
                alignment: Alignment.center,
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.90,
                  height: 250,
                  decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                            color: Color.fromARGB(164, 62, 62, 62),
                            blurRadius: 5,
                            spreadRadius: 1.5)
                      ],
                      color: primeColor,
                      borderRadius: BorderRadius.circular(10)),
                  child: Column(
                    children: [
                      Text(
                        "Appointment Card",
                        style: GoogleFonts.inter(
                            color: Colors.white, fontSize: 25),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Divider(
                        height: 2,
                        color: Colors.white,
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Expanded(
                        child: Stack(
                          children: [
                            Container(
                              margin: EdgeInsets.all(10),
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      Text(
                                        "Salon:",
                                        style: GoogleFonts.inter(
                                            color: Colors.black, fontSize: 15),
                                      ),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      Text(
                                        widget.data["salonName"],
                                        style: GoogleFonts.inter(
                                            color: Colors.white, fontSize: 20),
                                      )
                                    ],
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Row(
                                    children: [
                                      Text(
                                        "Date:",
                                        style: GoogleFonts.inter(
                                            color: Colors.black, fontSize: 15),
                                      ),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      Text(
                                        (widget.data["selectedDate"]),
                                        style: GoogleFonts.inter(
                                            color: Colors.white, fontSize: 20),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Row(
                                    children: [
                                      Text(
                                        "Slot:",
                                        style: GoogleFonts.inter(
                                            color: Colors.black, fontSize: 15),
                                      ),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      Text(
                                        widget.data["bookedSlot"],
                                        style: GoogleFonts.inter(
                                            color: Colors.white, fontSize: 20),
                                      )
                                    ],
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Row(
                                    children: [
                                      Text(
                                        "Booking Cost:",
                                        style: GoogleFonts.inter(
                                            color: Colors.black, fontSize: 15),
                                      ),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      Text(
                                        "${widget.data["bookingCost"]} INR",
                                        style: GoogleFonts.inter(
                                            color: Colors.white, fontSize: 20),
                                      )
                                    ],
                                  )
                                ],
                              ),
                            ),
                            Positioned(
                                right: 10,
                                bottom: 10,
                                child: Container(
                                  width: 100,
                                  height: 100,
                                  decoration: BoxDecoration(
                                      boxShadow: [
                                        BoxShadow(
                                            color:
                                                Color.fromARGB(143, 84, 84, 84),
                                            spreadRadius: 2.0,
                                            blurRadius: 2)
                                      ],
                                      image: DecorationImage(
                                          image: NetworkImage(mediaData[
                                                  "salonLogo"] ??
                                              "https://cdn.dribbble.com/users/2984251/screenshots/16200026/media/5f404ede522388e2e56976dad9c265f1.jpg?resize=400x300&vertical=center"),
                                          fit: BoxFit.cover),
                                      shape: BoxShape.circle,
                                      color: Colors.yellow),
                                ))
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
