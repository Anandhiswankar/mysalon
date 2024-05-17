import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:mysalon/elements/color.dart';
import 'package:mysalon/elements/topbar.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mysalon/elements/specialist.dart';
import 'package:mysalon/elements/lightlabel.dart';
import 'package:mysalon/elements/fullviewbtn.dart';
import 'package:mysalon/services/auth/getUser.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:mysalon/elements/custominputbox.dart';
import 'package:mysalon/Screens/user/payment/payment.dart';
import 'package:mysalon/services/utility/changeScreen.dart';
import 'package:mysalon/services/initDataloader/salonloader.dart';
// import 'package:razorpay_flutter/razorpay_flutter.dart';

class BookAppointmentB extends StatefulWidget {
  final dynamic data;
  const BookAppointmentB({super.key, this.data});

  @override
  State<BookAppointmentB> createState() => _BookAppointmentBState();
}

class _BookAppointmentBState extends State<BookAppointmentB> {
  TextEditingController mobile = TextEditingController();
  TextEditingController name = TextEditingController();

  List<dynamic> solonOffers = [
    'Haircut',
  ];
  List<String> solonOffersSelected = [];

  int selectedSpecialist = 999;

  // late Razorpay razorpay;

  @override
  void initState() {
    super.initState();

    loadData();

    // razorpay = Razorpay();
    // // Set up event handlers
    // razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, errorHandler);
    // razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, successHandler);
    // razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, externalWalletHandler);  //removed
  }

  // void errorHandler(PaymentFailureResponse response) {
  //   // Display a red-colored SnackBar with the error message
  //   // ScaffoldMessenger.of(context).showSnackBar(SnackBar(
  //   //   content: Text(response.message!),
  //   //   backgroundColor: Colors.red,
  //   // ));

  //   var data = {
  //     ...updatedData,
  //     "paymentCode": response.code,
  //     "paymentMsg": response.message,
  //     "paymentError": response.error,
  //     "paymentID": "",
  //     "orderID": "",
  //     "paymentSignature": "",
  //     "paymentWallet": ""
  //   };

  //   nextScreen(
  //       context,
  //       PaymentScreen(
  //         data: data,
  //         paymentDone: false,
  //       ));
  // }

  // void successHandler(PaymentSuccessResponse response) {
  //   // Display a green-colored SnackBar with the payment ID

  //   var data = {
  //     ...updatedData,
  //     "paymentCode": "",
  //     "paymentMsg": "",
  //     "paymentError": "",
  //     "paymentID": response.paymentId,
  //     "orderID": response.orderId,
  //     "paymentSignature": response.signature,
  //     "paymentWallet": ""
  //   };
  //   nextScreen(
  //       context,
  //       PaymentScreen(
  //         data: data,
  //         paymentDone: true,
  //       ));
  // }

  // void externalWalletHandler(ExternalWalletResponse response) {
  //   // Display a green-colored SnackBar with the name of the external wallet used

  //   var data = {
  //     ...updatedData,
  //     "paymentCode": "",
  //     "paymentMsg": "",
  //     "paymentError": "",
  //     "paymentID": "",
  //     "orderID": "",
  //     "paymentSignature": "",
  //     "paymentWallet": response.walletName
  //   };
  //   nextScreen(
  //       context,
  //       PaymentScreen(
  //         data: data,
  //         paymentDone: true,
  //       ));
  // }

  var mediaData = {};
  var specialist = {};

  var servicesList = {};

  var updatedData = {};

  loadData() async {
    mediaData = await getSalonMediaById(context, widget.data["id"]);
    specialist = await getSalonSpecialistByid(context, widget.data["id"]);
    servicesList = await getSalonServicesbyId(context, widget.data["id"]);

    solonOffers.clear();
    solonOffers = servicesList["salonOffer"];

    setState(() {});
  }

