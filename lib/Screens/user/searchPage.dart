import 'dart:ffi';
import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:mysalon/elements/color.dart';
import 'package:mysalon/elements/topbar.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mysalon/elements/lightlabel.dart';
import 'package:mysalon/elements/screenloader.dart';
import 'package:mysalon/elements/locationmodel.dart';
import 'package:mysalon/elements/salonCardland.dart';
import 'package:mysalon/elements/custominputbox.dart';
import 'package:mysalon/Screens/user/saloninfopage.dart';
import 'package:mysalon/services/utility/changeScreen.dart';
import 'package:mysalon/services/getData/getSameCitySalon.dart';

class SearchPage extends StatefulWidget {
  String searchByGender;
  int searchkm;

  bool searchbyGender;
  bool searchbykm;
  SearchPage(
      {super.key,
      this.searchByGender = "",
      this.searchkm = 0,
      this.searchbyGender = false,
      this.searchbykm = false});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  TextEditingController search = TextEditingController();

  double selectedSort = 1.0;

  List<Map<String, dynamic>> mysalons = [];
  List<Map<String, dynamic>>? searchsalons;
  List<Map<String, dynamic>>? staticStoreSalon;

  bool loading = true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    loadData();
  }

  loadData() async {
    mysalons = (await getSameCitySalon())!;

    if (mysalons.isNotEmpty) {
      print(mysalons[0]["id"]);
      print(mysalons[0]["distance"]);

      staticStoreSalon = mysalons;
    }

    loading = false;
    setState(() {});

    if (widget.searchbyGender) {
      filterSalon(widget.searchByGender);
    }

    if (widget.searchbykm) {
      filterSalonByDistance(widget.searchkm);
    }
  }

  filterSalon(String SalonFor) {
    mysalons = staticStoreSalon!;
    setState(() {});

    int sf = 0;

    if (SalonFor == "male") {
      sf = 1;
    } else if (SalonFor == "female") {
      sf = 2;
    } else if (SalonFor == "unisex") {
      sf = 3;
    }

    searchsalons = staticStoreSalon;

    mysalons = searchsalons!.where((salon) {
      int salonFor = salon["salonFor"];
      return salonFor == sf;
    }).toList();

    setState(() {});
  }

  filterSalonByDistance(int distance) {
    mysalons = staticStoreSalon!;
    setState(() {});

    searchsalons = staticStoreSalon;

    mysalons = searchsalons!.where((salon) {
      int salonFor = salon["distance"];
      return salonFor <= distance;
    }).toList();

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Column(
            children: [
              TopBarLabel(label: "Search Salon"),
              SizedBox(
                height: 10,
              ),
              Container(
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
                          border: Border.all(width: 0.5, color: Colors.black)),
                      child: Row(
                        children: [
                          Container(
                            width: MediaQuery.of(context).size.width * 0.70,
                            child: Center(
                              child: TextField(
                                controller: search,
                                decoration: InputDecoration(
                                    counterText: '',
                                    prefixIcon: Icon(
                                      Icons.search,
                                      size: 30,
                                      color: primeColor,
                                    ),
                                    hintText: "Search Salon"),
                                onChanged: (e) {
                                  if (e.isEmpty) {
                                    mysalons = staticStoreSalon!;
                                    setState(() {});
                                  } else {
                                    searchsalons = staticStoreSalon;

                                    mysalons = searchsalons!
                                        .where((salon) => salon["salonName"]
                                            .toLowerCase()
                                            .contains(e.toLowerCase()))
                                        .toList();

                                    setState(() {});
                                  }
                                },
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    InkWell(
                      onTap: () {
                        showModalBottomSheet(
                            context: context,
                            builder: (context) {
                              return StatefulBuilder(builder: (context, state) {
                                return Container(
                                  width: MediaQuery.of(context).size.width,
                                  height:
                                      MediaQuery.of(context).size.height * 0.40,
                                  child: Column(
                                    children: [
                                      Text(
                                        "Filters",
                                        style: GoogleFonts.inter(
                                            color: primeColor,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 30),
                                      ),
                                      lightLabel(
                                        label: "Distance: " +
                                            selectedSort.toString() +
                                            " KM",
                                        isblack: true,
                                      ),
                                      Slider(
                                          thumbColor: primeColor,
                                          activeColor: primeColor,
                                          min: 0,
                                          max: 10,
                                          label:
                                              selectedSort.round().toString(),
                                          value: selectedSort,
                                          divisions: 10,
                                          onChanged: (e) {
                                            print(e);
                                            setState(() {
                                              selectedSort = e.roundToDouble();
                                              var selectedSorts =
                                                  e.roundToDouble().toInt();

                                              filterSalonByDistance(
                                                  selectedSorts);
                                              state(() {});
                                            });
                                          }),
                                      SizedBox(
                                        height: 20,
                                      ),
                                      lightLabel(
                                        label: "Salon for only",
                                        isblack: true,
                                      ),
                                      SizedBox(
                                        height: 20,
                                      ),
                                      Container(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.80,
                                        height: 70,
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            ElevatedButton(
                                                style: ElevatedButton.styleFrom(
                                                    backgroundColor:
                                                        primeColor),
                                                onPressed: () {
                                                  filterSalon("male");
                                                },
                                                child: Text(
                                                  "Male",
                                                  style: TextStyle(
                                                      color: Colors.white),
                                                )),
                                            ElevatedButton(
                                                style: ElevatedButton.styleFrom(
                                                    backgroundColor:
                                                        primeColor),
                                                onPressed: () {
                                                  filterSalon("female");
                                                },
                                                child: Text(
                                                  "Female",
                                                  style: TextStyle(
                                                      color: Colors.white),
                                                )),
                                            ElevatedButton(
                                                style: ElevatedButton.styleFrom(
                                                    backgroundColor:
                                                        primeColor),
                                                onPressed: () {
                                                  filterSalon("unisex");
                                                },
                                                child: Text(
                                                  "Unisex",
                                                  style: TextStyle(
                                                      color: Colors.white),
                                                ))
                                          ],
                                        ),
                                      ),
                                      Spacer(),
                                      ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                              backgroundColor: primeColor),
                                          onPressed: () {
                                            mysalons = staticStoreSalon!;
                                            setState(() {});
                                          },
                                          child: Text(
                                            "Reset",
                                            style:
                                                TextStyle(color: Colors.white),
                                          )),
                                      SizedBox(
                                        height: 20,
                                      )
                                    ],
                                  ),
                                );
                              });
                            });
                      },
                      child: Container(
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
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                  ],
                ),
              ),
              loading && mysalons.isEmpty
                  ? screenLoader()
                  : Container(
                      width: MediaQuery.of(context).size.width,
                      height: (170 * mysalons.length).toDouble(),
                      child: ListView.builder(
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: mysalons.length,
                          itemBuilder: (context, index) {
                            return InkWell(
                              onTap: () {
                                nextScreen(context,
                                    SalonInfoPage(salonData: mysalons[index]));
                              },
                              child: SalonCardLand(
                                salondata: mysalons[index],
                                isAds: mysalons[index]["isAds"],
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
