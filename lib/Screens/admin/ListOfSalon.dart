import 'package:flutter/material.dart';
import 'package:mysalon/elements/color.dart';
import 'package:mysalon/elements/topbar.dart';
import 'package:mysalon/elements/salonCardland.dart';
import 'package:mysalon/elements/custominputbox.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mysalon/Screens/user/saloninfopage.dart';
import 'package:mysalon/services/utility/changeScreen.dart';
import 'package:mysalon/services/getData/getadminstate.dart';
import 'package:mysalon/services/getData/getSameCitySalon.dart';

class ListOfSalons extends StatefulWidget {
  final int filtercode;

  ListOfSalons({Key? key, this.filtercode = 0}) : super(key: key);

  @override
  State<ListOfSalons> createState() => _ListOfSalonsState();
}

class _ListOfSalonsState extends State<ListOfSalons> {
  TextEditingController search = TextEditingController();

  List<dynamic> userCount = [];
  List<dynamic> userCountback = [];

  @override
  void initState() {
    super.initState();
    load();
  }

  Future<void> load() async {
    print(widget.filtercode);
    if (widget.filtercode == 0) {
      userCount = await getAdminAllSalons() ?? [];
    } else if (widget.filtercode == 1) {
      userCount = await getAdminStateSalonFilter(isFilter: "today") ?? [];
    } else if (widget.filtercode == 2) {
      userCount = await getAdminStateSalonFilter(isFilter: "thismonth") ?? [];
    } else if (widget.filtercode == 3) {
      userCount = await getAdminStateSalonFilter(isFilter: "6month") ?? [];
    }

    userCountback = userCount;
    setState(() {});
    print(userCount);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Column(
            children: [
              TopBarLabel(label: "Salons"),
              Container(
                margin: const EdgeInsets.only(left: 10, right: 10, top: 10),
                width: MediaQuery.of(context).size.width,
                child: TextField(
                  controller: search,
                  decoration: InputDecoration(
                    hintText: "Search Salon",
                    prefixIcon: Icon(Icons.search),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(color: Colors.black, width: 0.5),
                    ),
                    fillColor: Colors.white,
                    filled: true,
                  ),
                  onChanged: (e) {
                    if (e.isEmpty) {
                      userCount = userCountback!;
                      setState(() {});
                    } else {
                      userCount = userCountback;

                      userCount = userCountback!
                          .where((salon) => salon["salonName"]
                              .toLowerCase()
                              .contains(e.toLowerCase()))
                          .toList();

                      setState(() {});
                    }
                  },
                ),
              ),
              userCount.isEmpty
                  ? const Text("No Data Found")
                  : SizedBox(
                      height: (170 * userCount.length).toDouble(),
                      child: ListView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: userCount.length,
                        itemBuilder: (context, index) {
                          return InkWell(
                            onTap: () {
                              nextScreen(
                                  context,
                                  SalonInfoPage(
                                    salonData: userCount[index],
                                    isAdmin: true,
                                  ));
                            },
                            child: SalonCardLand(
                              salondata: userCount[index],
                              isAds: false,
                            ),
                          );
                        },
                      ),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