  makePayment() async {
    var user = await getCurrentUser();
    var options = {
      "key": "rzp_test_n0I2b9deWk8ich",
      "amount": num.parse(widget.data["bookingCost"].toString()) * 100,
      "name": user!.displayName,
      "description": "Appointment Bookig",
      "timeout": "500",
      "currency": "INR",
      "prefill": {
        "contact": "11111111111",
        "email": user!.email,
      }
    };
    // razorpay.open(options);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Column(
            children: [
              TopBarLabel(label: "Book Appointment"),
              SizedBox(
                height: 20,
              ),
              lightLabel(
                label: "Appointment Details",
                fontSize: 20,
              ),
              SizedBox(
                height: 20,
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
              SizedBox(
                height: 20,
              ),
              lightLabel(label: "Select Specialist"),
              Container(
                width: MediaQuery.of(context).size.width,
                height: (150 * specialist.length).toDouble(),
                margin: EdgeInsets.only(left: 10),
                child: ListView.builder(
                    itemCount: specialist.length,
                    physics: NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) {
                      return InkWell(
                        onTap: () {
                          selectedSpecialist = index;
                          setState(() {});
                        },
                        child: Container(
                            margin: EdgeInsets.all(10),
                            child: SpecialistCard(
                              isSelected:
                                  selectedSpecialist == index ? true : false,
                              name: specialist["specialist"][index]["name"],
                              info: specialist["specialist"][index]["info"],
                              profile: specialist["specialist"][index]
                                  ["profile"],
                              showEditIcon: false,
                            )),
                      );
                    }),
              ),
              SizedBox(
                height: 10,
              ),
              lightLabel(
                label: "Select Service",
                fontSize: 20,
              ),
              SizedBox(
                height: 10,
              ),
              Container(
                width: MediaQuery.of(context).size.width * 0.96,
                child: Wrap(
                  spacing: 8.0,
                  runSpacing: 8.0,
                  children: solonOffers.map((day) {
                    return InkWell(
                      onTap: () {
                        if (solonOffersSelected.contains(day)) {
                          solonOffersSelected.remove(day);
                        } else {
                          solonOffersSelected.add(day);
                        }

                        setState(() {});
                      },
                      child: Chip(
                        label: Text(day),
                        avatar: Icon(
                          solonOffersSelected.contains(day)
                              ? Icons.circle
                              : Icons.circle_outlined,
                          color: Colors.white,
                        ),
                        elevation: 2.0,
                        backgroundColor: primeColor,
                        labelStyle: TextStyle(color: Colors.white),
                      ),
                    );
                  }).toList(),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              lightLabel(
                label: "Booking for",
                fontSize: 20,
              ),
              CustomInputBox(
                  placeholder: "Enter Name",
                  icons: Icons.person,
                  controller: name,
                  text: ""),
              SizedBox(
                height: 20,
              ),
              CustomInputBox(
                  placeholder: "Enter Phonenumber",
                  icons: Icons.call,
                  controller: mobile,
                  isNumber: true,
                  text: ""),
              SizedBox(
                height: 20,
              ),
              Container(
                width: MediaQuery.of(context).size.width * 0.50,
                height: 80,
                child: InkWell(
                  onTap: () {
                    print(mobile.text.length);

                    if (selectedSpecialist == 999 ||
                        solonOffersSelected.isEmpty ||
                        name.text.isEmpty ||
                        mobile.text.isEmpty ||
                        mobile.text.length != 10) {
                      Fluttertoast.showToast(msg: "Select required fields");
                      return;
                    } else {
                      updatedData = {
                        ...widget.data,
                        "selectedSpecialist": specialist["specialist"]
                            [selectedSpecialist],
                        "selectedServices": solonOffersSelected,
                        "name": name.text,
                        "mobile": mobile.text
                      };

                      setState(() {});

                      makePayment();
                    }
                  },
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width * 0.50,
                    child: fullviewbtn(
                      inverse: true,
                      text: "Make Payment",
                      isDisabled: selectedSpecialist == 999 ||
                              solonOffersSelected.isEmpty ||
                              name.text.isEmpty ||
                              mobile.text.isEmpty ||
                              mobile.text.length != 10
                          ? true
                          : false,
                      fontSize: 20,
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 25,
              ),
              lightLabel(label: "About Booking"),
              SizedBox(
                height: 5,
              ),
              Container(
                  width: MediaQuery.of(context).size.width * 0.90,
                  child: Text(
                      "All test base and boss and main test code and test code and test test ")),
              SizedBox(
                height: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
