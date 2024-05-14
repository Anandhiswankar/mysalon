import 'package:flutter/material.dart';
import 'package:mysalon/elements/color.dart';
import 'package:mysalon/elements/topbar.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mysalon/Screens/admin/userrinfo.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mysalon/services/utility/changeScreen.dart';
import 'package:mysalon/services/getData/getadminstate.dart';

class ListOfUser extends StatefulWidget {
  int filtercode;
  ListOfUser({super.key, this.filtercode = 0});

  @override
  State<ListOfUser> createState() => _ListOfUserState();
}

class _ListOfUserState extends State<ListOfUser> {
  List<QueryDocumentSnapshot<dynamic>> userCount = [];
  List<QueryDocumentSnapshot<dynamic>> userCountback = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    loadData();
  }

  loadData() async {
    if (widget.filtercode == 0) {
      userCount = (await getAdminStateUser())!;
    } else if (widget.filtercode == 1) {
      userCount = (await getAdminStateUserFilter(isFilter: "today"))!;
    } else if (widget.filtercode == 2) {
      userCount = (await getAdminStateUserFilter(isFilter: "thismonth"))!;
    } else if (widget.filtercode == 3) {
      userCount = (await getAdminStateUserFilter(isFilter: "6month"))!;
    }

    userCountback = userCount;

    setState(() {});
  }

  getUsersWithEnableTrue(List<QueryDocumentSnapshot<dynamic>> userList) {
    userList = userCountback;
    // Filter the list to include only users with isEnable = true
    List<QueryDocumentSnapshot<dynamic>> enabledUsers =
        userList.where((userDoc) {
      return userDoc.data()['isEnable'] == true;
    }).toList();

    userCount = enabledUsers;
    setState(() {});
  }

  getUsersWithEnableFalse(List<QueryDocumentSnapshot<dynamic>> userList) {
    userList = userCountback;
    // Filter the list to include only users with isEnable = true
    List<QueryDocumentSnapshot<dynamic>> enabledUsers =
        userList.where((userDoc) {
      return userDoc.data()['isEnable'] == false;
    }).toList();

    userCount = enabledUsers;
    setState(() {});
  }

  int activeTab = 0;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            TopBarLabel(label: "Users"),
            Container(
              width: MediaQuery.of(context).size.width,
              height: 60,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    InkWell(
                      onTap: () {
                        loadData();
                        activeTab = 0;
                        setState(() {});
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          color: activeTab == 0 ? primeColor : Colors.white,
                        ),
                        padding: EdgeInsets.only(
                            left: 20, right: 20, top: 10, bottom: 10),
                        margin: EdgeInsets.all(5),
                        child: Text(
                          "All",
                          style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 17),
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        getUsersWithEnableTrue(userCount);
                        activeTab = 1;
                        setState(() {});
                      },
                      child: Container(
                        decoration: BoxDecoration(
                            boxShadow: [
                              BoxShadow(
                                  color: Color.fromARGB(102, 134, 134, 134),
                                  blurRadius: 2,
                                  spreadRadius: 2)
                            ],
                            borderRadius: BorderRadius.circular(5),
                            color: activeTab == 1 ? primeColor : Colors.white),
                        padding: EdgeInsets.only(
                            left: 20, right: 20, top: 10, bottom: 10),
                        margin: EdgeInsets.all(5),
                        child: Text(
                          "Active",
                          style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 17),
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        getUsersWithEnableFalse(userCount);
                        activeTab = 2;
                        setState(() {});
                      },
                      child: Container(
                        decoration: BoxDecoration(
                            boxShadow: [
                              BoxShadow(
                                  color: Color.fromARGB(102, 134, 134, 134),
                                  blurRadius: 2,
                                  spreadRadius: 2)
                            ],
                            borderRadius: BorderRadius.circular(5),
                            color: activeTab == 2 ? primeColor : Colors.white),
                        padding: EdgeInsets.only(
                            left: 20, right: 20, top: 10, bottom: 10),
                        margin: EdgeInsets.all(5),
                        child: Text(
                          "InActive",
                          style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 17),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Container(
              width: MediaQuery.of(context).size.width * 0.95,
              height: (120 * userCount.length).toDouble(),
              child: ListView.builder(
                  itemCount: userCount.length,
                  itemBuilder: (context, index) {
                    return InkWell(
                      onTap: () {
                        nextScreen(
                            context,
                            UserInfoAdmin(
                              userData: userCount[index],
                            ));
                      },
                      child: userlistCard(context, userCount[index].data(),
                          isEnable: userCount[index].data()["isEnable"]
                              ? true
                              : false),
                    );
                  }),
            ),
          ],
        ),
      ),
    );
  }

  Container userlistCard(BuildContext context, dynamic userData,
      {bool isEnable = true}) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.80,
      height: 90,
      margin: EdgeInsets.all(10),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
                color: Color.fromARGB(111, 0, 0, 0),
                spreadRadius: 2,
                blurRadius: 5,
                offset: Offset(0, 3))
          ]),
      child: Row(
        children: [
          SizedBox(
            width: 15,
          ),
          CircleAvatar(
            radius: 30,
            backgroundColor: Colors.black,
            backgroundImage: NetworkImage(userData["profile"] ??
                "https://images.pexels.com/photos/1036623/pexels-photo-1036623.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1"),
          ),
          SizedBox(
            width: 10,
          ),
          Text(
            userData["displayName"],
            style: GoogleFonts.inter(color: Colors.black, fontSize: 20),
          ),
          Spacer(),
          CircleAvatar(
            radius: 10,
            backgroundColor: isEnable ? Colors.green : Colors.red,
          ),
          SizedBox(
            width: 20,
          )
        ],
      ),
    );
  }
}
