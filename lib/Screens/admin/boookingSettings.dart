import 'package:flutter/material.dart';
import 'package:mysalon/elements/color.dart';
import 'package:mysalon/elements/topbar.dart';
import 'package:mysalon/elements/lightlabel.dart';
import 'package:mysalon/elements/warningbox.dart';
import 'package:mysalon/elements/custominputbox.dart';
import 'package:mysalon/services/getData/getBookingCost.dart';
import 'package:mysalon/services/saveData/savebookingSettings.dart';

class BookingSettings extends StatefulWidget {
  const BookingSettings({super.key});

  @override
  State<BookingSettings> createState() => _BookingSettingsState();
}

class _BookingSettingsState extends State<BookingSettings> {
  TextEditingController amount = TextEditingController();

  int balance = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    loadData();
  }

  loadData() async {
    var data = await getBookingCost();
    amount.text = data["cost"].toString();
    setState(() {});
  }

  saveCost() {
    SaveBookingCost(context, amount.text);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Column(
            children: [
              TopBarLabel(label: "Booking Settings"),
              Container(
                width: MediaQuery.of(context).size.width * 0.95,
                height: 350,
                decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                          color: const Color.fromARGB(85, 0, 0, 0),
                          spreadRadius: 2,
                          blurRadius: 5,
                          offset: Offset(0, 5))
                    ],
                    borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(20),
                        bottomRight: Radius.circular(20))),
                child: Column(
                  children: [
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      "Booking Cost",
                      style: TextStyle(fontSize: 30),
                    ),
                    SizedBox(
                      height: 50,
                    ),
                    Container(
                      child: CustomInputBox(
                        controller: amount,
                        placeholder: "Enter Cost Amount",
                        icons: Icons.attach_money_rounded,
                        text: "",
                        isNumber: true,
                      ),
                    ),
                    SizedBox(
                      height: 50,
                    ),
                    Text("Set Booking Cost for all salon"),
                    SizedBox(
                      height: 50,
                    ),
                    ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            fixedSize: Size(150, 50),
                            backgroundColor: primeColor,
                            foregroundColor: Colors.white),
                        onPressed: () {
                          if (amount.text.isNotEmpty) {
                            saveCost();
                          } else {
                            warningBox(context, "Add Cost");
                          }
                        },
                        child: Text(
                          "Save",
                          style: TextStyle(fontSize: 20),
                        ))
                  ],
                ),
              ),
              SizedBox(
                height: 30,
              ),
              // lightLabel(
              //   label: "History",
              //   isblack: true,
              // ),
              // SizedBox(
              //   height: 5,
              // ),
              // Container(
              //   width: MediaQuery.of(context).size.width * 0.95,
              //   height: 100 * 5,
              //   child: ListView.builder(
              //       physics: NeverScrollableScrollPhysics(),
              //       itemCount: 5,
              //       itemBuilder: (context, index) {
              //         return Container(
              //             width: MediaQuery.of(context).size.width * 0.95,
              //             height: 90,
              //             margin: EdgeInsets.only(top: 10),
              //             child: Card(
              //               elevation: 5,
              //               child: Row(
              //                 children: [
              //                   SizedBox(
              //                     width: 10,
              //                   ),
              //                   Icon(
              //                     Icons.document_scanner_sharp,
              //                     size: 40,
              //                     color: primeColor,
              //                   ),
              //                   SizedBox(
              //                     width: 10,
              //                   ),
              //                   Text(
              //                     "5rs Set on 10-02-2024 11:22",
              //                     style: TextStyle(
              //                         color: Colors.black,
              //                         fontWeight: FontWeight.bold),
              //                   )
              //                 ],
              //               ),
              //             ));
              //       }),
              // )
            ],
          ),
        ),
      ),
    );
  }
}
