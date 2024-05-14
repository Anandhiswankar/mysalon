import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:mysalon/elements/color.dart';
import 'package:mysalon/elements/topbar.dart';
import 'package:google_fonts/google_fonts.dart';

class paymentPage extends StatefulWidget {
  final dynamic paymentData;
  const paymentPage({super.key, this.paymentData});

  @override
  State<paymentPage> createState() => _paymentPageState();
}

class _paymentPageState extends State<paymentPage> {
  @override
  void initState() {
    super.initState();

    loadData();
  }

  int totalBalance = 0;

  loadData() {
    for (int i = 0; i < widget.paymentData.length; i++) {
      totalBalance += int.parse(widget.paymentData[i]["payment"].toString());
    }

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            TopBarLabel(label: "Payments"),
            SizedBox(
              height: 20,
            ),
            Container(
              width: MediaQuery.of(context).size.width * 0.90,
              height: 200,
              decoration: BoxDecoration(
                  color: primeColor, borderRadius: BorderRadius.circular(10)),
              alignment: Alignment.center,
              child: Container(
                height: 100,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      child: Column(
                        children: [
                          Text(
                            "Today Balance",
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 20,
                                fontWeight: FontWeight.bold),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Text(
                            totalBalance.toString() + " INR",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.bold),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Row(
                            children: [
                              Icon(
                                Icons.circle,
                                color: Colors.white,
                                size: 10,
                              ),
                              SizedBox(
                                width: 50,
                                child: Divider(
                                  height: 5,
                                  thickness: 2,
                                ),
                              ),
                              Icon(
                                Icons.circle,
                                color: Colors.white,
                                size: 10,
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                    // SizedBox(
                    //   width: 10,
                    // ),
                    // Container(
                    //   child: Column(
                    //     children: [
                    //       Text(
                    //         "Last Day",
                    //         style: TextStyle(
                    //             color: Colors.black,
                    //             fontSize: 20,
                    //             fontWeight: FontWeight.bold),
                    //       ),
                    //       SizedBox(
                    //         height: 10,
                    //       ),
                    //       Text(
                    //         "12",
                    //         style: TextStyle(
                    //             color: Colors.white,
                    //             fontSize: 20,
                    //             fontWeight: FontWeight.bold),
                    //       ),
                    //       SizedBox(
                    //         height: 10,
                    //       ),
                    //       Row(
                    //         children: [
                    //           Icon(
                    //             Icons.circle,
                    //             color: Colors.white,
                    //             size: 10,
                    //           ),
                    //           SizedBox(
                    //             width: 50,
                    //             child: Divider(
                    //               height: 5,
                    //               thickness: 2,
                    //             ),
                    //           ),
                    //           Icon(
                    //             Icons.circle,
                    //             color: Colors.white,
                    //             size: 10,
                    //           ),
                    //         ],
                    //       )
                    //     ],
                    //   ),
                    // ),
                    // SizedBox(
                    //   width: 10,
                    // ),
                    // Container(
                    //   child: Column(
                    //     children: [
                    //       Text(
                    //         "This Month",
                    //         style: TextStyle(
                    //             color: Colors.black,
                    //             fontSize: 20,
                    //             fontWeight: FontWeight.bold),
                    //       ),
                    //       SizedBox(
                    //         height: 10,
                    //       ),
                    //       Text(
                    //         "12",
                    //         style: TextStyle(
                    //             color: Colors.white,
                    //             fontSize: 20,
                    //             fontWeight: FontWeight.bold),
                    //       ),
                    //       SizedBox(
                    //         height: 10,
                    //       ),
                    //       Row(
                    //         children: [
                    //           Icon(
                    //             Icons.circle,
                    //             color: Colors.white,
                    //             size: 10,
                    //           ),
                    //           SizedBox(
                    //             width: 50,
                    //             child: Divider(
                    //               height: 5,
                    //               thickness: 2,
                    //             ),
                    //           ),
                    //           Icon(
                    //             Icons.circle,
                    //             color: Colors.white,
                    //             size: 10,
                    //           ),
                    //         ],
                    //       )
                    //     ],
                    //   ),
                    // ),
                    // SizedBox(
                    //   width: 10,
                    // ),
                    // Container(
                    //   child: Column(
                    //     children: [
                    //       Text(
                    //         "Total",
                    //         style: TextStyle(
                    //             color: Colors.black,
                    //             fontSize: 20,
                    //             fontWeight: FontWeight.bold),
                    //       ),
                    //       SizedBox(
                    //         height: 10,
                    //       ),
                    //       Text(
                    //         "12",
                    //         style: TextStyle(
                    //             color: Colors.white,
                    //             fontSize: 20,
                    //             fontWeight: FontWeight.bold),
                    //       ),
                    //       SizedBox(
                    //         height: 10,
                    //       ),
                    //       Row(
                    //         children: [
                    //           Icon(
                    //             Icons.circle,
                    //             color: Colors.white,
                    //             size: 10,
                    //           ),
                    //           SizedBox(
                    //             width: 50,
                    //             child: Divider(
                    //               height: 5,
                    //               thickness: 2,
                    //             ),
                    //           ),
                    //           Icon(
                    //             Icons.circle,
                    //             color: Colors.white,
                    //             size: 10,
                    //           ),
                    //         ],
                    //       )
                    //     ],
                    //   ),
                    // )
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Container(
              width: MediaQuery.of(context).size.width * 0.95,
              height: (170 * widget.paymentData.length).toDouble(),
              child: ListView.builder(
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: widget.paymentData.length,
                  itemBuilder: (context, index) {
                    return Container(
                      margin: EdgeInsets.all(10),
                      width: MediaQuery.of(context).size.width,
                      height: 50,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                                color: const Color.fromARGB(95, 0, 0, 0),
                                spreadRadius: 2,
                                blurRadius: 5)
                          ],
                          borderRadius: BorderRadius.circular(20)),
                      child: Row(
                        children: [
                          SizedBox(
                            width: 20,
                          ),
                          Container(
                            width: MediaQuery.of(context).size.width * 0.60,
                            height: 150,
                            alignment: Alignment.center,
                            child: SizedBox(
                                height: 130,
                                child: Center(
                                  child: Text(
                                      widget.paymentData[index]["bookingId"]),
                                )),
                          ),
                          Spacer(),
                          Container(
                              child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                backgroundColor: primeColor,
                                foregroundColor: Colors.white),
                            onPressed: () {},
                            child: Text(widget.paymentData[index]["payment"]
                                    .toString() +
                                " INR"),
                          )),
                          Spacer(),
                        ],
                      ),
                    );
                  }),
            ),
          ],
        ),
      ),
    ));
  }
}
